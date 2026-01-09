@testable import QuizAPI
import VaporTesting
import Testing
import Fluent

@Suite("App Tests with DB", .serialized)
struct QuizAPITests {
    private func withApp(_ test: (Application) async throws -> ()) async throws {
        let app = try await Application.make(.testing)
        do {
            try await configure(app)
            try await app.autoMigrate()
            try await test(app)
            try await app.autoRevert()
        } catch {
            try? await app.autoRevert()
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }
    
    @Test("Getting all the Quiz Questions")
    func getAllQuizQuestions() async throws {
        try await withApp { app in
            let sampleQuestions = [
                QuizQuestion(question: "What is the capital of France?", optionA: "Berlin", optionB: "Paris", optionC: "London", optionD: "Madrid", correctAnswer: "Paris"),
                QuizQuestion(question: "What is 2 + 2?", optionA: "3", optionB: "4", optionC: "5", optionD: "6", correctAnswer: "4")
            ]
            try await sampleQuestions.create(on: app.db)
            
            try await app.testing().test(.GET, "quiz/questions", afterResponse: { res async throws in
                #expect(res.status == .ok)
                let questions = try res.content.decode([QuizQuestion].self)
                #expect(questions.count == 2)
            })
        }
    }
    
    @Test("Creating a Quiz Question")
    func createQuizQuestion() async throws {
        let newQuestion = QuizQuestion(question: "What is the capital of Germany?", optionA: "Berlin", optionB: "Paris", optionC: "London", optionD: "Madrid", correctAnswer: "Berlin")
        
        try await withApp { app in
            try await app.testing().test(.POST, "quiz/add", beforeRequest: { req in
                try req.content.encode(newQuestion)
            }, afterResponse: { res async throws in
                #expect(res.status == .ok)
                let models = try await QuizQuestion.query(on: app.db).all()
                #expect(models.count == 1)
                #expect(models[0].question == "What is the capital of Germany?")
            })
        }
    }
}

extension QuizQuestion: Equatable {
    public static func == (lhs: QuizQuestion, rhs: QuizQuestion) -> Bool {
        lhs.id == rhs.id &&
        lhs.question == rhs.question &&
        lhs.optionA == rhs.optionA &&
        lhs.optionB == rhs.optionB &&
        lhs.optionC == rhs.optionC &&
        lhs.optionD == rhs.optionD &&
        lhs.correctAnswer == rhs.correctAnswer
    }
}