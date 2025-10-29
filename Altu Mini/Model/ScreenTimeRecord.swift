import Foundation

// This struct represents a single screen time entry from screentime.json.
struct ScreenTimeRecord: Codable, Identifiable {
    let id = UUID()
    
    let date: Date
    let app: String
    let minutes: Int
    let category: String
}
