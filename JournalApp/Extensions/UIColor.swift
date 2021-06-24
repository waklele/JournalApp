//
//  UIButton.swift
//  JournalApp
//
//  Created by Santo Michael Sihombing on 24/06/21.
//

import UIKit

extension UIButton {
    func rounderButton(radius: Int) {
        layer.cornerRadius = CGFloat(radius)
        backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.2588235294, blue: 0.4823529412, alpha: 1)
    }
}
