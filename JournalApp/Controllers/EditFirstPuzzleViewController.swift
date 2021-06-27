//
//  EditFirstPuzzleViewController.swift
//  JournalApp
//
//  Created by Muhammad Rizki Miftha Alhamid on 6/27/21.
//

import UIKit
import Speech
import CoreData

class EditFirstPuzzleViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var startStopBtn: UIButton!
    
    public var dataId: Int64 = 0
    public var readingTitle = String()
    public var puzzleDetail = String()
    var itemSavedDelegate: itemSavedDelegate?
    
    var managedObjectContext                                        = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var appDelegate                                                 = UIApplication.shared.delegate as? AppDelegate
    
    //MARK: - Local Properties
    let audioEngine         : AVAudioEngine                         = AVAudioEngine()
    let speechReconizer     : SFSpeechRecognizer?                   = SFSpeechRecognizer(locale: Locale.init(identifier: "id-ID"))
    var request             : SFSpeechAudioBufferRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    var task                : SFSpeechRecognitionTask?
    var isStart             : Bool                                  = true
    var isStartCount        : Int                                   = 0
    var firstText           : Bool                                  = true
    var textViewTouched     : Bool                                  = false
    
    fileprivate var timer:Timer?
    private var messageStrings          : [String]                  = [String]()
    private var tempPrevStrings         : [String]                  = [String]()
    private var fullMessageString       : String                    = ""
    private var singleMessageString     : String                    = ""
    private var finalString             : String                    = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        saveButton.roundedButton(radius: 10)
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor.systemGray3
        self.title = readingTitle
        
        titleTextField.layer.cornerRadius = 8
        titleTextField.text = readingTitle
        titleTextField.textColor = UIColor.systemGray3
        titleTextField.delegate = self
        
        detailsTextView.layer.cornerRadius = 8
        detailsTextView.text = puzzleDetail
        detailsTextView.textColor = UIColor.systemGray3
        detailsTextView.font = UIFont.preferredFont(forTextStyle: .body)
        detailsTextView.delegate = self

        managedObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext

    }
    
    @IBAction func savePuzzle(_ sender: Any) {
            let journalRequestResult = NSFetchRequest<NSFetchRequestResult>(entityName: "Journal")
            journalRequestResult.predicate = NSPredicate(format: "id = %d", dataId)
            print(dataId)
            do {
                let objects = try managedObjectContext.fetch(journalRequestResult)
                print(objects[0])
                let objectToBeEdited = objects[0] as! NSManagedObject
                
                objectToBeEdited.setValue(titleTextField.text, forKey: "title")
                objectToBeEdited.setValue(detailsTextView.text, forKey: "puzzle1Detail")
                objectToBeEdited.setValue(NSDate.now, forKey: "lastUpdateDate")
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print("error1")
                }
            } catch {
                print("error2")
            }
            itemSavedDelegate?.itemSaved()
            //self.dismiss(animated: true, completion: nil)
            //navigationController?.popToRootViewController(animated: true)
            navigationController?.popViewController(animated: true)
    }
    
}

extension EditFirstPuzzleViewController {
    
    @IBAction func startStopAct(_ sender: UIButton) {
        //        isStart = !isStart

        if isStart {
            self.isStartCount += 1
            startSpeechRecognition()
        } else {
            cancelSpeechRecognition()
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
        
        self.messageStrings.removeAll()
        self.tempPrevStrings.removeAll()
        self.fullMessageString = ""
        self.finalString = ""
        self.singleMessageString = ""
        
        self.startStopBtn.setImage(UIImage(named: "Stop Speech Button"), for: .normal)
        
        print("Speech Recognition has been started")
        request = SFSpeechAudioBufferRecognitionRequest()   // recreates recognitionRequest object.
        
        audioEngine.inputNode.removeTap(onBus: 0)
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        request.shouldReportPartialResults = true
        
        
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
                    print("Error 1")
                    self.cancelSpeechRecognition()
                    self.alertView(message: "Speech Recognizer has not ready yet")
                } else {
                    print("Error 2")
                    self.cancelSpeechRecognition()
                    self.alertView(message: "Problem in giving the response")
                }
                return
            }
            
            
            
