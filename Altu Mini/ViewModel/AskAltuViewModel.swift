import Foundation

@MainActor
class AskAltuViewModel: ObservableObject {
    
    @Published var chatHistory: [ChatMessage] = []
    @Published var userQuery: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let geminiService: GeminiService
    
    private var healthDataJSON: String = "[]"
    private var screenTimeDataJSON: String = "[]"
    
    init(dashboardViewModel: DashboardViewModel, geminiService: GeminiService = GeminiService()) {
        self.geminiService = geminiService
        
        let encoder = JSONEncoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        encoder.dateEncodingStrategy = .formatted(formatter)
        encoder.outputFormatting = .prettyPrinted // Makes it easier for the LLM
        
        do {
            let healthData = try encoder.encode(dashboardViewModel.healthData)
            self.healthDataJSON = String(data: healthData, encoding: .utf8) ?? "[]"
            
            let screenTimeData = try encoder.encode(dashboardViewModel.screenTimeData)
            self.screenTimeDataJSON = String(data: screenTimeData, encoding: .utf8) ?? "[]"
            
        } catch {
            print("Failed to serialize data for Gemini: \(error)")
            self.errorMessage = "Failed to prepare your data for the AI."
        }
        
        // Initial Greeting Message
        self.chatHistory.append(ChatMessage(role: .model, text: "Hi! I have your 90-day health and screen time data loaded. Ask me anything about it!"))
    }
    
    
    /// The main system prompt that tells Gemini how to behave.
    private var systemPrompt: String {
        """
        You are "Altu", a friendly and helpful AI health assistant.
        You are answering questions for a user based on their personal health data,
        which is provided to you as two JSON arrays.

        IMPORTANT: Your answers MUST be based *only* on the data provided in these JSON arrays.
        - Do not make up data.
        - If the user asks for data outside the 90-day range, state that you only have 90 days of data.
        - Perform any necessary calculations (like averages, totals, correlations) yourself.
        - Keep your answers concise, encouraging, and easy to understand.
        
        --- USER'S HEALTH DATA (JSON) ---
        This array contains daily health metrics like steps, sleep, and workouts.
        
        ```json
        \(healthDataJSON)
        ```

        --- USER'S SCREEN TIME DATA (JSON) ---
        This array contains screen time entries, with multiple app entries per day.
        
        ```json
        \(screenTimeDataJSON)
        ```
        """
    }
    
    /// Called when the user taps the 'Send' button.
    func sendMessage() {
        let query = userQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty, !isLoading else { return }
        
        chatHistory.append(ChatMessage(role: .user, text: query))
        self.userQuery = ""
        
        self.isLoading = true
        self.errorMessage = nil
        
        // Start the async task to call Gemini
        Task {
            do {
                let responseText = try await geminiService.generateContent(
                    systemPrompt: systemPrompt,
                    userQuery: query
                )
                
                chatHistory.append(ChatMessage(role: .model, text: responseText))
                
            } catch {
                let errorDescription = (error as? LocalizedError)?.errorDescription ?? "An unknown error occurred."
                self.errorMessage = "Error: \(errorDescription)"
                
                chatHistory.append(ChatMessage(role: .model, text: "Sorry, I ran into an error. Please check the API key and try again.\n\n`\(errorDescription)`"))
            }
            
            self.isLoading = false
        }
    }
}
