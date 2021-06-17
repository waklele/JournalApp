//
//  AddNewJournalController.swift
//  JournalApp
//
//  Created by Albert . on 17/06/21.
//

import UIKit

class AddNewJournalController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var saveButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.layer.cornerRadius = 10
        
        titleTextField.layer.borderColor = UIColor.gray.cgColor
        titleTextField.layer.borderWidth = 1.0
        titleTextField.layer.cornerRadius = 5
        titleTextField.delegate = self
        titleTextField.text = "Insert detail here..."
        titleTextField.textColor = UIColor.lightGray

        detailsTextView.layer.borderColor = UIColor.gray.cgColor
        detailsTextView.layer.borderWidth = 1.0
        detailsTextView.layer.cornerRadius = 5
        detailsTextView.delegate = self
        detailsTextView.text = "Insert detail here..."
        detailsTextView.textColor = UIColor.lightGray
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
}
