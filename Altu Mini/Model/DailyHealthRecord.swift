import Foundation

// This struct represents a single day's record from health_daily.json.
struct DailyHealthRecord: Codable, Identifiable {
    
    let id: UUID = UUID()
    
    let date: Date
    let steps: Int
    let sleepMinutes: Int
    let activeEnergyKcal: Double
    let workoutMinutes: Int

    enum CodingKeys: String, CodingKey {
        case date, steps
        case sleepMinutes = "sleep_minutes"
        case activeEnergyKcal = "active_energy_kcal"
        case workoutMinutes = "workout_minutes"
    }
}

