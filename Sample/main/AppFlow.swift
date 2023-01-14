//
//  AppFlow.swift
//  Sample
//
//  Created by Ashish Bhandari on 14/01/23.
//  Copyright © 2023 iashishbhandari. All rights reserved.
//

import UIKit

final class AppFlow {
    private let navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.setViewControllers([ViewControllerFactory.makeViewControllerFromXIB(onBarButtonSelection: { [weak self] in
            self?.onBarButtonSelection($0)
        })], animated: false)
    }
    
    func onBarButtonSelection(_ title: String?) {
        switch title {
        case "2":
            navigationController.pushViewController(ViewControllerFactory.makeViewControllerProgramatically(), animated: true)
            
        case "3":
            navigationController.present(ViewControllerFactory.makeViewControllerViaInheritance(), animated: true)
            
        default: break
        }
    }
}
