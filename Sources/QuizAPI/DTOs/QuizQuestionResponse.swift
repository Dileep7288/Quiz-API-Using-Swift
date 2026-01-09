import Vapor

struct QuizQuestionResponse: Content {
    let id: Int
    let question: String
    let optionA: String
    let optionB: String
    let optionC: String
    let optionD: String
}

