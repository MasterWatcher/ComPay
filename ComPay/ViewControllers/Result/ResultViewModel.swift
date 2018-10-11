//
//  ResultViewModel.swift
//  ComPay
//
//  Created by Anton Goncharov on 9/6/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ResultViewModel: ViewModel {
    
    struct Input {
        let loadDataTrigger: Driver<Void>
        let cancelTrigger: Driver<Void>
    }
    
    struct Output {
        let isLoading: Driver<Bool>
        let hotWater: Driver<String>
        let coldWater: Driver<String>
        let electricity: Driver<String>
        let total: Driver<String>
        let dismiss: Driver<Void>
    }
    
    init(service: SheetsService, coordinator: SceneCoordinator) {
        self.service = service
        self.coordinator = coordinator
    }
    
    let service: SheetsService
    let coordinator: SceneCoordinator
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let isLoading = activityIndicator.asDriver()
        let lastItem = input.loadDataTrigger
            .flatMapLatest {_ in
                return self.service.monthData()
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
                    .map { $0.last }
        }
        
        let hotWater = lastItem
            .map { "\($0?.hotWaterCost ?? 0)" }
        
        let coldWater = lastItem
            .map { "\($0?.coldWaterCost ?? 0)" }
        
        let electricity = lastItem
            .map { "\($0?.electricityCost ?? 0)" }
        
        let total = lastItem
            .map { "\($0?.total ?? 0)" }
        
        let dismiss = input.cancelTrigger
            .flatMapLatest {_ in
                return self.coordinator.pop().asDriver(onErrorJustReturn: ())
        }
        return Output(isLoading: isLoading,
                      hotWater: hotWater,
                      coldWater: coldWater,
                      electricity: electricity,
                      total: total,
                      dismiss: dismiss)
    }
}
