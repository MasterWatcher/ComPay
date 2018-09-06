//
//  ResultViewContoller.swift
//  ComPay
//
//  Created by Anton Goncharov on 9/6/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class ResultViewContoller: UIViewController, BindableType {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var viewModel: ResultViewModel!
    
    func bindViewModel() {
        let input = ResultViewModel.Input(cancelTrigger: cancelButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        output.dismiss
            .drive()
        .disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
