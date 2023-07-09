//
//  UITextfield+Extension.swift
//  VeroDS
//
//  Created by Murat Çiçek on 9.07.2023.
//

import UIKit

extension UITextField {
    func setupSearchTextField(target: Any?, action: Selector, returnKeyType: UIReturnKeyType, keyboardType: UIKeyboardType, delegate: UITextFieldDelegate?, placeholder: String) {
        
        addTarget(target, action: action, for: .editingChanged)
        self.returnKeyType = returnKeyType
        self.keyboardType = keyboardType
        self.delegate = delegate
        self.placeholder = placeholder
    }
}
