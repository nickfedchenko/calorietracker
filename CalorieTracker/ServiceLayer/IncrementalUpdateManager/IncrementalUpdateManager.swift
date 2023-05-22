//
//  IncrementalUpdateManager.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 19.05.2023.
//

import UIKit
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
enum LoadingEvents {
    case startedLoadingMainProductArchive(progress: Double)
    case startedLoadingMainDishArchive(progress: Double)
    case finishedLoadingMainDishArchive
    case finishedLoadingMainProductArchive
    case fetchingProductArchivesList
    case fetchingDishArchivesList
    case loadingProductIncrementalArchive(current: Int, total: Int, progress: Double)
    case loadingDishIncrementalArchive(current: Int, total: Int, progress: Double)
    case savingArchives(number: Int)
    case finished
    case error
    
    var description: String {
        switch self {
        case .startedLoadingMainProductArchive(let progress):
            return "Loading products main base \(String(format: "%.0f", progress * 100))%"
        case .startedLoadingMainDishArchive(let progress):
            return "Loading dishes main base \(String(format: "%.0f", progress * 100))%"
        case .finishedLoadingMainDishArchive:
            return "Finished loading dishes main base"
        case .finishedLoadingMainProductArchive:
            return "Finished loading products main base"
        case .fetchingProductArchivesList:
            return "Fetching products updates"
        case .fetchingDishArchivesList:
            return "Fetching dishes updates"
        case .loadingProductIncrementalArchive(let current, let total, let progress):
            return "Loading products archive \(current)/\(total) \(String(format: "%.0f", progress * 100))%"
        case .loadingDishIncrementalArchive(let current, let total, let progress):
            return "Loading dishes archive \(current)/\(total) \(String(format: "%.0f", progress * 100))%"
        case .finished:
            return "Everything is up to date!"
        case .error:
            return "An error occurred. Please check your internet connection"
        case .savingArchives(number: let number):
            return "Filling up database by archive №\(number)"
        }
    }
}

final class IncrementalUpdateManager {
    enum OperationFlow {
        case mainLoading
        case incrementalUpdate
    }
    
    private let networkService: NetworkEngineInterface = NetworkEngine.shared
    private let dataService: DataServiceFacadeInterface = DSF.shared
    private let foodService: FoodDataServiceInterface = FDS.shared
    private let persistentService: LocalDomainServiceInterface = LocalDomainService()
    private var totalProductArchivesToLoadCount: Int = 0
    private var totalDishesArchivesToLoadCount: Int = 0
    private var shouldContinueUpdating: Bool = true
    
    let archivesLoadingQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    var statusHandler: ((LoadingEvents) -> Void)?
    
