//
//  ViewController.swift
//  ComPay
//
//  Created by Anton Goncharov on 1/10/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import GoogleAPIClientForREST
import GoogleSignIn
import UIKit
import NSObject_Rx

class ListViewController: UIViewController, BindableType {
    
    var viewModel: ListViewModel!
    
    @IBOutlet weak var addItemButton: UIBarButtonItem!
    
    func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let input = ListViewModel.Input(loadItemsTrigger: viewWillAppear,
                                        addItemTrigger: addItemButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.items.drive(tableView.rx.items(cellIdentifier: "MonthCell")){ index, model, cell in
            guard let cell = cell as? MonthCell else { return }
            cell.monthLabel.text = model.date
            cell.totalLabel.text = "\(model.value)"
            }
            .disposed(by: rx.disposeBag)
        
        output.addItem
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var sheetsService: SheetsService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
