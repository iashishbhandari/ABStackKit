// MIT license. Copyright (c) 2023 Ashish Bhandari. All rights reserved.

import UIKit

final class AppFlow {
    private let navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.setViewControllers([ViewControllerFactory.makeViewControllerFromXIB(onBarButtonSelection: { [weak self] in
            self?.showView($0)
        })], animated: false)
    }
    
    func showView(_ title: String?) {
        switch title {
        case "2":
            navigationController.pushViewController(ViewControllerFactory.makeViewControllerProgramatically { [weak self] in
                self?.pop()
            }, animated: true)
            
        case "3":
            navigationController.present(ViewControllerFactory.makeViewControllerViaInheritance { [weak self] in
                self?.dismiss()
            }, animated: true)
            
        default: break
        }
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
}
