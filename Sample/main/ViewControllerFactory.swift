//
//  ViewControllerFactory.swift
//  Sample
//
//  Created by Ashish Bhandari on 14/01/23.
//  Copyright © 2023 iashishbhandari. All rights reserved.
//

import UIKit

final class ViewControllerFactory {
    static func makeViewControllerFromXIB(
        onBarButtonSelection: @escaping ExampleXIBViewController.BarButtonSelector
    ) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        let exampleVC = storyBoard.instantiateViewController(withIdentifier: "ExampleXIBViewController") as! ExampleXIBViewController
        exampleVC.onBarButtonSelection = onBarButtonSelection
        return exampleVC
    }
    
    static func makeViewControllerProgramatically() -> UIViewController {
        let exampleVC = ExampleViewController()
        exampleVC.view.accessibilityIdentifier = "PRO"
        return exampleVC
    }
    
    static func makeViewControllerViaInheritance() -> UIViewController {
        let exampleVC = ExampleStackViewController()
        exampleVC.view.accessibilityIdentifier = "IN"
        return exampleVC
    }
}
