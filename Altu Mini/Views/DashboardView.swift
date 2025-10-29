import SwiftUI
import Charts

// This is just a simple assembler of other views.
struct DashboardView: View {
    @EnvironmentObject var viewModel: DashboardViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    OverviewStatsGrid(
                        averageSteps: viewModel.averageSteps,
                        averageSleep: viewModel.averageSleep,
                        averageActiveEnergy: viewModel.averageActiveEnergy,
                        averageWorkoutMinutes: viewModel.averageWorkoutMinutes,
                        averageScreenTime: viewModel.averageScreenTime
                    )
                    
                    
                    StepsChart(healthData: viewModel.healthData)
                    SleepChart(healthData: viewModel.healthData)
                    ActiveEnergyChart(healthData: viewModel.healthData)
                    WorkoutMinutesChart(healthData: viewModel.healthData)
                    ScreenTimeChart(dailyScreenTimeSummary: viewModel.dailyScreenTimeSummary)
                    
                    StepsWorkoutSleepScatterPlot(healthData: viewModel.healthData)
                    
                    ScreenTimeBreakdownView(categories: viewModel.screenTimeCategories)
                    
                }
                .padding()
            }
            .navigationTitle("Health Dashboard")
        }
    }
}

