//
//  Array.swift
//  JournalApp
//
//  Created by Santo Michael Sihombing on 27/06/21.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
