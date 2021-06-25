//
//  JournalPuzzleViewController.swift
//  JournalApp
//
//  Created by Muhammad Rizki Miftha Alhamid on 6/17/21.
//

import UIKit

class JournalPuzzleViewController: UIViewController {
    @IBOutlet weak var puzzle: UIImageView!
    
    public var dataId: Int64 = 0
    public var readingTitle = String()
    public var puzzle1Detail = String()
    public var puzzle2Detail = String()
    public var puzzle3Detail = String()
    public var puzzle4Detail = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        puzzle.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.puzzle.addGestureRecognizer(tapGestureRecognizer)
        
        adjustPuzzle()
        
    }
    
    func adjustPuzzle() {
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
                    print("\(puzzle1Detail)")
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
                self.show(vc, sender: nil)
            } else {
                let vc = storyboard.instantiateViewController(identifier: "editConnections") as! MakingConnectionsViewController
                vc.puzzleType = 1
                self.show(vc, sender: nil)
            }
        } else if z1per > 50 && z2per > 50 {
            print("Kanan bawah")
            if !puzzle3Detail.isEmpty {
                let vc = storyboard.instantiateViewController(identifier: "viewConnections") as! ViewConnectionsViewController
                vc.puzzleType = 2
                vc.puzzle3Detail = puzzle3Detail
                self.show(vc, sender: nil)
            } else {
                let vc = storyboard.instantiateViewController(identifier: "editConnections") as! MakingConnectionsViewController
                vc.puzzleType = 2
                self.show(vc, sender: nil)
            }
        } else if z1per < 50 && z2per < 50 {
            print("Kiri atas")
            //storyboard sendiri aja
        } else {
            print("Kiri bawah")
            if !puzzle4Detail.isEmpty {
                let vc = storyboard.instantiateViewController(identifier: "viewConnections") as! ViewConnectionsViewController
                vc.puzzleType = 3
                vc.puzzle4Detail = puzzle4Detail
                self.show(vc, sender: nil)
            } else {
                let vc = storyboard.instantiateViewController(identifier: "editConnections") as! MakingConnectionsViewController
                vc.puzzleType = 3
                self.show(vc, sender: nil)
            }
        }
   }
    
    
    @IBAction func saveJournal(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
