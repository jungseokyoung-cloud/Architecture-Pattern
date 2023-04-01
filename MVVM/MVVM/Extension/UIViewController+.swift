//
//  UIViewController+.swift
//  MVVM
//
//  Created by jung on 2023/04/01.
//

import UIKit

extension UIViewController {
    func createAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}
