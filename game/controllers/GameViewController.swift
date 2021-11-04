//
//  GameViewController.swift
//  game
//
//  Created by Grisha Pospelov on 01.11.2021.
//

import UIKit

protocol GameViewControllerDelegate: AnyObject {
    func didEndGame(withResult result: GameSession)
}

class Observer {}

class GameViewController: UIViewController {
    
   
    
    var abortedGame: GamePersisted?
    

    
    weak var gameDelegate: GameViewControllerDelegate?
    
    @IBOutlet weak var answerButtonA: UIButton!
    @IBOutlet weak var answerButtonB: UIButton!
    @IBOutlet weak var answerButtonC: UIButton!
    @IBOutlet weak var answerButtonD: UIButton!
  
    
    @IBOutlet weak var currentQuestionLabel: UITextField!
    @IBOutlet weak var currentQuestionNoLabel: UITextField!

    lazy var answerButtons = [answerButtonA, answerButtonB, answerButtonC, answerButtonD]
    
    let game = Game.shared
    let gameSession = GameSession()
    let questionProvider = QuestionProvider(strategy: Game.shared.hellMode ? HellmodeStrategy() : NormalStrategy())
    let gameSessionCaretaker = GameSessionCaretaker()
    let observer = Observer()
    

    
    lazy var difficultyIndex: Observable<Int> = Observable(gameSession.currentQuestionNo)
    
    // MARK: - Actions.
    
    @objc func answerButtonAction(_ sender: UIButton!) {
        
    
        
        let answerIndex = sender.tag
        
        disableButtons(answerIndex)
        answerButtons[answerIndex]?.backgroundColor = .answered
        
        delay { [self] in
            
            if isCorrect(answerIndex) {
                // ОТВЕТ ВЕРНЫЙ. ИДЕМ ДАЛЬШЕ.
                answerButtons[answerIndex]?.backgroundColor = .correct
                delay {
                    if difficultyIndex.value < game.questionsTotal {
                        nextQuestion()
                    } else {
                        // ИГРА ОКОНЧЕНА. ИГРОК ВЫИГРАЛ МАКСИМАЛЬНУЮ СУММУ.
                        win(answerIndex)
                    }
                }
            } else {
                // ОТВЕТ НЕВЕРНЫЙ. ЗАВЕРШАЕМ ИГРУ.
                gameOver(answerIndex)
            }
        }
    }
    // MARK: - Game lifecycle methods.
    
    func nextQuestion() {
        
        gameSession.currentQuestionNo += 1
        difficultyIndex.value = gameSession.currentQuestionNo
        
        displayQuestion()
        gameSessionCaretaker.save(gameSession)
    }
    
    func gameOver(_ answerIndex: Int) {
        
        answerButtons[answerIndex]?.backgroundColor = .incorrect
        answerButtons[gameSession.currentQuestion!.correctIndex]?.backgroundColor = .correct
        answerButtons[gameSession.currentQuestion!.correctIndex]?.alpha = 1.0
        
        gameSession.gameStatus = .lost
        
        delay { [self] in
            displayAlert(withAlertTitle: gameOverTitle, andMessage: gameOverMessage) { _ in
                self.endGame(self.gameSession)
            }
        }
    }
    
    func gameOverOnTimeout() {
        
        answerButtons[gameSession.currentQuestion!.correctIndex]?.backgroundColor = .correct
        answerButtons[gameSession.currentQuestion!.correctIndex]?.alpha = 1.0
        
        gameSession.gameStatus = .lostOnTimeout
        
        delay { [self] in
            displayAlert(withAlertTitle: gameOverOnTimeoutTitle, andMessage: gameOverOnTimeoutMessage) { _ in
                self.endGame(self.gameSession)
            }
        }
    }
    
    func win(_ answerIndex: Int) {
        
        answerButtons[answerIndex]?.backgroundColor = .correct
        answerButtons[gameSession.currentQuestion!.correctIndex]?.alpha = 1.0
        
        gameSession.gameStatus = .won
        
        delay { [self] in
            displayAlert(withAlertTitle: winTitle, andMessage: winMessage) { _ in
                self.endGame(self.gameSession)
            }
        }
    }
    // MARK: - Observed.
    
    private func subscribe() {
        
        difficultyIndex.addObserver(observer, options: [.initial, .new, .old]) { dI, change in
            self.currentQuestionNoLabel.text = "Вопрос № \(dI) / \(self.game.questionsTotal), \((dI - 1) * 100 / self.game.questionsTotal)% правильных ответов.".uppercased()
        }
    }
    
    // MARK: - View controller methods.
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        if game.hellMode { hellmodeLabel.isHidden = false } else { hellmodeLabel.isHidden = true }
        
        currentQuestionValueLabel.font = UIFont.monospacedSystemFont(ofSize: 24.0, weight: UIFont.Weight.bold)
        timerLabel.font = UIFont.monospacedSystemFont(ofSize: 24.0, weight: UIFont.Weight.bold)
        
        subscribe()
        
        abortedGame != nil ? restoreGameSession() : resetGameSession()
        addButtonActions()
        displayQuestion()
    }
}
