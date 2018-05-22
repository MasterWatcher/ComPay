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

struct AddItemViewModel {
    
    let service: SheetsService
    let coordinator: SceneCoordinator
    
    init(service: SheetsService, coordinator: SceneCoordinator) {
        self.service = service
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let counterReadings = Driver.combineLatest(input.coldWater, input.hotWater, input.electricity, input.date)
        let submitEnabled = counterReadings
            .map { (coldWater, hotWater, electricity, date) -> Bool in
                return !coldWater.isEmpty && !hotWater.isEmpty && !electricity.isEmpty && !date.isEmpty
            }
        let submit = input.submitTrigger
            .withLatestFrom(counterReadings)
            .map { (arg) -> Entry in
                let (coldWater, hotWater, electricity, date) = arg
                return Entry(hotWater: Double(hotWater)!, coldWater: Double(coldWater)!, electricity: Double(electricity)!, date: date)
            }
            .flatMapLatest { entry in
                return self.service.create(entry: entry)
                .asDriver(onErrorJustReturn: ())
            }
        let date = Driver.just("22/05/2018")
        return Output(date: date, submitEnabled: submitEnabled, submit: submit)
    }
}

extension AddItemViewModel {
    struct Input {
        var hotWater: Driver<String>
        var coldWater: Driver<String>
        var electricity: Driver<String>
        var date: Driver<String>
        var submitTrigger: Driver<Void>
    }
    
    struct Output {
        let date: Driver<String>
        let submitEnabled: Driver<Bool>
        let submit: Driver<Void>
    }
}
