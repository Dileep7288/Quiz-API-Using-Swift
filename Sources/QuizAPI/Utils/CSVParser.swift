//
//  CSVParser.swift
//  QuizAPI
//
//  Created by Dileep Kumar on 09/01/26.
//

func parseCSVRow(_ row: String) -> [String] {
    var result: [String] = []
    var value = ""
    var insideQuotes = false

    for c in row {
        if c == "\"" {
            insideQuotes.toggle()
        } else if c == "," && !insideQuotes {
            result.append(value.trimmingCharacters(in: .whitespaces))
            value = ""
        } else {
            value.append(c)
        }
    }

    result.append(value.trimmingCharacters(in: .whitespaces))
    return result
}
