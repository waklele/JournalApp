//
//  JournalListCell.swift
//  JournalApp
//
//  Created by Muhammad Rizki Miftha Alhamid on 6/16/21.
//

import UIKit

class JournalListCell: UICollectionViewCell {
    @IBOutlet weak var titleJournal: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var puzzleImage: UIImageView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        background.layer.cornerRadius = 40
        background.backgroundColor = .white
//        background.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
//        background.layer.borderWidth = 3
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowOffset = CGSize(width: 10.0, height: 5.0)
        background.layer.shadowRadius = 3
        background.layer.shadowOpacity = 0.5
        background.layer.masksToBounds = false;
        background.layer.shadowPath = UIBezierPath(roundedRect:background.bounds, cornerRadius:background.layer.cornerRadius).cgPath
        
        titleJournal.adjustsFontSizeToFitWidth = true
        titleJournal.minimumScaleFactor = 0.2
        titleJournal.numberOfLines = 1
    }
    
    public func configureJournal(with model: Journal) {
        titleJournal.text = model.title
        
        if !(model.puzzle2Detail?.isEmpty ?? true) {
            if !(model.puzzle3Detail?.isEmpty ?? true) {
                if !(model.puzzle4Detail?.isEmpty ?? true) {
                    // full
                    puzzleImage.image = UIImage(named: "Puzzle Full")
                } else {
                    // 1, 2, 3
                    puzzleImage.image = UIImage(named: "Puzzle Incomplete 2.1")
                }
            } else {
                if !(model.puzzle4Detail?.isEmpty ?? true) {
                    // 1, 2, 4
                    puzzleImage.image = UIImage(named: "Puzzle Incomplete 2.2")
                } else {
                    // 1, 2
                    puzzleImage.image = UIImage(named: "Puzzle Incomplete 1.1")
                }
            }
        } else {
            if !(model.puzzle3Detail?.isEmpty ?? true) {
                if !(model.puzzle4Detail?.isEmpty ?? true) {
                    // 1, 3, 4
                    puzzleImage.image = UIImage(named: "Puzzle Incomplete 2.3")
                } else {
                    // 1, 3
                    puzzleImage.image = UIImage(named: "Puzzle Incomplete 1.2")
                }
            } else {
                if !(model.puzzle4Detail?.isEmpty ?? true) {
                    // 1, 4
                    puzzleImage.image = UIImage(named: "Puzzle Incomplete 1.3")
                } else {
                    // 1
                    puzzleImage.image = UIImage(named: "Puzzle Incomplete")
                }
            }
        }
        
    }

}
