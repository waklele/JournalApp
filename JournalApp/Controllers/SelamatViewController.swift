//
//  SelamatViewController.swift
//  JournalApp
//
//  Created by Albert . on 27/06/21.
//

import UIKit

class SelamatViewController: UIViewController {
    @IBOutlet weak var kembaliButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kembaliButton.layer.cornerRadius = 8
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.isNavigationBarHidden = true
        kembaliButton.layer.cornerRadius = 15
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backAction))
        self.kembaliButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func backAction() {
        navigationController?.popToRootViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}
