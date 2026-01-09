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

    app.get("quiz", "questions") { req async throws -> [QuizQuestion] in
        try await QuizQuestion.query(on: req.db).all()
    }
}
