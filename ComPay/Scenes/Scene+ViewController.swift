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
        case .login(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
            vc.bindViewModel(to: viewModel)
            return vc
        case .list(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "List") as! UINavigationController
            var vc = nc.viewControllers.first as! ListViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .addItem(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "AddItem") as! AddItemViewController
            vc.bindViewModel(to: viewModel)
            let nc = UINavigationController(rootViewController: vc)
            return nc
        case .result(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "Result") as! ResultViewContoller
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}
