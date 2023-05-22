//
//  ArchiveLoadingOperation.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.05.2023.
//

import Alamofire
import Foundation

// swiftlint:disable function_body_length
final class ArchiveLoadingOperation: Operation {
    private var _isCancelled = false {
          willSet {
              willChangeValue(forKey: "isCancelled")
          }
          didSet {
              didChangeValue(forKey: "isCancelled")
          }
      }
    
    override var isCancelled: Bool {
        return _isCancelled
    }
    
    private var _executing = false {
          willSet {
              willChangeValue(forKey: "isExecuting")
          }
          didSet {
              didChangeValue(forKey: "isExecuting")
          }
      }
      
      override var isExecuting: Bool {
          return _executing
      }
      
      private var _finished = false {
          willSet {
              willChangeValue(forKey: "isFinished")
          }
          
          didSet {
              didChangeValue(forKey: "isFinished")
          }
      }
      
      override var isFinished: Bool {
          return _finished
      }
      
      func executing(_ executing: Bool) {
          _executing = executing
      }
      
      func finish(_ finished: Bool) {
          _finished = finished
      }
    
    enum ResultType {
        case products, dishes
        
        var targetResponseType: Decodable.Type {
            switch self {
            case .dishes:
                return [Dish].self
            case .products:
                return [ProductDTO].self
            }
        }
    }
    
    let link: ArchiveLinkModel
    let type: ResultType
    let persistentService: LocalDomainServiceInterface
    let progressHandler: (ResultType, Int, Double) -> Void
    let archiveNumber: Int
    let errorHandler: () -> Void
    
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
    
    init(
        link: ArchiveLinkModel,
        type: ResultType,
        persistentService: LocalDomainServiceInterface,
        archiveNumber: Int,
        errorHandler: @escaping () -> Void,
        progressHandler: @escaping (ResultType, Int, Double) -> Void
    ) {
        self.link = link
        self.type = type
        self.persistentService = persistentService
        self.progressHandler = progressHandler
        self.archiveNumber = archiveNumber
        self.errorHandler = errorHandler
    }
    
    override func cancel() {
        _isCancelled = true
    }
    
    override func main() {
        guard !isCancelled else {
            executing(false)
            finish(true)
            return
        }
        var request = URLRequest(
            url: link.url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData
        )
        request.addValue(backendToken, forHTTPHeaderField: "Authorization")
        print(request)
        executing(true)
        AF.request(request)
            .validate()
            .downloadProgress(closure: { [weak self] progress in
                guard let self = self else {
                    self?.errorHandler()
                    self?.executing(false)
                    self?.finish(true)
                    return
                }
                guard !self.isCancelled else {
                    self.executing(false)
                    self.finish(true)
                    return
                }
                
                self.progressHandler(self.type, self.archiveNumber, progress.fractionCompleted)
            })
            .response { [weak self] response in
                if let error = response.error {
                    print(error)
                    self?.errorHandler()
                    self?.executing(false)
                    self?.finish(true)
                    return
                }
                guard
                    let self = self,
                    let archiveData = response.data,
                    let targetData = try? archiveData.gunzipped()
                else {
                    self?.errorHandler()
                    self?.executing(false)
                    self?.finish(true)
                    return
                }
                let decoder = JSONDecoder()
                switch self.type {
                case .products:
                    guard let products = try? decoder.decode([ProductDTO].self, from: targetData) else {
                        self.errorHandler()
                        self.executing(false)
                        self.finish(true)
                        return
                    }
                    guard !self.isCancelled else {
                        self.executing(false)
                        self.finish(true)
                        return
                    }
                    let convProduct: [Product] = products.map { .init($0) }
                    self.persistentService.saveProducts(products: convProduct, saveInPriority: false)
                    UDM.lastProductsIncrementalUpdate = self.link.updatedAt
                    executing(false)
                    finish(true)
                case .dishes:
                    guard let dishes = try? decoder.decode([Dish].self, from: targetData) else {
                        self.errorHandler()
                        self.executing(false)
                        self.finish(true)
                        return
                    }
                    guard !self.isCancelled else {
                        self.executing(false)
                        self.finish(true)
                        return
                    }
                    self.persistentService.saveDishes(dishes: dishes)
                    UDM.lastDishIncrementalUpdate = self.link.updatedAt
                    executing(false)
                    finish(true)
                }
            }
    }
}
