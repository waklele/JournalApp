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
    @IBOutlet weak var emptyImage: UIImageView!
    
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var journalList: [Journal] = [Journal]()
    var journalSelectionIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nibCell = UINib(nibName: "JournalListCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: reuseIdentifier)
        
        managedObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        // Do any additional setup after loading the view.
        
        imageButton.backgroundColor = .init(red: 221/255, green: 66/255, blue: 123/255, alpha: 1)
        imageButton.layer.cornerRadius = 15
        imageButton.tintColor = .white
        
        // Customize back button
        let backItem = UIBarButtonItem()
        backItem.title = "Kembali"
        navigationItem.backBarButtonItem = backItem
        
        readData()
        checkTodaysJournal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readData()
        print("keluar sini")
        if !journalList.isEmpty {

            print(journalList[0])
            // 1
            imageButton.removeTarget(self, action: #selector(createJournal(_:)), for: .touchUpInside)
        } else {
            //2
            imageButton.removeTarget(self, action: #selector(seeTodaysJournal(_:)), for: .touchUpInside)
        }
        checkTodaysJournal()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !Core.shared.isNewUser() {
            // show onboarding
            let controller = storyboard?.instantiateViewController(identifier: "onboarding") as! OnboardingViewController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true, completion: nil)
        }
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
    
    func checkTodaysJournal() {
        if journalList.isEmpty {
            print("masuk sini")
            bgImage.image = UIImage(named: "dashboard1")
            collectionView.isHidden = true
            emptyImage.isHidden = false
            imageLabel.text = "Duh.. Kamu belum buat catatan hari ini"
            imageButton.setTitle("Buat Jurnal", for: .normal)
            // set tujuan button
            imageButton.addTarget(self, action: #selector(createJournal(_:)), for: .touchUpInside)
            return
        } else {
            collectionView.isHidden = false
            emptyImage.isHidden = true
        }
        
        let currentDate = Date()
        let lastJournalDate = journalList[0].createDate ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        if dateFormatter.string(from: currentDate) == dateFormatter.string(from: lastJournalDate) {
            
            imageButton.setTitle("Lihat Catatan", for: .normal)
            // set tujuan button
            imageButton.addTarget(self, action: #selector(seeTodaysJournal(_:)), for: .touchUpInside)

            
            if isTodaysJournalComplete() {
                bgImage.image = UIImage(named: "dashboard3")
                imageLabel.text = "Yeay, catatan kamu terisi lengkap hari ini"
            } else {
                bgImage.image = UIImage(named: "dashboard2")
                imageLabel.text = "Kamu belum lengkapin catatan loh hari ini"
            }
        } else {
            bgImage.image = UIImage(named: "dashboard1")
            imageLabel.text = "Duh.. Kamu belum buat catatan hari ini"
            imageButton.setTitle("Buat Catatan", for: .normal)
            // set tujuan button
            imageButton.addTarget(self, action: #selector(createJournal(_:)), for: .touchUpInside)
        }
        
    }

    func isTodaysJournalComplete() -> Bool {
        if journalList[0].puzzle2Detail?.isEmpty ?? true {
            return false
        }
        if journalList[0].puzzle3Detail?.isEmpty ?? true {
            return false
        }
        if journalList[0].puzzle4Detail?.isEmpty ?? true {
            return false
        }
        
        return true
    }
    
    @objc func createJournal(_ sender: UIButton) {
        print("buat journal hari ini")
        performSegue(withIdentifier: "addJournal", sender: nil)
    }
    
    @objc func seeTodaysJournal(_ sender: UIButton) {
        print("journal hari ini")
        performSegue(withIdentifier: "journalList", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? JournalPuzzleViewController {
            vc.readingTitle = journalList[journalSelectionIndex].title ?? ""
            vc.dataId = journalList[journalSelectionIndex].id
            vc.puzzle1Detail = journalList[journalSelectionIndex].puzzle1Detail ?? ""
            vc.puzzle2Detail = journalList[journalSelectionIndex].puzzle2Detail ?? ""
            vc.puzzle3Detail = journalList[journalSelectionIndex].puzzle3Detail ?? ""
            vc.puzzle4Detail = journalList[journalSelectionIndex].puzzle4Detail ?? ""
        }
        if let vc = segue.destination as? AddNewJournalController {
            vc.itemSavedDelegate = self
        }
    }

}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if journalList.count == 0 {
            return 0
        }
        if journalList.count == 1 {
            return 1
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 2
        
        return CGSize(width: width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? JournalListCell else {
            return UICollectionViewCell()
        }
        
        // Configure the cell
//        if journalList.count < 2 {
//            return cell
//        }
        let journal = journalList[indexPath.row]
        cell.configureJournal(with: journal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(journalList[indexPath.row])
        journalSelectionIndex = indexPath.row
        performSegue(withIdentifier: "editRecentJournal", sender: nil)
    }
    
}

extension DashboardViewController: itemSavedDelegate {
    func itemSaved() {
        readData()
    }
}


class Core {
    static let shared = Core()
    
    func isNewUser()-> Bool {
        return UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
