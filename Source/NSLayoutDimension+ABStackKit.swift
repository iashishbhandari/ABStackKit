// MIT license. Copyright (c) 2023 Ashish Bhandari. All rights reserved.

import UIKit

public extension NSLayoutDimension {
    
    func constraintEqualTo(constant: CGFloat, identifier: String) -> NSLayoutConstraint {
        let constraint = self.constraint(equalToConstant: constant)
        constraint.identifier = identifier
        return constraint
    }
    
    func constraintEqualTo(anchor: NSLayoutDimension, identifier: String) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, multiplier: 1.0)
        constraint.identifier = identifier
        return constraint
    }
}

public extension NSLayoutXAxisAnchor {
    
    func constraintEqualTo(anchor: NSLayoutXAxisAnchor, identifier: String, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, constant: constant)
        constraint.identifier = identifier
        return constraint
    }
}

public extension NSLayoutYAxisAnchor {
    
    func constraintEqualTo(anchor: NSLayoutYAxisAnchor, identifier: String, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, constant: constant)
        constraint.identifier = identifier
        return constraint
    }
}
