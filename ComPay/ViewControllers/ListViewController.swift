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
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: "MonthCell")){ index, model, cell in
                guard let cell = cell as? MonthCell else { return }
                cell.monthLabel.text = model.date
                cell.totalLabel.text = "\(model.value)"
            }
            .disposed(by: rx.disposeBag)
        
        addItemButton.rx.action = viewModel.onAddItem()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var sheetsService: SheetsService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Google Sign-in.
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().scopes = scopes
//        GIDSignIn.sharedInstance().signInSilently()
        
    }
    
//    @IBAction func onAddButtonTouch(_ sender: Any) {
//        sheetsService.create(entry: Entry(hotWater: 40, coldWater: 70, electricity: 40010))
//    }
    
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
