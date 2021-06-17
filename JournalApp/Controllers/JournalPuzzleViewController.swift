//
//  JournalPuzzleViewController.swift
//  JournalApp
//
//  Created by Muhammad Rizki Miftha Alhamid on 6/17/21.
//

import UIKit

class JournalPuzzleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveJournal(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
