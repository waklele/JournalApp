//
//  AddNewJournalController.swift
//  JournalApp
//
//  Created by Albert . on 17/06/21.
//

import UIKit
import CoreData

protocol journalSavedDelegate: class {
    func journalSaved()
}

class AddNewJournalController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var saveButton: UIView!
    
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var journalList = [Journal]()
    var journalSavedDelegate: journalSavedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.layer.cornerRadius = 10
        
        titleTextField.layer.borderColor = UIColor.gray.cgColor
        titleTextField.layer.borderWidth = 1.0
        titleTextField.layer.cornerRadius = 5
        titleTextField.delegate = self
        titleTextField.text = "Insert title here..."
        titleTextField.textColor = UIColor.lightGray

        detailsTextView.layer.borderColor = UIColor.gray.cgColor
        detailsTextView.layer.borderWidth = 1.0
        detailsTextView.layer.cornerRadius = 5
        detailsTextView.delegate = self
        detailsTextView.text = "Insert detail here..."
        detailsTextView.textColor = UIColor.lightGray
        
        managedObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if titleTextField.textColor == UIColor.lightGray {
            titleTextField.text = ""
            titleTextField.textColor = UIColor.black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if titleTextField.text == "" {

            titleTextField.text = "Insert title here..."
            titleTextField.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if detailsTextView.textColor == UIColor.lightGray {
            detailsTextView.text = ""
            detailsTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        if detailsTextView.text == "" {
            detailsTextView.text = "Insert detail here..."
            detailsTextView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func saveJournal(_ sender: Any) {
        let journalRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        do {
            try journalList = managedObjectContext.fetch(journalRequest)
            
            let entity = NSEntityDescription.entity(forEntityName: "Journal", in: managedObjectContext)
            let newJournal = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
            // id here
            
            if titleTextField.text == "Insert title here..." || detailsTextView.text == "Insert detail here..." {
                print("Isi dulu")
            } else {
                newJournal.setValue(titleTextField.text, forKey: "title")
                newJournal.setValue(detailsTextView.text, forKey: "puzzle1Detail")
                //set date
                
                try managedObjectContext.save()
                print("save success")
                //delegate
                journalSavedDelegate?.journalSaved()
            }
        } catch {
            print("save error")
        }
    }
    
    
}
