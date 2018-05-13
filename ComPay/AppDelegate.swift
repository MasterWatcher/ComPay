//
//  AppDelegate.swift
//  ComPay
//
//  Created by Anton Goncharov on 1/10/18.
//  Copyright © 2018 Anton Goncharov. All rights reserved.
//

import Google
import GoogleSignIn
import UIKit
import GoogleAPIClientForREST

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    private let scopes = [kGTLRAuthScopeSheetsSpreadsheets]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GIDSignIn.sharedInstance().clientID = "862716452666-aihik5vrm1bvp6e1gb1crsg4svrnfmi3.apps.googleusercontent.com"
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError ?? nil))")
        
        
        
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        
        return true
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        let sceneCoordinator = SceneCoordinatorImpl(window: window!)
        let firstScene: Scene
        if let _ = error {
            let loginViewModel = LoginViewModel(coordinator: sceneCoordinator)
            firstScene = .login(loginViewModel)
        } else {
            let gtlrService = GTLRSheetsService()
            gtlrService.authorizer = user.authentication.fetcherAuthorizer()
            
            let sheetsService = SheetsServiceImpl(service: gtlrService)
            let listViewModel = ListViewModel(service: sheetsService, coordinator: sceneCoordinator)
            firstScene = .list(listViewModel)
            
        }
        sceneCoordinator.transition(to: firstScene, type: .root)
    }
    
    
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
}

