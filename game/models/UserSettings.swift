//
//  UserSettings.swift
//  game
//
//  Created by Grisha Pospelov on 01.11.2021.
//

import Foundation
import RealmSwift

class UserSettings: Object {

    @Persisted var recordID: String

    @Persisted var clockMode: Bool
    @Persisted var hellMode: Bool
    @Persisted var userQuestionMode: Bool

    override static func primaryKey() -> String? {
        return "recordID"
    }
}
