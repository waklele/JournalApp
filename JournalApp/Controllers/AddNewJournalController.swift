//
//  AddNewJournalController.swift
//  JournalApp
//
//  Created by Albert . on 17/06/21.
//

import UIKit
import CoreData
import Speech

protocol journalSavedDelegate: class {
    func journalSaved()
}

class AddNewJournalController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var startStopBtn: UIButton!
    
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "id-ID"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()
    var lang: String = "id-ID"
    
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var journalList = [Journal]()
    var journalSavedDelegate: journalSavedDelegate?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = ""
        self.hideKeyboardWhenTappedAround()
        detailsTextView.custom()
        
        
        startStopBtn.isEnabled = false
        speechRecognizer?.delegate = self as? SFSpeechRecognizerDelegate
        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: lang))
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
                    
                    var isButtonEnabled = false
                    
                    switch authStatus {  //5
                    case .authorized:
                        isButtonEnabled = true
                        
                    case .denied:
                        isButtonEnabled = false
                        print("User denied access to speech recognition")
                        
                    case .restricted:
                        isButtonEnabled = false
                        print("Speech recognition restricted on this device")
                        
                    case .notDetermined:
                        isButtonEnabled = false
                        print("Speech recognition not yet authorized")
                        
                    @unknown default:
                        print("Error")
                    }
                    
                    OperationQueue.main.addOperation() {
                        self.startStopBtn.isEnabled = isButtonEnabled
                    }
                }

        saveButton.roundedButton(radius: 10)
        detailsTextView.layer.borderWidth = 0.0
        
//        titleTextField.layer.borderColor = UIColor.gray.cgColor
//        titleTextField.layer.borderWidth = 1.0
        titleTextField.layer.cornerRadius = 5
        titleTextField.delegate = self
        titleTextField.text = "Masukkan judulnya disini..."
        titleTextField.textColor = UIColor.lightGray

//        detailsTextView.layer.borderColor = UIColor.gray.cgColor
//        detailsTextView.layer.borderWidth = 1.0
        detailsTextView.layer.cornerRadius = 5
        detailsTextView.delegate = self
//        detailsTextView.text = "Masukkan detailnya disini..."
//        detailsTextView.textColor = UIColor.lightGray
        
        managedObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        // Hide the navigation bar for current view controller
//        self.navigationController?.isNavigationBarHidden = true;
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        // Show the navigation bar on other view controllers
//       self.navigationController?.isNavigationBarHidden = false;
//    }
//
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if titleTextField.textColor == UIColor.lightGray {
            titleTextField.text = ""
            titleTextField.textColor = UIColor.black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if titleTextField.text == "" {

            titleTextField.text = "Masukkan judulnya disini..."
            titleTextField.textColor = UIColor.lightGray
        }
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if detailsTextView.textColor == UIColor.lightGray {
//            detailsTextView.text = ""
//            detailsTextView.textColor = UIColor.black
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//
//        if detailsTextView.text == "" {
//            detailsTextView.text = "Masukkan detailnya disini"
//            detailsTextView.textColor = UIColor.lightGray
//
//            detailsTextView.becomeFirstResponder()
//
//            detailsTextView.selectedTextRange = detailsTextView.textRange(from: detailsTextView.beginningOfDocument, to: detailsTextView.beginningOfDocument)
//        }
//    }
    
    @IBAction func saveJournal(_ sender: Any) {
        let journalRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        do {
            try journalList = managedObjectContext.fetch(journalRequest)
            
            let entity = NSEntityDescription.entity(forEntityName: "Journal", in: managedObjectContext)
            let newJournal = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
            // id here
            
            if titleTextField.text == "Masukkan judulnya disini..." || detailsTextView.text == "Masukkan judulnya disini..." {
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



// Speech to text
extension AddNewJournalController {
    @IBAction func startStopAct(_ sender: Any) {
        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: lang))
                
                if audioEngine.isRunning {
                    audioEngine.stop()
                    recognitionRequest?.endAudio()
                    startStopBtn.isEnabled = false
//                    startStopBtn.setTitle("Start Recording", for: .normal)
                } else {
                    startRecording()
//                    startStopBtn.setTitle("Stop Recording", for: .normal)
                }
    }
    
    func startRecording() {
            
            if recognitionTask != nil {
                recognitionTask?.cancel()
                recognitionTask = nil
            }
            
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.record)
                try audioSession.setMode(AVAudioSession.Mode.measurement)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("audioSession properties weren't set because of an error.")
            }
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            let inputNode = audioEngine.inputNode
            
            guard let recognitionRequest = recognitionRequest else {
                fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
            }
            
            recognitionRequest.shouldReportPartialResults = true
            
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
                
                var isFinal = false
                
                if result != nil {
                    
                    
                    let nextString = result?.bestTranscription.formattedString
                    print("NEXT: ",nextString!)
                    
                    isFinal = (result?.isFinal)!
                    if isFinal {
                        var prevString = self.detailsTextView.text
                        print("PREV: ",prevString!)
                        
                        if prevString?.last == " " {
                            prevString!.removeLast()
                        }
                        
                        self.detailsTextView.text = "\(prevString ?? "") \(nextString ?? "")"
                    }
                }
                
                if error != nil || isFinal {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    
                    self.startStopBtn.isEnabled = true
                }
            })
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            
            do {
                try audioEngine.start()
            } catch {
                print("audioEngine couldn't start because of an error.")
            }
            
//            textView1.text = "Say something, I'm listening!"
//            textView2.text = "Say something, I'm listening!"
//            textField3.text = "Say something, I'm listening!"
            
        }
        
        func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
            if available {
                print("Available...")
                startStopBtn.isEnabled = true
            } else {
                print("Unavailable...")
                startStopBtn.isEnabled = false
            }
        }

}
