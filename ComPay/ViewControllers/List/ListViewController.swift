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
import RxCocoa

class ListViewController: UIViewController, BindableType {
    
    var viewModel: ListViewModel!
    
    @IBOutlet weak var addItemButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var sheetsService: SheetsService!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = UIRefreshControl()
    }
    
    func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let input = ListViewModel.Input(loadItemsTrigger: Driver.merge(viewWillAppear, pull),
                                        addItemTrigger: addItemButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        output.items.drive(tableView.rx.items(cellIdentifier: "MonthCell")){ index, model, cell in
            guard let cell = cell as? MonthCell else { return }
            cell.configure(with: model)
            }
            .disposed(by: rx.disposeBag)
        output.addItem
            .drive()
            .disposed(by: rx.disposeBag)
        output.isLoading
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: rx.disposeBag)
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
