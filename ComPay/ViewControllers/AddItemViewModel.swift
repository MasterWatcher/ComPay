//
//  AddItemViewModel.swift
//  ComPay
//
//  Created by Anton Goncharov on 1/21/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct AddItemViewModel: ViewModel {
    
    struct Input {
        let hotWater: Driver<String>
        let coldWater: Driver<String>
        let electricity: Driver<String>
        let date: Driver<String>
        let submitTrigger: Driver<Void>
        let cancelTrigger: Driver<Void>
    }
    
    struct Output {
        let date: Driver<String>
        let isLoading: Driver<Bool>
        let submitEnabled: Driver<Bool>
        let dismiss: Driver<Void>
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
        let counterReadings = Driver.combineLatest(input.coldWater, input.hotWater, input.electricity, input.date)
        let submitEnabled = Driver.combineLatest(counterReadings, isLoading)
            .map { (arg0, isLoading) -> Bool in
                let (coldWater, hotWater, electricity, date) = arg0
                return !coldWater.isEmpty && !hotWater.isEmpty && !electricity.isEmpty && !date.isEmpty && !isLoading
            }
            .distinctUntilChanged()
        let submit = input.submitTrigger
            .withLatestFrom(counterReadings)
            .map { (arg) -> Entry in
                let (coldWater, hotWater, electricity, date) = arg
                return Entry(hotWater: Double(hotWater)!, coldWater: Double(coldWater)!, electricity: Double(electricity)!, date: date)
            }
            .flatMapLatest { entry in
                return self.service.create(entry: entry)
                .trackActivity(activityIndicator)
                .asDriver(onErrorJustReturn: ())
            }
        let date = Driver.just("22/05/2018")
        let dismiss = Driver.of(submit, input.cancelTrigger)
            .merge()
            .flatMapLatest {_ in
                return self.coordinator.pop().asDriver(onErrorJustReturn: ())
        }
        return Output(date: date, isLoading: isLoading, submitEnabled: submitEnabled, dismiss: dismiss)
    }
}
