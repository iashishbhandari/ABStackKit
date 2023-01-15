// MIT license. Copyright (c) 2023 Ashish Bhandari. All rights reserved.

import UIKit

extension UIImage {
    static func image(with color: UIColor = UIColor.randomColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
