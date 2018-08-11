//
//  ViewModel.swift
//  ComPay
//
//  Created by Anton Goncharov on 8/11/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
