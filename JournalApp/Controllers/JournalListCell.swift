//
//  JournalListCell.swift
//  JournalApp
//
//  Created by Muhammad Rizki Miftha Alhamid on 6/16/21.
//

import UIKit

class JournalListCell: UICollectionViewCell {
    @IBOutlet weak var titleJournal: UILabel!
    @IBOutlet weak var puzzleProgress: UILabel!
    @IBOutlet weak var background: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        background.layer.cornerRadius = 20
        background.backgroundColor = .random
        
        titleJournal.adjustsFontSizeToFitWidth = true
        titleJournal.minimumScaleFactor = 0.2
        titleJournal.numberOfLines = 1
        
        puzzleProgress.adjustsFontSizeToFitWidth = true
        puzzleProgress.minimumScaleFactor = 0.2
        puzzleProgress.numberOfLines = 1
    }
    
    public func configureJournal(with model: Journal) {
        titleJournal.text = model.title
        
        var journalProcessCounter = 0
        if !(model.puzzle1Detail?.isEmpty ?? true) {
            journalProcessCounter += 1
        }
        if !(model.puzzle2Detail?.isEmpty ?? true) {
            journalProcessCounter += 1
        }
        if !(model.puzzle3Detail?.isEmpty ?? true) {
            journalProcessCounter += 1
        }
        if !(model.puzzle4Detail?.isEmpty ?? true) {
            journalProcessCounter += 1
        }
        
        puzzleProgress.text = "\(journalProcessCounter) out of 4"
    }

}

extension UIColor {
    static var random: UIColor {
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
}
