//
//  ViewConnectionsViewController.swift
//  JournalApp
//
//  Created by Muhammad Rizki Miftha Alhamid on 6/25/21.
//

import UIKit
import CoreData

class ViewConnectionsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    
    public var puzzleType: Int = 0
    public var dataId: Int64 = 0
    public var readingTitle = String()
    public var puzzle1Detail = String()
    public var puzzle2Detail = String()
    public var puzzle3Detail = String()
    public var puzzle4Detail = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = ""

        detailsTextView.layer.cornerRadius = 5
        detailsTextView.delegate = self
        detailsTextView.text = "Insert detail here..."
        detailsTextView.textColor = UIColor.lightGray
        
//        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: #selector(editConnections(_:)))
//        self.navigationItem.rightBarButtonItem = editButton
        
        adjustPrompt()
    }
    
    func adjustPrompt() {
        if puzzleType == 1 {
            promptLabel.text = "Bagaimana cerita ini serupa/berbeda dengan kehidupan kamu?"
            self.title = "Text-to-Self"
            detailsTextView.text = puzzle2Detail
        } else if puzzleType == 2 {
            promptLabel.text = "Bagaimana cerita ini mengingatkan kamu dengan cerita lain?"
            self.title = "Text-to-Text"
            detailsTextView.text = puzzle3Detail
        } else if puzzleType == 3 {
            promptLabel.text = "Bagaimana cerita ini mengingatkan kamu pada dunia disekitarmu?"
            self.title = "Text-to-World"
            detailsTextView.text = puzzle4Detail
        } else {
            print("error")
        }
    }
    
    @IBAction func editConnections(_ sender: Any) {
        print("tekan bisa")
        let storyboard = UIStoryboard(name: "MakingConnections", bundle: nil)
        if puzzleType == 1 {
            print("pindah bisa")
            let vc = storyboard.instantiateViewController(identifier: "editConnections") as! MakingConnectionsViewController
            vc.puzzleType = 1
            vc.puzzle2Detail = puzzle2Detail
            vc.dataId = dataId
            self.show(vc, sender: nil)
        }
        if puzzleType == 2 {
            let vc = storyboard.instantiateViewController(identifier: "editConnections") as! MakingConnectionsViewController
            vc.puzzleType = 2
            vc.puzzle3Detail = puzzle3Detail
            vc.dataId = dataId
            self.show(vc, sender: nil)
        }
        if puzzleType == 3 {
            let vc = storyboard.instantiateViewController(identifier: "editConnections") as! MakingConnectionsViewController
            vc.puzzleType = 3
            vc.puzzle4Detail = puzzle4Detail
            vc.dataId = dataId
            self.show(vc, sender: nil)
        }
    }
    
}
