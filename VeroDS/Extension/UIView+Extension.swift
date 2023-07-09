//
//  UIView+Extension.swift
//  VeroDS
//
//  Created by Murat Çiçek on 9.07.2023.
//

import UIKit

extension UIView {
    func setupView(borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
    }
}
