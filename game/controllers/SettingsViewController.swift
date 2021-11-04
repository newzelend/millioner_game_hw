//
//  SettingsViewController.swift
//  game
//
//  Created by Grisha Pospelov on 04.11.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var NewmodelLabel: UILabel!
    @IBOutlet weak var NewmodelLabelswitch: UISwitch!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
        let questionProvider = QuestionProvider(strategy: UserQuestionsStrategy())
        if questionProvider.fetchRandom(for: 1) == nil {
            game.userQuestionMode = false
            switchUserQuestionMode.isEnabled = false
        } else {
            switchUserQuestionMode.isEnabled = true
        }
        if game.userQuestionMode {
            switchUserQuestionMode.isEnabled = true
            usermodeHintLabel.text = usermodeText
        } else {
            switchUserQuestionMode.isOn = false
            usermodeHintLabel.text = ""
        }
    }
    @IBAction func userQuestionSwitchChanged(_ sender: Any) {
        
        if switchUserQuestionMode.isOn {
            game.userQuestionMode = true
            usermodeHintLabel.text = usermodeText
        } else {
            game.userQuestionMode = false
            usermodeHintLabel.text = ""
        }
        
        userSettingsCaretaker.save()
    }
}

