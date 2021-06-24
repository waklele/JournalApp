//
//  OnboardingCollectionViewCell.swift
//  JournalApp
//
//  Created by Santo Michael Sihombing on 24/06/21.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: OnboardingCollectionViewCell.self)
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideLabel: UILabel!
    @IBOutlet weak var slideDescription: UILabel!
    
    func setup(_ slide: OnboardingSlide) {
        slideImageView.image = slide.image
        slideLabel.text = slide.label
        slideDescription.text = slide.description
    }
}
