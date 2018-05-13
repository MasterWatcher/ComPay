//
//  Scene.swift
//  ComPay
//
//  Created by Anton Goncharov on 1/21/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import Foundation

enum Scene {
    case login(LoginViewModel)
    case list(ListViewModel)
    case addItem(AddItemViewModel)
}