            if response != nil {
                
                self.timer?.invalidate()
                self.timer = nil
                
                self.singleMessageString = response.bestTranscription.formattedString
                print("Message -> ",self.singleMessageString)
                
                
                if self.textViewTouched == false && self.isStartCount == 1{
                    
                    print("--- One ---")
                    self.messageStrings.append(self.singleMessageString)
                    self.timerReStart(condition: 1)
                    
                } else if self.isStartCount > 1 || self.textViewTouched == true {
                    print("--- Two ---")
                    self.tempPrevStrings.append(self.detailsTextView.text)
                    self.messageStrings.append(self.singleMessageString)
                    print("NOW: ",self.messageStrings)
                    self.timerReStart(condition: 2)
                }

//                if self.textViewTouched == true {
//                    print("--- ONE ---")
//                    var prevString = self.detailsTextView.text
//
//                    if prevString?.last == " " {
//                        prevString!.removeLast()
//                    }
//
//                    if prevString == "Coba ceritakan kembali apa yang kamu baca" {
//                        prevString = ""
//                    }
//
//                    self.messageStrings.append("\(self.singleMessageString)")
//                    self.timerReStart(condition: 3)
//                }
//
//                if self.textViewTouched == true && self.detailsTextView.text != "" && self.detailsTextView.text != "Coba ceritakan kembali apa yang kamu baca" {
//                    print("--- TWO ---")
//                    if self.detailsTextView.text != self.singleMessageString {
//                        self.messageStrings.append("\(self.detailsTextView.text ?? "") \(self.singleMessageString)")
//                        self.detailsTextView.text = ""
//                    }
//
//                }
                
                
                
            }
        })
        isStart = false
    }
    
    func timerReStart(condition: Int) {
        if condition == 1 {
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.handleTimerValue1), userInfo: nil, repeats: false)
        } else if condition == 2 {
            timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.handleTimerValue2), userInfo: nil, repeats: false)
        } else if condition == 3 {
            
        }
    }
    
    
    
    @objc func handleTimerValue() {
        print("mS: ",messageStrings)
        print("INDEX: ",self.messageStrings.endIndex - 1)
        
        if task != nil {
            if self.messageStrings.endIndex - 1 != -1 {
                self.fullMessageString = "\(self.detailsTextView.text ?? "")\(self.messageStrings[self.messageStrings.endIndex - 1])"
                
                self.detailsTextView.text = self.fullMessageString
                
                self.messageStrings.removeAll()
            }
        }
    }
    
    @objc func handleTimerValue1() {
        print("mS: ",messageStrings)
        print("INDEX: ",self.messageStrings.endIndex - 1)
        if task != nil && self.messageStrings.endIndex - 1 != -1 {
            
            self.detailsTextView.text = self.messageStrings[self.messageStrings.endIndex - 1]
            self.detailsTextView.textColor = UIColor.black
            self.messageStrings.removeAll()
        }
    }
    
    @objc func handleTimerValue2() {
        timer!.invalidate()
        print("mS: ",messageStrings)
        //        self.messageStrings = self.messageStrings.uniqued()
        if task?.isFinishing != true && self.messageStrings.endIndex - 1 != -1 {
            self.detailsTextView.text = "\(self.tempPrevStrings.first ?? "") \(self.messageStrings[self.messageStrings.endIndex - 1])"
            self.detailsTextView.textColor = UIColor.black
        }
        
    }
    
    func timerStop() {
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
    }
    
    func cancelSpeechRecognition() {
        task?.finish()
        task?.cancel()
        
        self.messageStrings.removeAll()
        self.tempPrevStrings.removeAll()
        self.fullMessageString = ""
        self.finalString = ""
        self.singleMessageString = ""
        isStart = true
        
        request.endAudio()
        if audioEngine.inputNode.numberOfInputs > 0 {
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        audioEngine.stop()

        print("Speech Recognition has been shuted down")
        
        self.startStopBtn.setImage(UIImage(named: "Start Speech Button"), for: .normal)
    }
    
    func alertView(message: String) {
        let controller = UIAlertController.init(title: "Error occured...!", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            controller.dismiss(animated: true, completion: nil)
        }))
        self.present(controller, animated: true, completion: nil)
    }
    
    func restartSpeechTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
            self.cancelSpeechRecognition()
        })
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textViewTouched = true
        if detailsTextView.textColor == UIColor.systemGray3 || detailsTextView.text == "Coba ceritakan kembali apa yang kamu baca" {
            detailsTextView.text = ""
            detailsTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if detailsTextView.text == "" {
            detailsTextView.text = "Coba ceritakan kembali apa yang kamu baca"
            self.textViewTouched = false
            detailsTextView.textColor = UIColor.lightGray
        }
        
        if detailsTextView.text != "" && detailsTextView.text != "Coba ceritakan kembali apa yang kamu baca" {
            self.textViewTouched = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.validateText()
        self.textViewTouched = true
    }
    
    func validateText() {
        if titleTextField.text != "" && detailsTextView.textColor != UIColor.systemGray3 && detailsTextView.text != "Coba ceritakan kembali apa yang kamu baca" && detailsTextView.text != "" {
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor(red: 221/255, green: 66/255, blue: 123/255, alpha: 100)
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = UIColor.systemGray3
        }
    }
}
