//
//  Scene+ViewController.swift
//  ComPay
//
//  Created by Anton Goncharov on 1/21/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import UIKit

extension Scene {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch self {
        case .list(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "List") as! UINavigationController
            var vc = nc.viewControllers.first as! ListViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .addItem(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "AddItem") as! AddItemViewController
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}
