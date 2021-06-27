//
//  PopUpViewController.swift
//  JournalApp
//
//  Created by Albert . on 26/06/21.
//

import UIKit

class PopUpViewController: UIViewController {
    @IBOutlet weak var isiKembaliButton: UIView!
    @IBOutlet weak var tetapSimpanButton: UIView!
    @IBOutlet weak var popUp: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismiss = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        let save = UITapGestureRecognizer(target: self, action:  #selector(self.saveJournal))
        self.isiKembaliButton.addGestureRecognizer(dismiss)
        self.tetapSimpanButton.addGestureRecognizer(save)
        
        popUp.layer.cornerRadius = 8
        
        isiKembaliButton.layer.cornerRadius = 8
        isiKembaliButton.backgroundColor = .init(red: 221/255, green: 66/255, blue: 123/255, alpha: 1)
        
        tetapSimpanButton.layer.cornerRadius = 8
        tetapSimpanButton.layer.masksToBounds = true
        tetapSimpanButton.layer.borderColor = .init(red: 221/255, green: 66/255, blue: 123/255, alpha: 1)
        tetapSimpanButton.layer.borderWidth = 1.0
    }
    
    @IBAction func IsiKembali(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveJournal(sender : UITapGestureRecognizer) {
        let navigationController = self.presentingViewController as? UINavigationController
        
        self.dismiss(animated: true, completion: {
            navigationController?.popToRootViewController(animated: true)
        })
    }
    
}
