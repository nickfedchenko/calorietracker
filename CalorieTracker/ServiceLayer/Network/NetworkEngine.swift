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
    func remoteSearch(by phrase: String, completion: @escaping SearchProductsResponse)
}

enum ErrorDomain: Error {
    case AFError(error: AFError?)
}

enum RequestGenerator {
    enum LinkLanguageCodes: String, CaseIterable {
        case ru
        case en
        case de
        case sp
        case fr
        case it
        
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
                    return targetCode
                } else {
                    return .en
                }
            case  .searchProduct(by: _):
                if let targetCode = LinkLanguageCodes.allCases.first(where: { $0.rawValue == currentLanguageCode }) {
                    return targetCode
                } else {
                    return .en
                }
            }
        }
    }
    
    case fetchProductZipped
    case fetchDishesZipped
    case searchProduct(by: String)
    
    private var backendToken: String {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("Couldn't find file 'Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "backendKey") as? String else {
            fatalError("Couldn't find key 'backendKey' in 'Info.plist'.")
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
        
        func prepareSearchUrl(url: inout URL, by phrase: String) {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems?.append(.init(name: "lang", value: langCode.rawValue))
            components?.queryItems?.append(.init(name: "q", value: phrase))
            guard let newUrl = components?.url else {
                return
            }
            url = newUrl
        }
        
        switch self {
        case .searchProduct(by: let phrase):
            guard var optUrl = URL(string: "http://tracker.finanse.space/api/search") else {
                fatalError("wrong url")
            }
            injectTokenQuery(for: &optUrl)
            prepareSearchUrl(url: &optUrl, by: phrase)
            url = optUrl
        case .fetchProductZipped:
            guard let optUrl = URL(string: "https://newketo.finanse.space/storage/json/products_\(langCode).json.gz") else {
                fatalError("wrong url")
            }
            url = optUrl
        case .fetchDishesZipped:
            guard let optUrl = URL(string: "https://newketo.finanse.space/storage/json/dish_\(langCode).json.gz") else {
                fatalError("wrong url")
            }
            url = optUrl
        }
       
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        return request
    }
}

final class NetworkEngine {
    
    static let shared: NetworkEngineInterface = NetworkEngine()
    
    /// Core method
    /// - Parameters:
    ///   - request: прокидываем сюда значение enum RequestGenerator, который собирает request  c нужными параметрами
    ///   - completion: стандартный хендлер, тип - generic Result((Result<T, ErrorDomain>) -> Void,  тоесть подкинуть можно вместо Т
    ///   то угодно комформящееся Codable
    private func performDecodableRequest<T: Codable>(
        request: RequestGenerator,
        completion: @escaping ((Result<T, ErrorDomain>) -> Void)
    ) {
        let secondsNow = Date().timeIntervalSince1970
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
                print("received data in \(Date().timeIntervalSince1970 - secondsNow) seconds")
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
    
    func remoteSearch(by phrase: String, completion: @escaping SearchProductsResponse) {
        performDecodableRequest(request: .searchProduct(by: phrase), completion: completion)
    }
}
