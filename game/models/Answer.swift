//
//  Answer.swift
//  game
//
//  Created by Grisha Pospelov on 01.11.2021.
//

import Foundation
import RealmSwift

class Answer: Object {
    
    @Persisted var text: String
    @Persisted var correct: Bool
}

class Question: Object {
    
    @Persisted var difficulty: Int
    @Persisted var text: String
    @Persisted var answers: List<Answer>
}
