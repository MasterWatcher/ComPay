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
       
    }
    
    struct Output {
    
    }
    
    init(service: SheetsService, coordinator: SceneCoordinator) {
        self.service = service
        self.coordinator = coordinator
    }
    
    let service: SheetsService
    let coordinator: SceneCoordinator
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
