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

class ListViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheets]
    
    private let service = GTLRSheetsService()
    let signInButton = GIDSignInButton()
    
    var sheetsService: SheetsService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        // Add the sign-in button.
        //view.addSubview(signInButton)
    }
    
    
    @IBAction func onAddButtonTouch(_ sender: Any) {
        sheetsService.create(entry: Entry(hotWater: 40, coldWater: 70, electricity: 40010))
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            
            sheetsService = SheetsServiceImpl(service:self.service)
            sheetsService.monthData()
                .bind(to: tableView.rx.items(cellIdentifier: "MonthCell")){ index, model, cell in
                    guard let cell = cell as? MonthCell else { return }
                    cell.monthLabel.text = model.date
                    cell.totalLabel.text = "\(model.value)"
                }
                .disposed(by: rx.disposeBag)
        }
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

