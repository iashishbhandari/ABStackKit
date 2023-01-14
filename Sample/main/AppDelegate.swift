// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private lazy var navigationController = UINavigationController()
    private lazy var appFlow = AppFlow(navigationController)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        appFlow.start()
        return true
    }
    
    private func makeRootController() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        let exampleVC = storyBoard.instantiateViewController(withIdentifier: "ExampleXIBViewController")
        return exampleVC
    }
}
