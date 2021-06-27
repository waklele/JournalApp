//
//  JournalListViewController.swift
//  JournalApp
//
//  Created by Muhammad Rizki Miftha Alhamid on 6/16/21.
//

import UIKit
import CoreData

private let reuseIdentifier = "JournalCell"

class JournalListViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let searchController = UISearchController(searchResultsController: nil)
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var journalList: [Journal] = [Journal]()
    var journalSelectionIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        // Register cell classes
        let nibCell = UINib(nibName: "JournalListCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        
        // Customize back button
        let backItem = UIBarButtonItem()
        backItem.title = "Kembali"
        navigationItem.backBarButtonItem = backItem
        
        managedObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        
        readData(filterValue: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readData(filterValue: "")
    }
    
    func readData(filterValue: String) {
        let journalRequest: NSFetchRequest<Journal> = Journal.fetchRequest()
        if !filterValue.isEmpty {
            journalRequest.predicate = NSPredicate(format: "title BEGINSWITH[cd] %@", filterValue)
        }
        let sortDescriptor = NSSortDescriptor(key: "lastUpdateDate", ascending: false)
        journalRequest.sortDescriptors = [sortDescriptor]
        
        do {
            try journalList = managedObjectContext.fetch(journalRequest)
        } catch {
            print("Error loading the journal list")
        }
        self.collectionView.reloadData()
    }
    
    func removeData(dataId : Int) {
        let journalRequestResult = NSFetchRequest<NSFetchRequestResult>(entityName: "Journal")
        journalRequestResult.predicate = NSPredicate(format: "id = %d", dataId)
        print("\(dataId)")
        do {
            let objects = try managedObjectContext.fetch(journalRequestResult)
            let objectToBeDeleted = objects[0] as! NSManagedObject
            
            managedObjectContext.delete(objectToBeDeleted)
            print("data deleted")
            
            do {
                try managedObjectContext.save()
            } catch {
                print("error when saving the data after deletion")
            }
        } catch {
            print("Error when deleting the data!")
        }
        readData(filterValue: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddNewJournalController {
            vc.itemSavedDelegate = self
            vc.journalCount = journalList.reversed()
            print("JOURNAL COUNT: ",journalList.count)
        }
        if let vc = segue.destination as? JournalPuzzleViewController {
            vc.readingTitle = journalList[journalSelectionIndex].title ?? ""
            vc.dataId = journalList[journalSelectionIndex].id
            vc.puzzle1Detail = journalList[journalSelectionIndex].puzzle1Detail ?? ""
            vc.puzzle2Detail = journalList[journalSelectionIndex].puzzle2Detail ?? ""
            vc.puzzle3Detail = journalList[journalSelectionIndex].puzzle3Detail ?? ""
            vc.puzzle4Detail = journalList[journalSelectionIndex].puzzle4Detail ?? ""
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
        return CGSize(width: UIScreen.main.bounds.width/2-20, height: 180)
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(journalList[indexPath.row])")
        journalSelectionIndex = indexPath.row
        performSegue(withIdentifier: "editJournal", sender: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedAction in
            
            let delete = UIAction(title: "Hapus Catatan", image: UIImage(systemName: "trash"), attributes: .destructive) { (_) in
                //
                print(self.journalList[indexPath.row])
                self.showDeleteWarning(dataId: Int(self.journalList[indexPath.row].id))
            }
            
            return UIMenu(title: "", children: [delete])
        }
    }
    
    func showDeleteWarning(dataId: Int) {
        let alert = UIAlertController(title: "Peringatan", message: "Apakah kamu yakin menghapus catatan ini?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Batalkan", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Hapus", style: .destructive) { _ in
            DispatchQueue.main.async {
                self.removeData(dataId: dataId)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
}

extension JournalListViewController: itemSavedDelegate {
    func itemSaved() {
        readData(filterValue: "")
    }
}

extension JournalListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("FILTER", searchText)
        readData(filterValue: searchText)
    }
}
