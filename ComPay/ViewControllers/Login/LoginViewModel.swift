//
//  LoginViewModel.swift
//  ComPay
//
//  Created by Anton Goncharov on 5/13/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct LoginViewModel {
    
    let coordinator: SceneCoordinator
    
    init(coordinator: SceneCoordinator) {
        self.coordinator = coordinator
    }
}

extension LoginViewModel {
    struct Input {
        var loginTrigger: Driver<Void>
    }
    
    struct Output {
        let login: Driver<Void>
    }
}
