//
//  Alert.swift
//  VeroDS
//
//  Created by Murat Çiçek on 9.07.2023.
//

import UIKit

final class Alerts {
    
    func defaultAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        
        alertController.addAction(okayAction)
        
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.present(alertController, animated: true, completion: nil)
        }
    }

}

