// MIT license. Copyright (c) 2023 Ashish Bhandari. All rights reserved.

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
    
    static func makeViewControllerProgramatically(
        onViewSelection: @escaping () -> Void
    ) -> UIViewController {
        let exampleVC = ExampleViewController()
        exampleVC.view.accessibilityIdentifier = "PRO"
        exampleVC.onViewSelection = onViewSelection
        return exampleVC
    }
    
    static func makeViewControllerViaInheritance(
        onViewSelection: @escaping () -> Void
    ) -> UIViewController {
        let exampleVC = ExampleStackViewController()
        exampleVC.view.accessibilityIdentifier = "IN"
        exampleVC.onViewSelection = onViewSelection
        return exampleVC
    }
}
