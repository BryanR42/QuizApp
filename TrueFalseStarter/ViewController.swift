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
    let gameQuestions = QuestionProvider()
    let colorProvider = ColorProvider()
    let soundProvider = SoundProvider()
    var timer = Timer()
    var countdownClock: Int = 0
    var gameSounds: [SystemSoundID] = []
    
// is there a better way to initialize this var in the global scope? got an error if I only type initialize it.
    var currentQuestion = QuizQuestion(question: "Question", choices: ["1", "2"], answer: 0)
    
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var responseField: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameSounds = soundProvider.loadSounds()
        // Start game
        playSound(named: "Start")
        displayQuestion()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupButtons() {
        // put buttons in an array so I can loop through them
        let choiceButtonArray = [answer1Button, answer2Button, answer3Button, answer4Button]
        
        let answerCount = currentQuestion.choices.count
        for i in 0..<choiceButtonArray.count {
            if i < answerCount {
                choiceButtonArray[i]?.isHidden = false
                choiceButtonArray[i]?.backgroundColor = colorProvider.getUIColor(for: "Teal")
                choiceButtonArray[i]?.setTitle(currentQuestion.choices[i], for: .normal)
            } else {
                // hide the button if there is no choice for it to display. The UIStackView will adjust to compensate for missing buttons
                choiceButtonArray[i]?.isHidden = true
            }
        }
    }
        
    
    func displayQuestion() {
    // get a new question
        currentQuestion = gameQuestions.randomNewQuestion()
        responseField.isHidden = true
        questionField.text = currentQuestion.question
        setupButtons()
    // start the clock
        countdownClock = 15
        timerLabel.isHidden = false
        timerLabel.text = String(countdownClock) + " Sec"
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        playAgainButton.isHidden = true
    }
    
    func displayScore() {
        // Hide the extraneous buttons and labels
        responseField.isHidden = true
        scoreLabel.isHidden = true
        timerLabel.isHidden = true
        answer1Button.isHidden = true
        answer2Button.isHidden = true
        answer3Button.isHidden = true
        answer4Button.isHidden = true
        
    // Display play again button
        playAgainButton.isHidden = false
    // play a game over sound and show the results based on percentage of correct answers
        var resultText: String
        if correctQuestions > questionsAsked / 2 {
            playSound(named: "Winner")
            resultText = "Way to go!"
        } else {
        playSound(named: "Loser")
            resultText = "Bummer!"
        }
        questionField.text = "\(resultText)\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        
    // ignore taps in between questions while the response is displayed
        if responseField.isHidden == true {
    // Increment the questions asked counter
        questionsAsked += 1
    // stop the countdown timer when an answer is chosen
        timer.invalidate()
        
        let correctAnswer = currentQuestion.answer
    // assign an Int based on the button tapped so we can compare it to the correct answer
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
    // check if they are right, and change colors, sounds and response appropriately
        if currentAnswer == correctAnswer {
            correctQuestions += 1
            sender.backgroundColor = colorProvider.getUIColor(for: "Green")
            responseField.textColor = colorProvider.getUIColor(for: "Green")
            responseField.text = "Correct!"
            playSound(named: "Correct")
        } else {
            // mark the correct answer by turning the right button green, and the chosen button orange, then hit them with the Buzzer!!!
            switch correctAnswer {
            case 1: answer1Button.backgroundColor = colorProvider.getUIColor(for: "Green")
            case 2: answer2Button.backgroundColor = colorProvider.getUIColor(for: "Green")
            case 3: answer3Button.backgroundColor = colorProvider.getUIColor(for: "Green")
            case 4: answer4Button.backgroundColor = colorProvider.getUIColor(for: "Green")
            default: print("No correct Answer") // Debug check
            }
            responseField.textColor = colorProvider.getUIColor(for: "Orange")
            playSound(named: "Wrong")
            if currentAnswer != 0 {
            sender.backgroundColor = colorProvider.getUIColor(for: "Orange")
            responseField.text = "Sorry, wrong answer!"
            } else {
                responseField.text = "Time is up!"
            }
            
        }
            // make the response visible and update the onscreen score
        responseField.isHidden = false
        scoreLabel.text = "\(correctQuestions) of \(questionsAsked) correct"
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
        // reset the asked property in the question bank
        gameQuestions.resetBank()
        questionsAsked = 0
        correctQuestions = 0
        scoreLabel.isHidden = false
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func updateTimer() {
        countdownClock -= 1
        timerLabel.text = String(countdownClock) + " Sec"
        if countdownClock == 0 {
            checkAnswer(playAgainButton)
        }
    }
    
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
    
    // I tried to put this into the SoundProvider struct but I couldn't get it to work. If I declare the instance as var it still tells me the array is immutable. I think it's a scope issue and I hope I'll figure it out later.
    
    func playSound(named sound: String) {
        switch sound {
        case "Start": AudioServicesPlaySystemSound(gameSounds[0])
        case "Correct": AudioServicesPlaySystemSound(gameSounds[1])
        case "Wrong": AudioServicesPlaySystemSound(gameSounds[2])
        case "Winner": AudioServicesPlaySystemSound(gameSounds[3])
        case "Loser": AudioServicesPlaySystemSound(gameSounds[4])
        default: print("No sound") // Debug helper
            
        }
    }
}

