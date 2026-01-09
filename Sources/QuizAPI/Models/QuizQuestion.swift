//
//  QuizQuestion.swift
//  QuizAPI
//
//  Created by Dileep Kumar on 09/01/26.
//

import Vapor
import Fluent

final class QuizQuestion: Model, Content, @unchecked Sendable {

    static let schema = "quiz_questions"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "question")
    var question: String

    @Field(key: "optionA")
    var optionA: String

    @Field(key: "optionB")
    var optionB: String

    @Field(key: "optionC")
    var optionC: String

    @Field(key: "optionD")
    var optionD: String

    @Field(key: "correctAnswer")
    var correctAnswer: String

    init() {}

    init(
        question: String,
        optionA: String,
        optionB: String,
        optionC: String,
        optionD: String,
        correctAnswer: String
    ) {
        self.question = question
        self.optionA = optionA
        self.optionB = optionB
        self.optionC = optionC
        self.optionD = optionD
        self.correctAnswer = correctAnswer
    }
}
