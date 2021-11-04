//
//  UserQuestion.swift
//  game
//
//  Created by Grisha Pospelov on 01.11.2021.
//

import Foundation
import RealmSwift

class UserQuestion: Object {
    
    @Persisted var difficulty: Int
    @Persisted var text: String
    @Persisted var answer1: String
    @Persisted var answer2: String
    @Persisted var answer3: String
    @Persisted var answer4: String
    
    @Persisted var correctIndex: Int

}
