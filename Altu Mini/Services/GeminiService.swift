import Foundation

enum GeminiError: Error, LocalizedError {
    case invalidURL
    case invalidAPIKey
    case networkRequestFailed(Error)
    case invalidResponse
    case noData
    case decodingError(Error)
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The API endpoint URL is invalid."
        case .invalidAPIKey: return "The Gemini API key is missing or invalid."
        case .networkRequestFailed(let error): return "Network request failed: \(error.localizedDescription)"
        case .invalidResponse: return "Received an invalid response from the server."
        case .noData: return "No data was returned from the server."
        case .decodingError(let error): return "Failed to decode the server's response: \(error.localizedDescription)"
        case .serverError(let message): return "Server error: \(message)"
        }
    }
}

class GeminiService {
    private let apiKey = "YOUR API KEY" // <-- PASTE YOUR KEY HERE
    
    private let apiURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent"
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func generateContent(systemPrompt: String, userQuery: String) async throws -> String {
        
        guard let url = URL(string: "\(apiURL)?key=\(apiKey)") else {
            throw GeminiError.invalidURL
        }
        
        let requestBody = GeminiRequest(
            systemInstruction: .init(parts: [.init(text: systemPrompt)]),
            contents: [.init(parts: [.init(text: userQuery)])]
        )
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            throw GeminiError.decodingError(error)
        }
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw GeminiError.networkRequestFailed(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            if let errorResponse = try? JSONDecoder().decode(GeminiErrorResponse.self, from: data) {
                throw GeminiError.serverError(errorResponse.error.message)
            }
            throw GeminiError.invalidResponse
        }
        
        do {
            let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
            
            if let text = geminiResponse.candidates.first?.content.parts.first?.text {
                return text
            } else {
                throw GeminiError.noData
            }
        } catch {
            print("Failed to decode response. Raw data: \(String(data: data, encoding: .utf8) ?? "No decodable string")")
            throw GeminiError.decodingError(error)
        }
    }
}

