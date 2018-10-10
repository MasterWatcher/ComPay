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
    
    @IBOutlet weak var hotWaterLabel: UILabel!
    @IBOutlet weak var coldWaterLabel: UILabel!
    @IBOutlet weak var electricityLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var viewModel: ResultViewModel!
    
    func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let input = ResultViewModel.Input(loadDataTrigger: viewWillAppear, cancelTrigger: cancelButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        output.isLoading
            .drive(indicator.rx.isAnimating)
            .disposed(by: rx.disposeBag)
        output.isLoading
            .drive(containerView.rx.isHidden)
            .disposed(by: rx.disposeBag)
        output.total
            .drive(totalLabel.rx.text)
            .disposed(by: rx.disposeBag)
        output.dismiss
            .drive()
            .disposed(by: rx.disposeBag)
    }
}
