import Foundation

// This class handles loading and decoding our JSON files.
class DataService {
    
    func loadHealthData() throws -> [DailyHealthRecord] {
        return try loadAndDecode("health_daily.json")
    }
    
    func loadScreenTimeData() throws -> [ScreenTimeRecord] {
        return try loadAndDecode("screentime.json")
    }
    
    private func loadAndDecode<T: Decodable>(_ filename: String) throws -> [T] {
        guard let fileUrl = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Could not find \(filename) in bundle.")
            throw DataError.fileNotFound
        }
        
        let data: Data
        do {
            data = try Data(contentsOf: fileUrl)
        } catch {
            print("Could not load \(filename) from bundle: \(error)")
            throw DataError.loadFailed(error)
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        do {
            return try decoder.decode([T].self, from: data)
        } catch {
            print("Error decoding \(filename): \(error)")
            throw DataError.decodeFailed(error)
        }
    }
    
    enum DataError: Error, LocalizedError {
        case fileNotFound
        case loadFailed(Error)
        case decodeFailed(Error)
        
        var errorDescription: String? {
            switch self {
            case .fileNotFound:
                return "A required data file was not found in the app bundle."
            case .loadFailed(let error):
                return "Failed to load data file: \(error.localizedDescription)"
            case .decodeFailed(let error):
                return "Failed to parse data file: \(error.localizedDescription)"
            }
        }
    }
}

