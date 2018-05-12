//
//  LoginViewController.swift
//  ComPay
//
//  Created by Anton Goncharov on 4/22/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    private let scopes = [kGTLRAuthScopeSheetsSpreadsheets]
    
    let signInButton = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        view.addSubview(signInButton)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
    }
}
