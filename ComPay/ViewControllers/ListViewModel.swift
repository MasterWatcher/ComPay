//
//  ListViewModel.swift
//  ComPay
//
//  Created by Anton Goncharov on 1/21/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ListViewModel: ViewModel {
    
    struct Input {
        let loadItemsTrigger: Driver<Void>
        let addItemTrigger: Driver<Void>
    }
    
    struct Output {
        let items: Driver<[MonthData]>
        let addItem: Driver<Void>
        let isLoading: Driver<Bool>
    }
    
    let service: SheetsService
    let coordinator: SceneCoordinator
    
    init(service: SheetsService, coordinator: SceneCoordinator) {
        self.service = service
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let isLoading = activityIndicator.asDriver()
        let items = input.loadItemsTrigger
            .flatMapLatest {_ in
                return self.service.monthData()
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
        }
        let addItemTrigger = input.addItemTrigger.do(onNext: {
            let addItemViewModel = AddItemViewModel(service: self.service, coordinator: self.coordinator)
            self.coordinator.transition(to: Scene.addItem(addItemViewModel), type: .modal)
        })
        
        return Output(items: items, addItem: addItemTrigger, isLoading:isLoading)
    }
}
