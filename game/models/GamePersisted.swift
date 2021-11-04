//
//  GamePersisted.swift
//  game
//
//  Created by Grisha Pospelov on 01.11.2021.
//

import Foundation
import RealmSwift

class GamePersisted: Object {

    @Persisted var recordID: String

    @Persisted var currentQuestionNo: Int

    @Persisted var isLifelineFiftyUsed: Bool
    @Persisted var isLifelinePhoneUsed: Bool
    @Persisted var isLifelineAskAudienceUsed: Bool

    override static func primaryKey() -> String? {
        return "recordID"
    }
}
