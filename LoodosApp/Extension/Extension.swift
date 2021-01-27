//
//  Extension.swift
//  LoodosApp
//
//  Created by Serkan Mehmet Malagiç on 27.01.2021.
//

import UIKit

extension UIViewController {
    
    func showAlert(alertString : String)
    {
        let alert = UIAlertController(title: "Uyarı", message: alertString, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "tamam", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
