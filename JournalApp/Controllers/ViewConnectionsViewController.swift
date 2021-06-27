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
    
    var journalList = [Journal]()
    var itemSavedDelegate: itemSavedDelegate?
    
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = ""

        detailsTextView.layer.cornerRadius = 5
        detailsTextView.delegate = self
        detailsTextView.text = "Insert detail here..."
        detailsTextView.textColor = UIColor.lightGray
        
        // Customize back button
        let backItem = UIBarButtonItem()
        backItem.title = "Kembali"
        navigationItem.backBarButtonItem = backItem
        
        adjustPrompt()
        
        managedObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        itemSavedDelegate?.itemSaved()
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
    
    func readData() {
        let journalRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        journalRequest.predicate = NSPredicate(format: "id = %d", dataId)
        
        do {
            try journalList = managedObjectContext.fetch(journalRequest)
        } catch {
            print("Error loading the journal list")
        }
        
        do {
            try journalList = managedObjectContext.fetch(journalRequest)
        } catch {
            print("Error loading the journal list")
        }
        puzzle1Detail = journalList[0].puzzle1Detail ?? ""
        puzzle2Detail = journalList[0].puzzle2Detail ?? ""
        puzzle3Detail = journalList[0].puzzle3Detail ?? ""
        puzzle4Detail = journalList[0].puzzle4Detail ?? ""
        adjustPrompt()
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
            vc.itemSavedDelegate = self
            self.show(vc, sender: nil)
        }
        if puzzleType == 2 {
            let vc = storyboard.instantiateViewController(identifier: "editConnections") as! MakingConnectionsViewController
            vc.puzzleType = 2
            vc.puzzle3Detail = puzzle3Detail
            vc.dataId = dataId
            vc.itemSavedDelegate = self
            self.show(vc, sender: nil)
        }
        if puzzleType == 3 {
            let vc = storyboard.instantiateViewController(identifier: "editConnections") as! MakingConnectionsViewController
            vc.puzzleType = 3
            vc.puzzle4Detail = puzzle4Detail
            vc.dataId = dataId
            vc.itemSavedDelegate = self
            self.show(vc, sender: nil)
        }
    }
    
}

extension ViewConnectionsViewController: itemSavedDelegate {
    func itemSaved() {
        readData()
    }
}
