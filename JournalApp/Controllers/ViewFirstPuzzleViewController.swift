//
//  ViewFirstPuzzleViewController.swift
//  JournalApp
//
//  Created by Muhammad Rizki Miftha Alhamid on 6/27/21.
//

import UIKit

class ViewFirstPuzzleViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var detailsTextView: UITextView!
    
    public var dataId: Int64 = 0
    public var readingTitle = String()
    public var puzzleDetail = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        detailsTextView.layer.cornerRadius = 5
        detailsTextView.delegate = self
        detailsTextView.textColor = .black
        
        adjustText()
    }
    
    func adjustText() {
        self.title = readingTitle
        detailsTextView.text = puzzleDetail
    }
    
    @IBAction func editPuzzle(_ sender: Any) {
        let storyboard = UIStoryboard(name: "FirstPuzzle", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "editPuzzle") as! EditFirstPuzzleViewController
        vc.puzzleDetail = puzzleDetail
        vc.readingTitle = readingTitle
        vc.dataId = dataId
        self.show(vc, sender: nil)
    }
}
