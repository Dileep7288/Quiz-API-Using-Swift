import Fluent
import Vapor

func routes(_ app: Application) throws {

    app.get { req async in
        "It works!"
    }

    app.post("quiz", "add") { req async throws -> QuizQuestion in
        let question = try req.content.decode(QuizQuestion.self)
        try await question.save(on: req.db)
        return question
    }

    app.get("quiz", "questions") { req async throws -> [QuizQuestionResponse] in
        let questions = try await QuizQuestion.query(on: req.db).all()

        return questions.map {
            QuizQuestionResponse(
                id: $0.id!,
                question: $0.question,
                optionA: $0.optionA,
                optionB: $0.optionB,
                optionC: $0.optionC,
                optionD: $0.optionD
            )
        }
    }
}
