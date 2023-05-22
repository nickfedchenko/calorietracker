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
    func fetchProducts(progressObserver: ((Double) -> Void)?, completion: @escaping ProductsResult)
    func fetchDishes(progressObserver: ((Double) -> Void)?, completion: @escaping DishesResponse)
    func remoteSearch(by phrase: String, completion: @escaping SearchProductsResponse)
    func remoteSearchSecond(by phrase: String, completion: @escaping ProductsSearchResult)
    func remoteSearchByBarcode(by barcode: String, completion: @escaping ProductsSearchResult)
    func uploadUserProduct(product: BackendSubmitModel, completion: @escaping BackendSubmitResult)
    func fetchDishArchivesList(completion: @escaping ArchivesListListResult)
    func fetchProductsArchivesList(completion: @escaping ArchivesListListResult)
}

extension NetworkEngineInterface {
    func fetchProducts(progressObserver: ((Double) -> Void)? = nil, completion: @escaping ProductsResult) {
        fetchProducts(progressObserver: progressObserver, completion: completion)
    }
    
    func fetchDishes(progressObserver: ((Double) -> Void)? = nil, completion: @escaping DishesResponse) {
        fetchDishes(progressObserver: progressObserver, completion: completion)
    }
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
            case .uploadProduct:
                if let targetCode = LinkLanguageCodes.allCases.first(where: { $0.rawValue == currentLanguageCode }) {
                    return targetCode
                } else {
                    return .en
                }
            case .getListOfProductUpdates:
                if let targetCode = LinkLanguageCodes.allCases.first(where: { $0.rawValue == currentLanguageCode }) {
                    return targetCode
                } else {
                    return .en
                }
            case .getListOfDishUpdates:
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
    case uploadProduct(product: BackendSubmitModel)
    case getListOfProductUpdates
    case getListOfDishUpdates
    
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
        case .uploadProduct(product: _):
            guard let optUrl = URL(string: "https://ketodietapplication.site/api/userProduct") else {
                fatalError("wrong url")
            }
            url = optUrl
        case .getListOfDishUpdates:
            guard let optUrl = URL(
                string: "https://ketodietapplication.site/api/archive/incremental/list?lang=\(langCode)&type=dish"
            ) else {
                fatalError("wrong url")
            }
            url = optUrl
        case .getListOfProductUpdates:
            guard let optUrl = URL(
                string: "https://ketodietapplication.site/api/archive/incremental/list?lang=\(langCode)&type=product"
            ) else {
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
        progressObserver: ((Double) -> Void)? = nil,
        completion: @escaping ((Result<T, ErrorDomain>) -> Void)
    ) {
        let secondsNow = Date().timeIntervalSince1970
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        AF.request(request.request)
            .validate()
            .downloadProgress(closure: { progress in
                progressObserver?(progress.fractionCompleted)
            })
            .responseDecodable(
                of: T.self,
                queue: .global(qos: .userInitiated),
                dataPreprocessor: .gzipPreprocessor,
                decoder: decoder
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
    
    func performDecodableUploadRequest<T: Codable>(
        request: RequestGenerator,
        completion: @escaping ((Result<T, ErrorDomain>) -> Void)
    ) {
        
        var urlRequest = request.request
        urlRequest.method = .post
        if case let .uploadProduct(product: product) = request {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try? encoder.encode(product)
            AF.upload(data ?? Data(), with: urlRequest).validate()
            .responseDecodable(
                of: T.self,
                queue: .global(qos: .userInitiated)
            ) { result in
                guard let data = result.value else {
                    if let error = result.error {
                        completion(.failure(.AFError(error: error)))
                    }
                    return
                }
                completion(.success(data))
            }
        }
    }
}

extension NetworkEngine: NetworkEngineInterface {
    func fetchDishArchivesList(completion: @escaping ArchivesListListResult) {
        performDecodableRequest(request: .getListOfDishUpdates, completion: completion)
    }
    
    func fetchProductsArchivesList(completion: @escaping ArchivesListListResult) {
        performDecodableRequest(request: .getListOfProductUpdates, completion: completion)
    }
    
    func uploadUserProduct(product: BackendSubmitModel, completion: @escaping BackendSubmitResult) {
        performDecodableUploadRequest(request: .uploadProduct(product: product), completion: completion)
    }
    
    func fetchProducts(progressObserver: ((Double) -> Void)? = nil, completion: @escaping ProductsResult) {
        performDecodableRequest(
            request: .fetchProductZipped,
            progressObserver: progressObserver,
            completion: completion
        )
    }
    
    func fetchDishes(progressObserver: ((Double) -> Void)? = nil, completion: @escaping DishesResponse) {
        performDecodableRequest(
            request: .fetchDishesZipped,
            progressObserver: progressObserver,
            completion: completion
        )
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
