import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title.bold())
                .foregroundStyle(color)
            Text(unit)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}


struct OverviewStatsGrid: View {
    let averageSteps: Double
    let averageSleep: Double
    let averageActiveEnergy: Double
    let averageWorkoutMinutes: Double
    let averageScreenTime: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("90-Day Averages")
                .font(.title2.bold())
            
            let avgSteps = String(format: "%.0f", averageSteps)
            let avgSleep = String(format: "%.1f", averageSleep)
            let avgEnergy = String(format: "%.0f", averageActiveEnergy)
            let avgWorkout = String(format: "%.0f", averageWorkoutMinutes)
            let avgScreenTime = String(format: "%.1f", averageScreenTime)
            
            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 16) {
                GridRow {
                    StatCard(title: "Avg. Steps", value: avgSteps, unit: "steps/day", color: .blue)
                    StatCard(title: "Avg. Sleep", value: avgSleep, unit: "hours/night", color: .purple)
                }
                
                GridRow {
                    StatCard(title: "Avg. Active Energy", value: avgEnergy, unit: "kcal/day", color: .orange)
                    StatCard(title: "Avg. Workouts", value: avgWorkout, unit: "min/day", color: .green)
                }
                
                GridRow {
                    StatCard(title: "Avg. Screen Time", value: avgScreenTime, unit: "hours/day", color: .gray)
                        .gridCellColumns(2)
                }
            }
        }
    }
}
