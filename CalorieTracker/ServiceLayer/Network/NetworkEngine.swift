//
//  NetworkEngine.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 09.08.2022.

import Alamofire
import Foundation
import Gzip

typealias GenericResult<T> = (Result<T, ErrorDomain>) -> Void
protocol NetworkEngineInterface {
    func fetchProducts(completion: @escaping ProductsResult )
    func fetchDishes(completion: @escaping DishesResponse)
}

enum ErrorDomain: Error {
    case AFError(error: AFError?)
}

enum RequestGenerator {
    enum LinkLanguageCodes: String, CaseIterable {
        case ru
        case en
        case de
        case usa
        case fr
        
        static func suggestLanguagePrefix(request: RequestGenerator) -> LinkLanguageCodes {
            let currentLanguageCode = Locale.current.languageCode
            switch request {
            case .fetchProductZipped:
                if let targetCode = LinkLanguageCodes.allCases.first(where: { $0.rawValue == currentLanguageCode }) {
                    return targetCode
                } else {
                    return .en
                }
            case .fetchDishesZipped:
                if let targetCode = LinkLanguageCodes.allCases.first(where: { $0.rawValue == currentLanguageCode }) {
                    switch (UDM.isMetric, targetCode == .en) {
                    case (true, true):
                        return .en
                    case (false, true):
                        return .usa
                    default:
                        return targetCode
                    }
                } else {
                    return .en
                }
            }
        }
    }
    
    case fetchProductZipped
    case fetchDishesZipped
    
    private var backendToken: String {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("Couldn't find file 'Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "backendKey") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
        }
        return value
    }
    
    /// Возвращает собранный URLRequest
    var request: URLRequest {
        let langCode = LinkLanguageCodes.suggestLanguagePrefix(request: self)
        var url: URL
        
        func injectTokenQuery(for url: inout URL) {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems == nil
            ? components?.queryItems = [.init(name: "token", value: backendToken)]
            : components?.queryItems?.append(.init(name: "token", value: backendToken))
            guard let newUrl = components?.url else {
                return
                
            }
            url = newUrl
        }
        
        switch self {
        case .fetchProductZipped:
            guard let optUrl = URL(string: "https://tracker.finanse.space/archive/\(langCode)_products.json.gz") else {
                fatalError("wrong url")
            }
            url = optUrl
        case .fetchDishesZipped:
            guard let optUrl = URL(string: "https://tracker.finanse.space/archive/\(langCode)_dish.json.gz") else {
                fatalError("wrong url")
            }
            url = optUrl
        }
       
        let request = URLRequest(url: url)
        return request
    }
}

final class NetworkEngine {
    
    /// Core method
    /// - Parameters:
    ///   - request: прокидываем сюда значение enum RequestGenerator, который собирает request  c нужными параметрами
    ///   - completion: стандартный хендлер, тип - generic Result((Result<T, ErrorDomain>) -> Void,  тоесть подкинуть можно вместо Т
    ///   то угодно комформящееся Codable
    private func performDecodableRequest<T: Codable>(
        request: RequestGenerator,
        completion: @escaping ((Result<T, ErrorDomain>) -> Void)
    ) {
        AF.request(request.request)
            .validate()
            .responseDecodable(
                of: T.self,
                queue: .global(qos: .userInitiated),
                dataPreprocessor: .gzipPreprocessor
            ) { result in
                guard let data = result.value else {
                    completion(.failure(.AFError(error: result.error)))
                    return
                }
                completion(.success(data))
            }
    }
    
}

extension NetworkEngine: NetworkEngineInterface {
    func fetchProducts(completion: @escaping ProductsResult ) {
        performDecodableRequest(request: .fetchProductZipped, completion: completion)
    }
    
    func fetchDishes(completion: @escaping DishesResponse) {
        performDecodableRequest(request: .fetchDishesZipped, completion: completion)
    }
}