    func start() {
//        archivesLoadingQueue.cancelAllOperations()
        guard
            foodService.baseFoodDBExists(),
            let lastDishUpdateDate = UDM.lastDishIncrementalUpdate,
            let lastProductsUpdate = UDM.lastProductsIncrementalUpdate,
            let dishDaysLasts = Calendar.current.dateComponents([.day], from: lastDishUpdateDate, to: Date()).day,
            let productsDaysLasts = Calendar.current.dateComponents([.day], from: lastProductsUpdate, to: Date()).day,
            dishDaysLasts < 30,
            productsDaysLasts < 30
        else {
            networkService.fetchProducts(
                progressObserver: { [weak self] progress in
                    self?.statusHandler?(.startedLoadingMainProductArchive(progress: progress))
                },
                completion: { [weak self] result in
                    switch result {
                    case .success(let products):
                        let convProduct: [Product] = products.map { .init($0) }
                        let splittedProducts = convProduct.splitInSubArrays(into: 12)
                        splittedProducts.enumerated().forEach { [weak self] index, productsPack in
                            self?.statusHandler?(.savingArchives(number: index + 1))
                            self?.persistentService.saveProducts(
                                products: productsPack,
                                saveInPriority: false
                            )
                        }
                        UDM.lastProductsIncrementalUpdate = Date()
                        self?.networkService.fetchDishes(
                            progressObserver: { [weak self] progress in
                                self?.statusHandler?(.startedLoadingMainDishArchive(progress: progress))
                            },
                            completion: { [weak self] result in
                                switch result {
                                case .failure:
                                    self?.statusHandler?(.error)
                                case .success(let dishes):
                                    print("dishes received \(dishes.count)")
                                    let splitDishes = dishes.splitInSubArrays(into: 8)
                                    self?.makeTagTitles(from: dishes)
                                    splitDishes.enumerated().forEach { [weak self] index, dishesPack in
                                        self?.statusHandler?(.savingArchives(number: index + 1))
                                        self?.persistentService.saveDishes(dishes: dishesPack)
                                    }
                                    UDM.lastDishIncrementalUpdate = Date()
                                    self?.statusHandler?(.finished)
                                }
                            }
                        )
                    case .failure:
                        self?.statusHandler?(.error)
                    }
                }
            )
            return
        }
        
        statusHandler?(.fetchingProductArchivesList)
        networkService.fetchProductsArchivesList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let archivesListResponse):
                self.totalProductArchivesToLoadCount = archivesListResponse.links.count
                var operationsPool: [ArchiveLoadingOperation] = []
                for (index, link) in archivesListResponse.links.enumerated() {
                    if let lastProductsUpdateDate = UDM.lastProductsIncrementalUpdate {
                        if link.updatedAt <= lastProductsUpdateDate {
                            continue
                        }
                    }
                    let operation = ArchiveLoadingOperation(
                        link: link,
                        type: .products,
                        persistentService: self.persistentService,
                        archiveNumber: index + 1,
                        errorHandler: { [weak self] in
                            self?.archivesLoadingQueue.cancelAllOperations()
                            self?.shouldContinueUpdating = false
                            self?.statusHandler?(.error)
                        }
                    ) { type, number, progress in
                        self.shouldContinueUpdating = true
                        self.statusHandler?(
                            .loadingProductIncrementalArchive(
                                current: number,
                                total: self.totalProductArchivesToLoadCount,
                                progress: progress
                            )
                        )
                    }
                    operationsPool.append(operation)
                }
                self.archivesLoadingQueue.addOperations(operationsPool, waitUntilFinished: true)
                guard self.shouldContinueUpdating else { return }
                self.statusHandler?(.fetchingDishArchivesList)
                self.networkService.fetchDishArchivesList(completion: { [weak self] result in
                    
                    guard let self = self else { return }
                    switch result {
                    case .success(let dishArchivesResponse):
                        self.totalDishesArchivesToLoadCount = dishArchivesResponse.links.count
                        var operationsPool: [ArchiveLoadingOperation] = []
                        for (index, link) in dishArchivesResponse.links.enumerated() {
                            if let lastDishUpdateDate = UDM.lastDishIncrementalUpdate {
                                if link.updatedAt <= lastDishUpdateDate {
                                    continue
                                }
                            }
                            let operation = ArchiveLoadingOperation(
                                link: link,
                                type: .dishes,
                                persistentService: self.persistentService,
                                archiveNumber: index + 1,
                                errorHandler:  { [weak self] in
                                    self?.archivesLoadingQueue.cancelAllOperations()
                                    self?.statusHandler?(.error)
                                }
                            ) { type, number, progress in
                                self.statusHandler?(
                                    .loadingDishIncrementalArchive(
                                        current: number,
                                        total: self.totalDishesArchivesToLoadCount,
                                        progress: progress
                                    )
                                )
                            }
                            if index == dishArchivesResponse.links.count - 1 {
                                operation.completionBlock = { [weak self] in
                                    self?.statusHandler?(.finished)
                                }
                            }
                            operationsPool.append(operation)
                        }
                        guard !operationsPool.isEmpty else {
                            self.statusHandler?(.finished)
                            return
                        }
                        self.archivesLoadingQueue.addOperations(operationsPool, waitUntilFinished: true)
                        
                    case .failure(let error):
                        print(error)
                        self.statusHandler?(.error)
                    }
                })
            case .failure(let error):
                print(error)
                self.statusHandler?(.error)
            }
        }
    }
    
    private func makeTagTitles(from allDishes: [Dish]) {
        var possibleFilterTags: Set<AdditionalTag> = []
        var possibleExceptionTags: Set<ExceptionTag> = []
        allDishes.forEach {
            $0.additionalTags.forEach {
                possibleFilterTags.update(with: $0)
            }
            $0.dietTags.forEach {
                possibleFilterTags.update(with: $0)
            }
            $0.dishTypeTags.forEach {
                possibleFilterTags.update(with: $0)
            }
            $0.eatingTags.forEach {
                possibleFilterTags.update(with: $0)
            }
            
            $0.processingTypeTags.forEach {
                possibleFilterTags.update(with: $0)
            }
            $0.exceptionTags.forEach {
                possibleExceptionTags.update(with: $0)
            }
        }
        
        UDM.possibleIngredientsTags = possibleExceptionTags
        
        for tag in possibleFilterTags {
            guard let convTag = tag.convenientTag else { continue }
            UDM.titlesForFilterTags[convTag] = tag.title
        }
        
        for tag in possibleExceptionTags {
            guard let convTag = tag.convenientTag else { continue }
            UDM.titlesForExceptionTags[convTag] = tag.title
        }
        UDM.titlesForFilterTags[.favorite] = "Favorites".localized
    }
}
