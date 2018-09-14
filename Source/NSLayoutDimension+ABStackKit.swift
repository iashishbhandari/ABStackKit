// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.

import UIKit

extension NSLayoutDimension {
    
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

extension NSLayoutXAxisAnchor {
    
    func constraintEqualTo(anchor: NSLayoutXAxisAnchor, identifier: String, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, constant: constant)
        constraint.identifier = identifier
        return constraint
    }
}

extension NSLayoutYAxisAnchor {
    
    func constraintEqualTo(anchor: NSLayoutYAxisAnchor, identifier: String, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = self.constraint(equalTo: anchor, constant: constant)
        constraint.identifier = identifier
        return constraint
    }
}
