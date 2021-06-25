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
    
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var journalList = [Journal]()
    var journalSavedDelegate: journalSavedDelegate?
    
    // MARK - Local properties
    let audioEngine = AVAudioEngine()
    let speechReconizer : SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "id-ID"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var task : SFSpeechRecognitionTask?
    var isStart : Bool = false
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        saveButton.roundedButton(radius: 10)
        self.title = ""
        
        titleTextField.layer.cornerRadius = 5
        titleTextField.delegate = self
        
        detailsTextView.layer.cornerRadius = 5
        detailsTextView.delegate = self

        requestPermision()
        managedObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
    }
    
    @IBAction func saveJournal(_ sender: Any) {
        let journalRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        do {
            try journalList = managedObjectContext.fetch(journalRequest)
            
            let entity = NSEntityDescription.entity(forEntityName: "Journal", in: managedObjectContext)
            let newJournal = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
            
            if titleTextField.text == "Insert title here..." || detailsTextView.text == "Insert detail here..." {
                print("Isi dulu")
            } else {
                
                // id here
                var incrementId = 0
                if journalList.count == 0 {
                    incrementId = 1
                } else {
                    incrementId = Int(journalList.last!.id + 1)
                }
                
                newJournal.setValue(incrementId, forKey: "id")
                newJournal.setValue(titleTextField.text, forKey: "title")
                newJournal.setValue(detailsTextView.text, forKey: "puzzle1Detail")
                //set date
                newJournal.setValue(NSDate.now, forKey: "createDate")
                newJournal.setValue(NSDate.now, forKey: "lastUpdateDate")
                
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

extension AddNewJournalController {
    
    @IBAction func startStopAct(_ sender: UIButton) {
        isStart = !isStart
        
        if isStart {
            startSpeechRecognition()
            startStopBtn.setImage(UIImage(systemName: "stop.circle"), for: .normal)
        } else {
            cancelSpeechRecognition()
            startStopBtn.setImage(UIImage(systemName: "mic.circle"), for: .normal)
        }
    }
    
    func requestPermision() {
        self.startStopBtn.isEnabled = false
        SFSpeechRecognizer.requestAuthorization { authState in
            OperationQueue.main.addOperation {
                if authState == .authorized {
                    self.startStopBtn.isEnabled = true
                } else if authState == .denied {
                    self.alertView(message: "User denied the permission")
                } else if authState == .notDetermined {
                    self.alertView(message: "In User phone there is no speech recognition")
                } else if authState == .restricted {
                    self.alertView(message: "User has been restricted for using the speech recognization")
                }
            }
        }
    }

    func startSpeechRecognition() {
        print("Speech Recognition has been started")
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch let error {
            alertView(message: "Error comes here for starting the audio listener \(error.localizedDescription)")
        }
        
        guard let myRecognization = SFSpeechRecognizer() else {
            self.alertView(message: "Recognization is not allow on your local")
            return
        }
        
        if !myRecognization.isAvailable {
            self.alertView(message: "Recognition is free right now, please try again after some time.")
        }
        
        task = speechReconizer?.recognitionTask(with: request, resultHandler: { response, error in
            guard let response = response else {
                if error != nil {
                    self.alertView(message: error.debugDescription)
                } else {
                    self.alertView(message: "Problem in giving the response")
                }
                return
            }


            let message = response.bestTranscription.formattedString
            print("MESSAGE: ", message)

            if response.isFinal {
                var prevString = self.detailsTextView.text
                print("PREV: ", prevString!)

                if prevString?.last == " " {
                    prevString!.removeLast()
                }

                self.detailsTextView.text = "\(prevString ?? "") \(message )"
            }
        })
    }
    
    func cancelSpeechRecognition() {
        task?.finish()
        task?.cancel()
        task = nil
        
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        print("Speech Recognition has been shuted down")
    }
    
    func alertView(message: String) {
        let controller = UIAlertController.init(title: "Error occured...!", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            controller.dismiss(animated: true, completion: nil)
        }))
        self.present(controller, animated: true, completion: nil)
    }
    
    func restartSpeechTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
            self.cancelSpeechRecognition()
        })
    }

}
