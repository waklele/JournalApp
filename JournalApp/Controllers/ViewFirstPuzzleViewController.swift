//
//  ViewFirstPuzzleViewController.swift
//  JournalApp
//
//  Created by Muhammad Rizki Miftha Alhamid on 6/27/21.
//

import UIKit
import CoreData

class ViewFirstPuzzleViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var detailsTextView: UITextView!
    
    public var dataId: Int64 = 0
    public var readingTitle = String()
    public var puzzleDetail = String()
    
    var journalList = [Journal]()
    var itemSavedDelegate: itemSavedDelegate?
    
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        detailsTextView.layer.cornerRadius = 5
        detailsTextView.delegate = self
        detailsTextView.textColor = .black
    
        // Customize back button
        let backItem = UIBarButtonItem()
        backItem.title = "Kembali"
        navigationItem.backBarButtonItem = backItem
        
        adjustText()
        
        managedObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        itemSavedDelegate?.itemSaved()
    }
    
    func adjustText() {
        self.title = readingTitle
        detailsTextView.text = puzzleDetail
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
        readingTitle = journalList[0].title ?? ""
        puzzleDetail = journalList[0].puzzle1Detail ?? ""
        adjustText()
    }
    
    @IBAction func editPuzzle(_ sender: Any) {
        let storyboard = UIStoryboard(name: "FirstPuzzle", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "editPuzzle") as! EditFirstPuzzleViewController
        vc.puzzleDetail = puzzleDetail
        vc.readingTitle = readingTitle
        vc.dataId = dataId
        vc.itemSavedDelegate = self
        self.show(vc, sender: nil)
    }
}

extension ViewFirstPuzzleViewController: itemSavedDelegate {
    func itemSaved() {
        readData()
    }
}

