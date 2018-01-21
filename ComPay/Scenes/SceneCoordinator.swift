//
//  SceneCoordinator.swift
//  ComPay
//
//  Created by Anton Goncharov on 1/21/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import UIKit
import RxSwift

protocol SceneCoordinator {
    init(window: UIWindow)
    
    /// transition to another scene
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Observable<Void>
    
    /// pop scene from navigation stack or dismiss current modal
    @discardableResult
    func pop(animated: Bool) -> Observable<Void>
}

extension SceneCoordinator {
    @discardableResult
    func pop() -> Observable<Void> {
        return pop(animated: true)
    }
}
