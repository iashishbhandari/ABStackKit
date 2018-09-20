// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.

import UIKit

public extension UIColor {
    
    static var randomColor: UIColor {
        get {
            return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
        }
    }
}
