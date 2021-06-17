//
//  JournalListViewController.swift
//  JournalApp
//
//  Created by Muhammad Rizki Miftha Alhamid on 6/16/21.
//

import UIKit
import CoreData

private let reuseIdentifier = "JournalCell"

class JournalListViewController: UICollectionViewController, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {
    let searchController = UISearchController(searchResultsController: nil)
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var journalList: [Journal] = [Journal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
       
        
        // Register cell classes
        let nibCell = UINib(nibName: "JournalListCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        managedObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        
        readData()
    }
    
    func readData() {
        let journalRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        do {
            try journalList = managedObjectContext.fetch(journalRequest)
        } catch {
            print("Error loading the journal list")
        }
        self.collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddNewJournalController {
            vc.journalSavedDelegate = self
        }
        
    }
    
    
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return journalList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset:CGFloat = 10
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2-20, height: 136)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? JournalListCell else {
            return UICollectionViewCell()
        }
        
        // Configure the cell
        let journal = journalList[indexPath.row]
        
        cell.configureJournal(with: journal)

        return cell
    }


}

extension JournalListViewController: journalSavedDelegate {
    func journalSaved() {
        readData()
    }
}
