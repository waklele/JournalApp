//
//  ViewController.swift
//  JournalApp
//
//  Created by Rangga Rentya on 11/06/21.
//

// Rangga Hadir 
// rizki hadir
// nasha hadir 🙋🏻‍♀️
// Albert hadir 🙌
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
