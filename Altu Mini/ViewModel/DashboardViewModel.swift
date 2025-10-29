import Foundation

struct DailyScreenTimeSummary: Identifiable {
    let id = UUID()
    let date: Date
    let totalMinutes: Int
}

struct ScreenTimeApp: Identifiable {
    let id: String
    let totalMinutes: Int
}

struct ScreenTimeCategory: Identifiable {
    let id: String
    let totalMinutes: Int
    let apps: [ScreenTimeApp]
}


class DashboardViewModel: ObservableObject {
    
    @Published var healthData: [DailyHealthRecord] = []
    @Published var screenTimeData: [ScreenTimeRecord] = []
    
    @Published var dailyScreenTimeSummary: [DailyScreenTimeSummary] = []
    @Published var screenTimeCategories: [ScreenTimeCategory] = []

    @Published var averageSteps: Double = 0
    @Published var averageSleep: Double = 0
    @Published var averageActiveEnergy: Double = 0
    @Published var averageWorkoutMinutes: Double = 0
    @Published var averageScreenTime: Double = 0
    
    private let dataService: DataService
    
    init(dataService: DataService = DataService()) {
        self.dataService = dataService
        loadData()
    }
    
    func loadData() {
        do {
            self.healthData = try dataService.loadHealthData().sorted(by: { $0.date < $1.date })
            self.screenTimeData = try dataService.loadScreenTimeData()
            
            self.dailyScreenTimeSummary = processScreenTimeData()
            self.screenTimeCategories = processScreenTimeCategories()
            
            calculateAverages()
            
        } catch {
            print("Error loading data: \(error.localizedDescription)")
        }
    }
    
    private func processScreenTimeData() -> [DailyScreenTimeSummary] {
        let groupedByDate = Dictionary(grouping: screenTimeData) { (record) -> Date in
            return Calendar.current.startOfDay(for: record.date)
        }
        
        let summaries = groupedByDate.map { (date, records) -> DailyScreenTimeSummary in
            let totalMinutes = records.reduce(0) { $0 + $1.minutes }
            return DailyScreenTimeSummary(date: date, totalMinutes: totalMinutes)
        }.sorted(by: { $0.date < $1.date })
        
        return summaries
    }
    
    /// Screentime Categories for breakdown
    private func processScreenTimeCategories() -> [ScreenTimeCategory] {
        
        let groupedByCategory = Dictionary(grouping: screenTimeData, by: { $0.category })
        
        let categories: [ScreenTimeCategory] = groupedByCategory.map { (categoryName, records) in
            
            let categoryTotalMinutes = records.reduce(0) { $0 + $1.minutes }
            
            let groupedByApp = Dictionary(grouping: records, by: { $0.app })
            
            let apps: [ScreenTimeApp] = groupedByApp.map { (appName, appRecords) in
                let appTotalMinutes = appRecords.reduce(0) { $0 + $1.minutes }
                return ScreenTimeApp(id: appName, totalMinutes: appTotalMinutes)
            }
            
            let sortedApps = apps.sorted(by: { $0.totalMinutes > $1.totalMinutes })
            
            return ScreenTimeCategory(id: categoryName, totalMinutes: categoryTotalMinutes, apps: sortedApps)
        }
        
        let sortedCategories = categories.sorted(by: { $0.totalMinutes > $1.totalMinutes })
        
        return sortedCategories
    }
    
    // Calculates all averages
    func calculateAverages() {
        let healthCount = Double(healthData.count)
        guard healthCount > 0 else {
            DispatchQueue.main.async {
                self.averageSteps = 0
                self.averageSleep = 0
                self.averageActiveEnergy = 0
                self.averageWorkoutMinutes = 0
            }
            return
        }
        
        let totalSteps = healthData.reduce(0) { $0 + $1.steps }
        let totalSleep = healthData.reduce(0) { $0 + $1.sleepMinutes }
        let totalActiveEnergy = healthData.reduce(0) { $0 + $1.activeEnergyKcal }
        let totalWorkoutMinutes = healthData.reduce(0) { $0 + $1.workoutMinutes }
        
        DispatchQueue.main.async {
            self.averageSteps = Double(totalSteps) / healthCount
            self.averageSleep = (Double(totalSleep) / healthCount) / 60.0 // Convert to hours
            self.averageActiveEnergy = Double(totalActiveEnergy) / healthCount
            self.averageWorkoutMinutes = Double(totalWorkoutMinutes) / healthCount
        }
        
        
        let screenTimeDays = Double(dailyScreenTimeSummary.count)
        guard screenTimeDays > 0 else {
            DispatchQueue.main.async {
                self.averageScreenTime = 0
            }
            return
        }
        
        let totalScreenTimeMinutes = dailyScreenTimeSummary.reduce(0) { $0 + $1.totalMinutes }
        
        DispatchQueue.main.async {
            self.averageScreenTime = (Double(totalScreenTimeMinutes) / screenTimeDays) / 60.0 // Convert to hours
        }
    }
}

