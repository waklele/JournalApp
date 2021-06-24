//
//  UIViewController.swift
//  JournalApp
//
//  Created by Santo Michael Sihombing on 24/06/21.
//
import UIKit

// Dismiss Keyboard
extension UIViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
}
