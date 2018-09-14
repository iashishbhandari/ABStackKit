// MIT license. Copyright (c) 2018 Ashish Bhandari. All rights reserved.

import UIKit

public extension UIView {
    
    func addSizeAnchors(onView view: UIView?, size: CGSize) {
        if let v = view {
            v.translatesAutoresizingMaskIntoConstraints = false
            var anchors = [NSLayoutConstraint]()
            anchors.append(v.widthAnchor.constraintEqualTo(constant: size.width, identifier: ConstraintTag.W))
            anchors.append(v.heightAnchor.constraintEqualTo( constant: size.height, identifier: ConstraintTag.H))
            NSLayoutConstraint.activate(anchors)
        }
    }
    
    func addEdgeAnchors(onView view: UIView?, edgeInsets: UIEdgeInsets = .zero) {
        if let v = view {
            v.translatesAutoresizingMaskIntoConstraints = false
            let edgeInsets = (edgeInsets == .zero) ? v.layoutMargins : edgeInsets
            var anchors = [NSLayoutConstraint]()
            anchors.append(v.topAnchor.constraintEqualTo(anchor: topAnchor, identifier: ConstraintTag.T, constant: edgeInsets.top))
            anchors.append(v.leadingAnchor.constraintEqualTo(anchor: leadingAnchor, identifier: ConstraintTag.L, constant: edgeInsets.left))
            anchors.append(trailingAnchor.constraintEqualTo(anchor: v.trailingAnchor, identifier: ConstraintTag.R, constant: edgeInsets.right))
            anchors.append(bottomAnchor.constraintEqualTo(anchor: v.bottomAnchor, identifier: ConstraintTag.B, constant: edgeInsets.bottom))
            NSLayoutConstraint.activate(anchors)
        }
    }
    
    func addCenterXYAnchors(onView view: UIView?) {
        if let v = view {
            v.translatesAutoresizingMaskIntoConstraints = false
            centerXAnchor.constraintEqualTo(anchor: v.centerXAnchor, identifier: ConstraintTag.X, constant: 0).isActive = true
            centerYAnchor.constraintEqualTo(anchor: v.centerYAnchor, identifier: ConstraintTag.Y, constant: 0).isActive = true
        }
    }
    
    func constraint(withIdentifier: String) -> NSLayoutConstraint? {
        return self.constraints.filter{ $0.identifier == withIdentifier }.first
    }
}

public struct ConstraintTag {
    public static let W = "widthIdentifier"
    public static let H = "heightIdentifier"
    public static let X = "centerXIdentifier"
    public static let Y = "centerYIdentifier"
    public static let T = "topIdentifier"
    public static let L = "leftIdentifier"
    public static let R = "rightIdentifier"
    public static let B = "bottomIdentifier"
}
