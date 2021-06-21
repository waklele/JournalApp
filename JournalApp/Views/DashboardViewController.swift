//
//  DashboardViewController.swift
//  JournalApp
//
//  Created by Muhammad Rizki Miftha Alhamid on 6/21/21.
//

import UIKit
import CoreData

private let reuseIdentifier = "JournalCell"

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var journalList: [Journal] = [Journal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nibCell = UINib(nibName: "JournalListCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: reuseIdentifier)
        
        managedObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        // Do any additional setup after loading the view.
        
        readData()
        checkTodaysJournal()
    }
    
    func readData() {
        let journalRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "lastUpdateDate", ascending: false)
        journalRequest.sortDescriptors = [sortDescriptor]
        
        do {
            try journalList = managedObjectContext.fetch(journalRequest)
        } catch {
            print("Error loading the journal list")
        }
        self.collectionView.reloadData()
    }
    
    func checkTodaysJournal() -> Bool {
        let currentDate = Date()
        let lastJournalDate = journalList[0].createDate ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        if dateFormatter.string(from: currentDate) == dateFormatter.string(from: lastJournalDate) {
            return true
        }
        return false
    }

}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset:CGFloat = 10
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2-20, height: 136)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? JournalListCell else {
            return UICollectionViewCell()
        }
        
        // Configure the cell
        let journal = journalList[indexPath.row]
        
        cell.configureJournal(with: journal)

        return cell
    }
    
    
}
