//
//  CreateQuizQuestion.swift
//  QuizAPI
//
//  Created by Dileep Kumar on 09/01/26.
//

import Fluent

struct CreateQuizQuestion: Migration {

    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("quiz_questions")
            .id()
            .field("question", .string, .required)
            .field("optionA", .string, .required)
            .field("optionB", .string, .required)
            .field("optionC", .string, .required)
            .field("optionD", .string, .required)
            .field("correctAnswer", .string, .required)
            .create()
    }

    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema("quiz_questions").delete()
    }
}
