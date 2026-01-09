//
//  QuizController.swift
//  QuizAPI
//
//  Created by Dileep Kumar on 09/01/26.
//

import Vapor
import Fluent

final class QuizController: RouteCollection, @unchecked Sendable {

    func boot(routes: any RoutesBuilder) throws {
        let quiz = routes.grouped("quiz")

        quiz.post("add", use: add)
        quiz.post("questions", use: getAll)
        quiz.post("upload", use: uploadCSV)
    }

    func add(req: Request) async throws -> QuizQuestion {
        let question = try req.content.decode(QuizQuestion.self)
        try await question.save(on: req.db)
        return question
    }

    func getAll(req: Request) async throws -> [QuizQuestionResponse] {
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

    func uploadCSV(req: Request) async throws -> UploadResponse {

        struct Upload: Content {
            let file: File
        }

        let upload = try req.content.decode(Upload.self)

        guard let csv = upload.file.data.getString(
            at: 0,
            length: upload.file.data.readableBytes
        ) else {
            throw Abort(.badRequest, reason: "Invalid CSV file")
        }

        let rows = csv.split(whereSeparator: \.isNewline)

        var inserted = 0
        var skipped = 0

        for row in rows.dropFirst() {
            let cols = parseCSVRow(String(row))

            if cols.count != 6 {
                skipped += 1
                continue
            }

            let question = QuizQuestion(
                question: cols[0],
                optionA: cols[1],
                optionB: cols[2],
                optionC: cols[3],
                optionD: cols[4],
                correctAnswer: cols[5]
            )

            try await question.save(on: req.db)
            inserted += 1
        }

        return UploadResponse(
            message: "CSV processed successfully",
            inserted: inserted,
            skipped: skipped
        )
    }
}
