//
//  JournalPuzzleViewController.swift
//  JournalApp
//
//  Created by Muhammad Rizki Miftha Alhamid on 6/17/21.
//

import UIKit
import CoreData

class JournalPuzzleViewController: UIViewController {
    @IBOutlet weak var puzzle: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    public var dataId: Int64 = 0
    public var readingTitle = String()
    public var puzzle1Detail = String()
    public var puzzle2Detail = String()
    public var puzzle3Detail = String()
    public var puzzle4Detail = String()
    
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var journalList = [Journal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.roundedButton(radius: 10)
        
        puzzle.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.puzzle.addGestureRecognizer(tapGestureRecognizer)
        
        adjustPuzzle()
        
        // Customize back button
        let backItem = UIBarButtonItem()
        backItem.title = "Kembali"
        navigationItem.backBarButtonItem = backItem
        
        self.tabBarController?.navigationItem.hidesBackButton = true
        let view = UIView()
        let button = UIButton(type: .system)
        button.semanticContentAttribute = .forceLeftToRight
        button.setImage(UIImage(systemName : "chevron.backward"), for: .normal)
        button.setTitle("Kembali", for: .normal)
        button.addTarget(self, action: #selector(popUp), for: .touchUpInside)
        button.sizeToFit()
        view.addSubview(button)
        view.frame = button.bounds
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: view)
        
        managedObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
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
        puzzle1Detail = journalList[0].puzzle1Detail ?? ""
        puzzle2Detail = journalList[0].puzzle2Detail ?? ""
        puzzle3Detail = journalList[0].puzzle3Detail ?? ""
        puzzle4Detail = journalList[0].puzzle4Detail ?? ""
        adjustPuzzle()
    }
    
    @objc func popUp() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "JournalPuzzle", bundle: nil)
        let popUp = storyBoard.instantiateViewController(withIdentifier: "popUp")
        let selamat = storyBoard.instantiateViewController(withIdentifier: "selamatView")
        
        if !puzzle2Detail.isEmpty, !puzzle3Detail.isEmpty, !puzzle4Detail.isEmpty {
            self.navigationController?.pushViewController(selamat, animated: true)
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "JournalPuzzle", bundle: nil)
            let selamat = storyBoard.instantiateViewController(withIdentifier: "selamatView")
            self.present(popUp, animated: true, completion: nil)
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)

        if parent == nil {
            debugPrint("Back Button pressed.")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if !puzzle2Detail.isEmpty, !puzzle3Detail.isEmpty, !puzzle4Detail.isEmpty {
             print("Full semuaa")
            let storyBoard: UIStoryboard = UIStoryboard(name: "JournalPuzzle", bundle: nil)
            let selamat = storyBoard.instantiateViewController(withIdentifier: "selamatView")
            self.navigationController?.pushViewController(selamat, animated: true)
             return false
        } else {
            return true
        }
    }
    
    func adjustPuzzle() {
        self.title = readingTitle
        if !puzzle2Detail.isEmpty {
            if !puzzle3Detail.isEmpty {
                if !puzzle4Detail.isEmpty {
                    // full
                    puzzle.image = UIImage(named: "Puzzle Full")
                } else {
                    // 1, 2, 3
                    puzzle.image = UIImage(named: "Puzzle Incomplete 2.1")
                }
            } else {
                if !puzzle4Detail.isEmpty {
                    // 1, 2, 4
                    puzzle.image = UIImage(named: "Puzzle Incomplete 2.2")
                } else {
                    // 1, 2
                    puzzle.image = UIImage(named: "Puzzle Incomplete 1.1")
                }
            }
        } else {
            if !puzzle3Detail.isEmpty {
                if !puzzle4Detail.isEmpty {
                    // 1, 3, 4
                    puzzle.image = UIImage(named: "Puzzle Incomplete 2.3")
                } else {
                    // 1, 3
                    puzzle.image = UIImage(named: "Puzzle Incomplete 1.2")
                }
            } else {
                if !puzzle4Detail.isEmpty {
                    // 1, 4
                    puzzle.image = UIImage(named: "Puzzle Incomplete 1.3")
                } else {
                    // 1
                    puzzle.image = UIImage(named: "Puzzle Incomplete")
                }
            }
        }
    }
    
    @objc func tapAction(sender: UITapGestureRecognizer) {

         let touchPoint = sender.location(in: self.puzzle)

        let z1 = touchPoint.x
        let z2 = touchPoint.y

         //convert point into Percentage
         let z1per =  z1 * 100 / self.puzzle.frame.size.width
         let z2per =  z2 * 100 / self.puzzle.frame.size.height

         print("After Alert Touched point (\(z1per), \(z2per)")
        
        let storyboard = UIStoryboard(name: "MakingConnections", bundle: nil)
        
        if z1per > 50 && z2per < 50 {
            print("Kanan atas")
            if !puzzle2Detail.isEmpty {
                let vc = storyboard.instantiateViewController(identifier: "viewConnections") as! ViewConnectionsViewController
                vc.puzzleType = 1
                vc.puzzle2Detail = puzzle2Detail
                vc.dataId = dataId
                vc.itemSavedDelegate = self
                self.show(vc, sender: nil)
            } else {
                let vc = storyboard.instantiateViewController(identifier: "editConnections") as! MakingConnectionsViewController
                vc.puzzleType = 1
                
                //vc.puzzleKey = "puzzle2Detail"
                
                vc.dataId = dataId
                vc.itemSavedDelegate = self
                self.show(vc, sender: nil)
            }
        } else if z1per > 50 && z2per > 50 {
            print("Kanan bawah")
            if !puzzle3Detail.isEmpty {
                let vc = storyboard.instantiateViewController(identifier: "viewConnections") as! ViewConnectionsViewController
                vc.puzzleType = 2
                vc.puzzle3Detail = puzzle3Detail
                vc.dataId = dataId
                vc.itemSavedDelegate = self
                self.show(vc, sender: nil)
            } else {
                let vc = storyboard.instantiateViewController(identifier: "editConnections") as! MakingConnectionsViewController
                vc.puzzleType = 2
                
                //vc.puzzleKey = "puzzle3Detail"
                
                vc.dataId = dataId
                vc.itemSavedDelegate = self
                self.show(vc, sender: nil)
            }
        } else if z1per < 50 && z2per < 50 {
            print("Kiri atas")
            let storyboard2 = UIStoryboard(name: "FirstPuzzle", bundle: nil)
            let vc = storyboard2.instantiateViewController(identifier: "viewPuzzle") as! ViewFirstPuzzleViewController
            vc.dataId = dataId
            vc.puzzleDetail = puzzle1Detail
            vc.readingTitle = readingTitle
            vc.itemSavedDelegate = self
            self.show(vc, sender: nil)
        } else {
            print("Kiri bawah")
            if !puzzle4Detail.isEmpty {
                let vc = storyboard.instantiateViewController(identifier: "viewConnections") as! ViewConnectionsViewController
                vc.puzzleType = 3
                vc.puzzle4Detail = puzzle4Detail
                vc.dataId = dataId
                vc.itemSavedDelegate = self
                self.show(vc, sender: nil)
            } else {
                let vc = storyboard.instantiateViewController(identifier: "editConnections") as! MakingConnectionsViewController
                vc.puzzleType = 3
                
                //vc.puzzleKey = "puzzle4Detail"
                
                vc.dataId = dataId
                vc.itemSavedDelegate = self
                self.show(vc, sender: nil)
            }
        }
   }
    
}

extension JournalPuzzleViewController: itemSavedDelegate {
    func itemSaved() {
        readData()
    }
}
