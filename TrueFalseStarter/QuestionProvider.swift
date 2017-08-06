//
//  QuestionProvider.swift
//  TrueFalseStarter
//
//  Created by Bryan Richardson on 8/5/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import GameKit
// I could have used struct I think, but wanted practice with classes. I can't decide if I need a sub class for 3 or 4 choices, by using an array for the choices, I think I'm OK with only the single class.

class QuizQuestion {
    
    let question: String
    let choices: [String?]
    let answer: Int
    var asked: Bool = false
    
    // initializer for 4 choice questions
    init(question: String, choice1: String, choice2: String, choice3: String, choice4: String?, answer: Int) {
        self.question = question
        self.choices = [choice1, choice2, choice3, choice4]
        self.answer = answer
    }
}

struct QuestionProvider {
    // creating an array of questions
    
    var questionBank = [QuizQuestion(question: "This was the only US President to serve more than two consecutive terms.", choice1: "George Washington", choice2: "Franklin D. Roosevelt", choice3: "Woodrow Wilson", choice4: "Andrew Jackson", answer: 2),
        QuizQuestion(question: "Which of the following countries has the most residents?", choice1: "Nigeria", choice2: "Russia", choice3: "Iran", choice4: "Vietnam", answer: 1),
        QuizQuestion(question: "In what year was the United Nations founded?", choice1: "1918", choice2: "1919", choice3: "1945", choice4: "1954", answer: 3),
        QuizQuestion(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?", choice1: "Paris", choice2: "Washington D.C.", choice3: "New York City", choice4: "Boston", answer: 3),
        QuizQuestion(question: "What nation produces the most oil?", choice1: "Iran", choice2: "Iraq", choice3: "Brazil", choice4: "Canada", answer: 4),
        QuizQuestion(question: "Which country has most recently won consecutive World Cups in Soccer?", choice1: "Italy", choice2: "Brazil", choice3: "Argentina", choice4: "Spain" , answer: 2),
        QuizQuestion(question: "Which of the following rivers is the longest?", choice1: "Yangtze", choice2: "Mississippi", choice3: "Congo", choice4: "Mekong", answer: 2),
        QuizQuestion(question: "Which of these cities is the oldest?", choice1: "Mexico City", choice2: "Cape Town", choice3: "San Juan", choice4: "Sydney", answer: 1),
        QuizQuestion(question: "Which country was the first to allow women to vote in national elections?", choice1: "Poland", choice2: "United States", choice3: "Sweden", choice4: "Senegal", answer: 1),
        QuizQuestion(question: "Which of these countries won the most medals in the 2012 Summer Games?", choice1: "France", choice2: "Germany", choice3: "Japan", choice4: "Great Britain", answer: 4),
        QuizQuestion(question: "3 choice test", choice1: "1", choice2: "2", choice3: "3", choice4: nil, answer: 2)
        ]
    
    func randomNewQuestion() -> QuizQuestion {
        // random number to decide what question to ask
        var randomIndex = GKRandomSource.sharedRandom().nextInt(upperBound: questionBank.count)
        // check to see if we asked this question yet. If so, get another number
        while questionBank[randomIndex].asked == true {
            randomIndex = GKRandomSource.sharedRandom().nextInt(upperBound: questionBank.count)
        }
        // indicate that this question will be asked now
        questionBank[randomIndex].asked = true
        return questionBank[questionBank.count - 1]
//        return questionBank[randomIndex]
    }
    func resetBank() {
        // mark all questions as unasked to start a new game
        for eachQuestion in questionBank {
            eachQuestion.asked = false
        }
    }
}







