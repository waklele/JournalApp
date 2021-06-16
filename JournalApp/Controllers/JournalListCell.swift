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

}

extension UIColor {
    static var random: UIColor {
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
}
