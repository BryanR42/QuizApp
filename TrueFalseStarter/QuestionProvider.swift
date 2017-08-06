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
    init(question: String, choices: [String], answer: Int) {
        self.question = question
        self.choices = choices
        self.answer = answer
    }
}

struct QuestionProvider {
    // creating an array of questions
    
    var questionBank = [QuizQuestion(question: "This was the only US President to serve more than two consecutive terms.", choices: ["George Washington", "Franklin D. Roosevelt", "Woodrow Wilson", "Andrew Jackson"], answer: 2),
        QuizQuestion(question: "Which of the following countries has the most residents?", choices: ["Nigeria", "Russia", "Iran", "Vietnam"], answer: 1),
        QuizQuestion(question: "In what year was the United Nations founded?", choices: ["1918", "1919", "1945", "1954"], answer: 3),
        QuizQuestion(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?", choices: ["Paris", "Washington D.C.", "New York City", "Boston"], answer: 3),
        QuizQuestion(question: "What nation produces the most oil?", choices: ["Iran", "Iraq", "Brazil", "Canada"], answer: 4),
        QuizQuestion(question: "Which country has most recently won consecutive World Cups in Soccer?", choices: ["Italy", "Brazil", "Argentina", "Spain"], answer: 2),
        QuizQuestion(question: "Which of the following rivers is the longest?", choices: ["Yangtze", "Mississippi", "Congo", "Mekong"], answer: 2),
        QuizQuestion(question: "Which of these cities is the oldest?", choices: ["Mexico City", "Cape Town", "San Juan", "Sydney"], answer: 1),
        QuizQuestion(question: "Which country was the first to allow women to vote in national elections?", choices: ["Poland", "United States", "Sweden", "Senegal"], answer: 1),
        QuizQuestion(question: "Which of these countries won the most medals in the 2012 Summer Games?", choices: ["France", "Germany", "Japan", "Great Britain"], answer: 4),
        QuizQuestion(question: "Which platform is better?", choices: ["iOS", "Android"], answer: 1)
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
        
        return questionBank[randomIndex]
    }
    func resetBank() {
        // mark all questions as unasked to start a new game
        for eachQuestion in questionBank {
            eachQuestion.asked = false
        }
    }
}







