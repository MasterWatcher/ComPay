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
import MessageUI

class ResultViewContoller: UIViewController, BindableType {
    
    @IBOutlet weak var hotWaterLabel: UILabel!
    @IBOutlet weak var coldWaterLabel: UILabel!
    @IBOutlet weak var electricityLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
   
    var viewModel: ResultViewModel!
    
    func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let input = ResultViewModel.Input(loadDataTrigger: viewWillAppear, cancelTrigger: cancelButton.rx.tap.asDriver(), shareTrigger: shareButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        output.isLoading
            .drive(indicator.rx.isAnimating)
            .disposed(by: rx.disposeBag)
        output.isLoading
            .drive(containerView.rx.isHidden)
            .disposed(by: rx.disposeBag)
        output.hotWater
            .drive(hotWaterLabel.rx.text)
            .disposed(by: rx.disposeBag)
        output.coldWater
            .drive(coldWaterLabel.rx.text)
            .disposed(by: rx.disposeBag)
        output.electricity
            .drive(electricityLabel.rx.text)
            .disposed(by: rx.disposeBag)
        output.total
            .drive(totalLabel.rx.text)
            .disposed(by: rx.disposeBag)
        output.dismiss
            .drive()
            .disposed(by: rx.disposeBag)
        output.sendSms
            .drive(rx.sendSms)
        .disposed(by: rx.disposeBag)
    }
}

extension Reactive where Base: ResultViewContoller {
var sendSms: Binder<String> {
  return Binder(self.base) { viewController, body in
    if MFMessageComposeViewController.canSendText() {
               let controller = MFMessageComposeViewController()
               controller.body = body
                controller.messageComposeDelegate = viewController
               controller.recipients = []
               viewController.present(controller, animated: true, completion: nil)
           }
    }
  }
}

extension ResultViewContoller: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
     }
}
