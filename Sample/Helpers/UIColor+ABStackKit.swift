// MIT license. Copyright (c) 2023 Ashish Bhandari. All rights reserved.

import UIKit

extension UIColor {
    static var randomColor: UIColor {
        get {
            return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
        }
    }
}
