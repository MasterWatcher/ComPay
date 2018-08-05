//
//  ListViewModel.swift
//  ComPay
//
//  Created by Anton Goncharov on 1/21/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct ListViewModel {
    
    let service: SheetsService
    let coordinator: SceneCoordinator
    
    init(service: SheetsService, coordinator: SceneCoordinator) {
        self.service = service
        self.coordinator = coordinator
    }
    
    var items: Observable<[MonthData]> {
        return service.monthData()
    }
    
    func onAddItem() -> CocoaAction {
        return CocoaAction { _ in
            let addItemViewModel = AddItemViewModel(service: self.service, coordinator: self.coordinator)
            return self.coordinator.transition(to: Scene.addItem(addItemViewModel), type: .modal)
        }
    }
}
