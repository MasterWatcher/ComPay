//
//  Observable+Extensions.swift
//  ComPay
//
//  Created by Anton Goncharov on 8/11/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
