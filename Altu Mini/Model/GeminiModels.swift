import Foundation

struct GeminiRequest: Codable {
    let systemInstruction: GeminiSystemInstruction
    let contents: [GeminiContent]
}

struct GeminiSystemInstruction: Codable {
    let parts: [GeminiPart]
}

struct GeminiContent: Codable {
    let parts: [GeminiPart]
}

struct GeminiPart: Codable {
    let text: String
}



struct GeminiResponse: Codable {
    let candidates: [GeminiCandidate]
}

struct GeminiCandidate: Codable {
    let content: GeminiContent
}


struct GeminiErrorResponse: Codable {
    let error: GeminiErrorDetail
}

struct GeminiErrorDetail: Codable {
    let code: Int
    let message: String
    let status: String
}

