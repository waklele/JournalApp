//
//  MakingConnectionsViewController.swift
//  JournalApp
//
//  Created by Muhammad Rizki Miftha Alhamid on 6/25/21.
//

import UIKit
import Speech
import CoreData

class MakingConnectionsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var promptImage: UIImageView!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    public var puzzleType: Int = 0
    public var dataId: Int64 = 0
    public var readingTitle = String()
    public var puzzle1Detail = String()
    public var puzzle2Detail = String()
    public var puzzle3Detail = String()
    public var puzzle4Detail = String()
    
    var journalList = [Journal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        saveButton.roundedButton(radius: 10)
        self.title = ""

        detailsTextView.layer.cornerRadius = 5
        detailsTextView.delegate = self
        detailsTextView.text = "Insert detail here..."
        detailsTextView.textColor = UIColor.lightGray
        
        managedObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        
        adjustPrompt()
    }
    
    func adjustPrompt() {
        if puzzleType == 1 {
            promptImage.image = UIImage(named: "Tambah Text-to-self Baru Dong")
            self.title = "Text-to-Self"
            if !puzzle2Detail.isEmpty {
                detailsTextView.text = puzzle2Detail
                detailsTextView.textColor = .black
            }
        } else if puzzleType == 2 {
            promptImage.image = UIImage(named: "Tambah Text-to-text Baru Dong")
            self.title = "Text-to-Text"
            if !puzzle3Detail.isEmpty {
                detailsTextView.text = puzzle3Detail
                detailsTextView.textColor = .black
            }
        } else if puzzleType == 3 {
            promptImage.image = UIImage(named: "Tambah Text-to-world Baru Dong")
            self.title = "Text-to-World"
            if !puzzle4Detail.isEmpty {
                detailsTextView.text = puzzle4Detail
                detailsTextView.textColor = .black
            }
        } else {
            print("error")
        }
    }
    
    
    @IBAction func saveConnection(_ sender: Any) {
        let journalRequestResult = NSFetchRequest<NSFetchRequestResult>(entityName: "Journal")
        journalRequestResult.predicate = NSPredicate(format: "id = %d", dataId)
        print(dataId)
        do {
            let objects = try managedObjectContext.fetch(journalRequestResult)
            print(objects[0])
            let objectToBeEdited = objects[0] as! NSManagedObject
            
//            objectToBeEdited.setValue(dataId, forKey: "id")
//            objectToBeEdited.setValue(readingTitle, forKey: "title")
            if puzzleType == 1 {
                objectToBeEdited.setValue(detailsTextView.text, forKey: "puzzle2Detail")
                print("berhasil")
            }
            if puzzleType == 2 {
                objectToBeEdited.setValue(detailsTextView.text, forKey: "puzzle3Detail")
            }
            if puzzleType == 3 {
                objectToBeEdited.setValue(detailsTextView.text, forKey: "puzzle4Detail")
            }
            
            do {
                try managedObjectContext.save()
            } catch {
                print("error1")
            }
        } catch {
            print("error2")
        }
        //self.dismiss(animated: true, completion: nil)
        //navigationController?.popToRootViewController(animated: true)
        navigationController?.popViewController(animated: true)
    }
}

extension MakingConnectionsViewController {
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
}
