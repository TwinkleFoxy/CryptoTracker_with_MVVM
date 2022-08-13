//
//  AlertController.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 20.07.2022.
//

import Foundation
import UIKit

class AlertController {
    
    class func showAlertController(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        return alertController
    }
}
