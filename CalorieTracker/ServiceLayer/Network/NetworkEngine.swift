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
    func remoteSearchSecond(by phrase: String, completion: @escaping ProductsSearchResult)
    func remoteSearchByBarcode(by barcode: String, completion: @escaping ProductsSearchResult)
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
            case .searchProductByBarcode(barcode: _):
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
    case searchProductByBarcode(barcode: String)
    
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
        
        func injectTokenQuery(for request: inout URLRequest) {
            request.addValue(backendToken, forHTTPHeaderField: "Authorization")
        }
        
        func prepareSearchUrl(url: inout URL, by phrase: String) {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = [
                .init(name: "langCode", value: langCode.rawValue),
                .init(name: "search_term", value: phrase)
            ]
            guard let newUrl = components?.url else {
                return
            }
            url = newUrl
            print("search url \(url)")
        }
        
        func prepareSearchUrl(url: inout URL, byBarcode: String) {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = [
                .init(name: "langCode", value: langCode.rawValue),
                .init(name: "barcode", value: byBarcode)
            ]
            guard let newUrl = components?.url else {
                return
            }
            url = newUrl
            print("search url \(url)")
        }
        
        switch self {
        case let .searchProductByBarcode(barcode: barcode):
            guard var optUrl = URL(string: "https://ketodietapplication.site/api/search/barcode/off") else {
                fatalError("wrong url")
            }
            prepareSearchUrl(url: &optUrl, byBarcode: barcode)
            url = optUrl
            
        case .searchProduct(by: let phrase):
            guard var optUrl = URL(string: "https://ketodietapplication.site/api/search/barcode/off") else {
                fatalError("wrong url")
            }
            prepareSearchUrl(url: &optUrl, by: phrase)
            url = optUrl
        case .fetchProductZipped:
            guard let optUrl = URL(string: "https://ketodietapplication.site/storage/json/products_\(langCode).json.gz") else {
                fatalError("wrong url")
            }
            url = optUrl
        case .fetchDishesZipped:
            guard let optUrl = URL(string: "https://ketodietapplication.site/storage/json/dish_\(langCode).json.gz") else {
                fatalError("wrong url")
            }
            url = optUrl
        }
       
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        injectTokenQuery(for: &request)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        return request
    }
}

final class NetworkEngine {
    let searchSession: Session = {
      let configuration = URLSessionConfiguration.af.default
      configuration.timeoutIntervalForRequest = 30
      return Session(configuration: configuration)
    }()
    
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
    
    func performDecodableSearchRequest<T: Codable>(
        request: RequestGenerator,
        completion: @escaping ((Result<T, ErrorDomain>) -> Void)
    ) {
        searchSession.cancelAllRequests()
        let secondsNow = Date().timeIntervalSince1970
        searchSession.request(request.request)
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
    
    func remoteSearchSecond(by phrase: String, completion: @escaping ProductsSearchResult) {
        performDecodableSearchRequest(request: .searchProduct(by: phrase), completion: completion)
    }
    
    func remoteSearchByBarcode(by barcode: String, completion: @escaping ProductsSearchResult) {
        performDecodableSearchRequest(request: .searchProductByBarcode(barcode: barcode), completion: completion)
    }
}
