//
//  AddItemViewController.swift
//  ComPay
//
//  Created by Anton Goncharov on 1/16/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class AddItemViewController: UIViewController, BindableType {
   
    @IBOutlet weak var hotWaterTextField: UITextField!
    @IBOutlet weak var coldWaterTextField: UITextField!
    @IBOutlet weak var electricityTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: AddItemViewModel!
    
    func bindViewModel() {
        let input = AddItemViewModel.Input(hotWater: hotWaterTextField.rx.text.orEmpty.asDriver(),
                                           coldWater: coldWaterTextField.rx.text.orEmpty.asDriver(),
                                           electricity: electricityTextField.rx.text.orEmpty.asDriver(),
                                           date: dateTextField.rx.text.orEmpty.asDriver(),
                                           submitTrigger: submitButton.rx.tap.asDriver(),
                                           cancelTrigger: cancelButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        output.date
            .drive(dateTextField.rx.text)
            .disposed(by: rx.disposeBag)
        output.isLoading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: rx.disposeBag)
        output.submitEnabled
            .drive(submitButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
        output.dismiss
            .drive()
            .disposed(by: rx.disposeBag)
        output.submit
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

