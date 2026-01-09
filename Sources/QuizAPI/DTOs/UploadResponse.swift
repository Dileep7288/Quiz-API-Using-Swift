//
//  UploadResponse.swift
//  QuizAPI
//
//  Created by Dileep Kumar on 09/01/26.
//

import Vapor

struct UploadResponse: Content {
    let message: String
    let inserted: Int
    let skipped: Int
}
