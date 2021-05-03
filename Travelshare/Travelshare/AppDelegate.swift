//
//  AppDelegate.swift
//  Travel share
//
//  Created by 康景炫 on 2021/2/8.
//

import UIKit
//import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = .init(frame: UIScreen.main.bounds)
        
        AppLogic.shared.setup()
        if AppLogic.shared.user != nil {
            window?.rootViewController = MainViewController()
        } else {
            window?.rootViewController = UINavigationController(rootViewController: WelcomeViewController())
        }
        window?.makeKeyAndVisible()
        return true
    }
    
    func changeRootToVC(_ vc: UIViewController) {
        self.window?.rootViewController = vc
        UIView.transition(with: self.window!, duration: 0.25, options: .transitionCrossDissolve) {
        } completion: {(_) in
        }
    }
}

