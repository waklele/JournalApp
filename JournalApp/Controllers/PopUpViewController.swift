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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismiss = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        let save = UITapGestureRecognizer(target: self, action:  #selector(self.saveJournal))
        self.isiKembaliButton.addGestureRecognizer(dismiss)
        self.tetapSimpanButton.addGestureRecognizer(save)
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
