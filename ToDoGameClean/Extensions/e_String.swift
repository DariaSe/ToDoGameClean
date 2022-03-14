//
//  e_String.swift
//  ToDoGameClean
//
//  Created by Дарья Селезнёва on 11.03.2022.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localizedForCount(_ count: Int) -> String {
        let formatString : String = NSLocalizedString(self, comment: "")
        let resultString : String = String.localizedStringWithFormat(formatString, count)
        return resultString
    }
    
    var localizedGame: String {
        return NSLocalizedString(self, tableName: "Game", comment: "")
    }
}
