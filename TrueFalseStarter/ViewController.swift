//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox



class ViewController: UIViewController {
    
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    
    var gameSound: SystemSoundID = 0
    let gameQuestions = QuestionProvider()
    let colorProvider = ColorProvider()
    var currentQuestion = QuizQuestion(question: "Question", choices: ["1", "2"], answer: 0)
    
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var responseField: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupButtons() {
        let choiceButtonArray = [answer1Button, answer2Button, answer3Button, answer4Button]
        let answerCount = currentQuestion.choices.count
        for i in 0...3 {
            if i < answerCount {
                choiceButtonArray[i]?.isHidden = false
                choiceButtonArray[i]?.backgroundColor = colorProvider.getUIColor(for: "Teal")
                choiceButtonArray[i]?.setTitle(currentQuestion.choices[i], for: .normal)
            } else {
                choiceButtonArray[i]?.isHidden = true
            }
        }
    }
        
    
    func displayQuestion() {
        currentQuestion = gameQuestions.randomNewQuestion()
        responseField.isHidden = true
        questionField.text = currentQuestion.question
        setupButtons()

        playAgainButton.isHidden = true
    }
    
    func displayScore() {
        // Hide the answer buttons
        answer1Button.isHidden = true
        answer2Button.isHidden = true
        answer3Button.isHidden = true
        answer4Button.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        if responseField.isHidden == true {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let correctAnswer = currentQuestion.answer
        
        var currentAnswer: Int?
        switch sender {
        case answer1Button:
                currentAnswer = 1
        case answer2Button:
                currentAnswer = 2
        case answer3Button:
                currentAnswer = 3
        case answer4Button:
                currentAnswer = 4
        default:
            currentAnswer = 0
        }
        
        if currentAnswer == correctAnswer {
            correctQuestions += 1
            sender.backgroundColor = colorProvider.getUIColor(for: "Green")
            responseField.textColor = colorProvider.getUIColor(for: "Green")
            responseField.text = "Correct!"
        } else {
            switch correctAnswer {
            case 1: answer1Button.backgroundColor = colorProvider.getUIColor(for: "Green")
            case 2: answer2Button.backgroundColor = colorProvider.getUIColor(for: "Green")
            case 3: answer3Button.backgroundColor = colorProvider.getUIColor(for: "Green")
            case 4: answer4Button.backgroundColor = colorProvider.getUIColor(for: "Green")
            default: print("Error")
            }
            sender.backgroundColor = colorProvider.getUIColor(for: "Orange")
            responseField.textColor = colorProvider.getUIColor(for: "Orange")
            responseField.text = "Sorry, wrong answer!"
        }
        responseField.isHidden = false
        loadNextRoundWithDelay(seconds: 2)
        }
    }
    
    func nextRound() {
        if questionsAsked >= questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        gameQuestions.resetBank()
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}

