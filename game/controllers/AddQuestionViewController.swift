//
//  AddQuestionViewController.swift
//  game
//
//  Created by Grisha Pospelov on 04.11.2021.
//

import UIKit

class AddQuestionViewController: UIViewController {
    @IBAction func addQuestionTextField(_ sender: Any) {
    }
    @IBAction func answer1TextField(_ sender: Any) {
    }
    @IBAction func answer2TextField(_ sender: Any) {
    }
    @IBAction func answer3TextField(_ sender: Any) {
    }
    
    @IBAction func answer4TextField(_ sender: Any) {
    }
    @IBAction func correctAnswerSegmentedControl(_ sender: Any) {
    }
    @IBAction func addQuestionButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lazy var textFields = [addQuestionTextField, answer1TextField, answer2TextField, answer3TextField, answer4TextField]
        let caretaker = UserQuestionCaretaker()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            navigationController?.isNavigationBarHidden = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
            
        }
        
        @IBAction func AddQuestionButtonTap(_ sender: Any) {
            
            let allFilled = textFields.map{ $0?.text?.isEmpty ?? true }.filter{ $0 == true }.isEmpty
            
            if allFilled {
                
                let question = UserQuestion()
                var difficulty = 1
                
                switch difficultySegmentedControl.selectedSegmentIndex {
                case 0: difficulty = 1
                case 1: difficulty = 10
                case 2: difficulty = 15
                default: difficulty = 1
                }
                
                question.text = addQuestionTextField.text!
                question.difficulty = difficulty
                
                question.answer1 = answer1TextField.text!
                question.answer2 = answer2TextField.text!
                question.answer3 = answer3TextField.text!
                question.answer4 = answer4TextField.text!

                question.correctIndex = correctAnswerSegmentedControl.selectedSegmentIndex
                
                caretaker.save(question: question)
                
          
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    }
