import SwiftUI
import Charts

// This File creates the charts for each of the various metrics

struct StepsChart: View {
    let healthData: [DailyHealthRecord]
    
    @State private var selectedDate: Date?
    @State private var selectedRecord: DailyHealthRecord?
    
    private var mediumDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Daily Steps")
                .font(.title2.bold())
            Text("Last 90 days")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Chart(healthData) { record in
                BarMark(
                    x: .value("Date", record.date, unit: .day),
                    y: .value("Steps", record.steps)
                )
                .foregroundStyle(.blue.gradient)
                .opacity(selectedDate == nil ? 1.0 : (selectedRecord?.id == record.id ? 1.0 : 0.3))
            }
            .frame(height: 200)
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: 3600 * 24 * 30)
            .padding(.top, 8)
            .chartXSelection(value: $selectedDate)
            .onChange(of: selectedDate) {
                if let selectedDate {
                    selectedRecord = healthData.min(by: {
                        abs($0.date.distance(to: selectedDate)) < abs($1.date.distance(to: selectedDate))
                    })
                } else {
                    selectedRecord = nil
                }
            }
            .chartOverlay { proxy in
                makeChartOverlay(proxy: proxy)
            }
        }
    }
    
    @ViewBuilder
    private func makeChartOverlay(proxy: ChartProxy) -> some View {
        GeometryReader { geometry in
            if let selectedRecord, let plotAnchor = proxy.plotFrame {
                let plotFrame = geometry[plotAnchor]
                let xPosition = proxy.position(forX: selectedRecord.date) ?? 0

                if plotFrame.contains(CGPoint(x: xPosition, y: plotFrame.midY)) {
                    Rectangle()
                        .frame(width: 1, height: plotFrame.height)
                        .position(x: xPosition, y: plotFrame.midY)
                        .overlay(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(selectedRecord.date, formatter: mediumDateFormatter)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("\(selectedRecord.steps) steps")
                                    .font(.caption.bold())
                                    .foregroundColor(.blue)
                            }
                            .padding(8)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        }
                }
            }
        }
    }
}

struct SleepChart: View {
    let healthData: [DailyHealthRecord]
    
    @State private var selectedDate: Date?
    @State private var selectedRecord: DailyHealthRecord?
    
    private var mediumDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Daily Sleep")
                .font(.title2.bold())
            Text("Last 90 days")
                .font(.caption)
                .foregroundStyle(.secondary)

            Chart(healthData) { record in
                LineMark(
                    x: .value("Date", record.date, unit: .day),
                    y: .value("Hours", Double(record.sleepMinutes) / 60.0)
                )
                .foregroundStyle(.purple.gradient)
                .interpolationMethod(.catmullRom)
                .opacity(selectedDate == nil ? 1.0 : 0.3)
                
                PointMark(
                    x: .value("Date", record.date, unit: .day),
                    y: .value("Hours", Double(record.sleepMinutes) / 60.0)
                )
                .foregroundStyle(.purple)
                .symbolSize(selectedRecord?.id == record.id ? 100 : 30)
                .opacity(selectedDate == nil ? 1.0 : (selectedRecord?.id == record.id ? 1.0 : 0.3))
            }
            .frame(height: 200)
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: 3600 * 24 * 30)
            .padding(.top, 8)
            .chartXSelection(value: $selectedDate)
            .onChange(of: selectedDate) {
                if let selectedDate {
                    selectedRecord = healthData.min(by: {
                        abs($0.date.distance(to: selectedDate)) < abs($1.date.distance(to: selectedDate))
                    })
                } else {
                    selectedRecord = nil
                }
            }
            .chartOverlay { proxy in
                makeChartOverlay(proxy: proxy)
            }
        }
    }
    
    @ViewBuilder
    private func makeChartOverlay(proxy: ChartProxy) -> some View {
        GeometryReader { geometry in
            if let selectedRecord, let plotAnchor = proxy.plotFrame {
                let plotFrame = geometry[plotAnchor]
                let xPosition = proxy.position(forX: selectedRecord.date) ?? 0

                if plotFrame.contains(CGPoint(x: xPosition, y: plotFrame.midY)) {
                    Rectangle()
                        .frame(width: 1, height: plotFrame.height)
                        .position(x: xPosition, y: plotFrame.midY)
                        .overlay(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(selectedRecord.date, formatter: mediumDateFormatter)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(String(format: "%.1f hours", Double(selectedRecord.sleepMinutes) / 60.0))
                                    .font(.caption.bold())
                                    .foregroundColor(.purple)
                            }
                            .padding(8)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        }
                }
            }
        }
    }
}

struct ActiveEnergyChart: View {
    let healthData: [DailyHealthRecord]
    
    @State private var selectedDate: Date?
    @State private var selectedRecord: DailyHealthRecord?
    
    private var mediumDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Active Energy")
                .font(.title2.bold())
            Text("Last 90 days")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Chart(healthData) { record in
                BarMark(
                    x: .value("Date", record.date, unit: .day),
                    y: .value("Calories", record.activeEnergyKcal)
                )
                .foregroundStyle(.orange.gradient)
                .opacity(selectedDate == nil ? 1.0 : (selectedRecord?.id == record.id ? 1.0 : 0.3))
            }
            .frame(height: 200)
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: 3600 * 24 * 30)
            .padding(.top, 8)
            .chartXSelection(value: $selectedDate)
            .onChange(of: selectedDate) {
                if let selectedDate {
                    selectedRecord = healthData.min(by: {
                        abs($0.date.distance(to: selectedDate)) < abs($1.date.distance(to: selectedDate))
                    })
                } else {
                    selectedRecord = nil
                }
            }
            .chartOverlay { proxy in
                makeChartOverlay(proxy: proxy)
            }
        }
    }
    
    @ViewBuilder
    private func makeChartOverlay(proxy: ChartProxy) -> some View {
        GeometryReader { geometry in
            if let selectedRecord, let plotAnchor = proxy.plotFrame {
                let plotFrame = geometry[plotAnchor]
                let xPosition = proxy.position(forX: selectedRecord.date) ?? 0
                
                if plotFrame.contains(CGPoint(x: xPosition, y: plotFrame.midY)) {
                    Rectangle()
                        .frame(width: 1, height: plotFrame.height)
                        .position(x: xPosition, y: plotFrame.midY)
                        .overlay(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(selectedRecord.date, formatter: mediumDateFormatter)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("\(selectedRecord.activeEnergyKcal) kcal")
                                    .font(.caption.bold())
                                    .foregroundColor(.orange)
                            }
                            .padding(8)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        }
                }
            }
        }
    }
}
    
struct WorkoutMinutesChart: View {
    let healthData: [DailyHealthRecord]
    
    @State private var selectedDate: Date?
    @State private var selectedRecord: DailyHealthRecord?
    
    private var mediumDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Workout Minutes")
                .font(.title2.bold())
            Text("Last 90 days")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Chart(healthData) { record in
                LineMark(
                    x: .value("Date", record.date, unit: .day),
                    y: .value("Minutes", record.workoutMinutes)
                )
                .foregroundStyle(.green.gradient)
                .interpolationMethod(.catmullRom)
                .opacity(selectedDate == nil ? 1.0 : 0.3)
                
                PointMark(
                    x: .value("Date", record.date, unit: .day),
                    y: .value("Minutes", record.workoutMinutes)
                )
                .foregroundStyle(.green)
                .symbolSize(selectedRecord?.id == record.id ? 100 : 30)
                .opacity(selectedDate == nil ? 1.0 : (selectedRecord?.id == record.id ? 1.0 : 0.3))
            }
            .frame(height: 200)
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: 3600 * 24 * 30)
            .padding(.top, 8)
            .chartXSelection(value: $selectedDate)
            .onChange(of: selectedDate) {
                if let selectedDate {
                    selectedRecord = healthData.min(by: {
                        abs($0.date.distance(to: selectedDate)) < abs($1.date.distance(to: selectedDate))
                    })
                } else {
                    selectedRecord = nil
                }
            }
            .chartOverlay { proxy in
                makeChartOverlay(proxy: proxy)
            }
        }
    }
    
    @ViewBuilder
    private func makeChartOverlay(proxy: ChartProxy) -> some View {
        GeometryReader { geometry in
            if let selectedRecord, let plotAnchor = proxy.plotFrame {
                let plotFrame = geometry[plotAnchor]
                let xPosition = proxy.position(forX: selectedRecord.date) ?? 0

                if plotFrame.contains(CGPoint(x: xPosition, y: plotFrame.midY)) {
                    Rectangle()
                        .frame(width: 1, height: plotFrame.height)
                        .position(x: xPosition, y: plotFrame.midY)
                        .overlay(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(selectedRecord.date, formatter: mediumDateFormatter)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("\(selectedRecord.workoutMinutes) min")
                                    .font(.caption.bold())
                                    .foregroundColor(.green)
                            }
                            .padding(8)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        }
                }
            }
        }
    }
}
    
struct ScreenTimeChart: View {
    let dailyScreenTimeSummary: [DailyScreenTimeSummary]
    
    @State private var selectedDate: Date?
    @State private var selectedSummary: DailyScreenTimeSummary?
    
    private var mediumDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Total Screen Time")
                .font(.title2.bold())
            Text("Last 90 days")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Chart(dailyScreenTimeSummary) { summary in
                LineMark(
                    x: .value("Date", summary.date, unit: .day),
                    y: .value("Hours", Double(summary.totalMinutes) / 60.0)
                )
                .foregroundStyle(.gray.gradient)
                .interpolationMethod(.catmullRom)
                .opacity(selectedDate == nil ? 1.0 : 0.3)
                
                PointMark(
                    x: .value("Date", summary.date, unit: .day),
                    y: .value("Hours", Double(summary.totalMinutes) / 60.0)
                )
                .foregroundStyle(.gray)
                .symbolSize(selectedSummary?.id == summary.id ? 100 : 30)
                .opacity(selectedDate == nil ? 1.0 : (selectedSummary?.id == summary.id ? 1.0 : 0.3))
            }
            .frame(height: 200)
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: 3600 * 24 * 30)
            .padding(.top, 8)
            .chartXSelection(value: $selectedDate)
            .onChange(of: selectedDate) {
                if let selectedDate {
                    selectedSummary = dailyScreenTimeSummary.min(by: {
                        abs($0.date.distance(to: selectedDate)) < abs($1.date.distance(to: selectedDate))
                    })
                } else {
                    selectedSummary = nil
                }
            }
            .chartOverlay { proxy in
                makeChartOverlay(proxy: proxy)
            }
        }
    }
    
    @ViewBuilder
    private func makeChartOverlay(proxy: ChartProxy) -> some View {
        GeometryReader { geometry in
            if let selectedSummary, let plotAnchor = proxy.plotFrame {
                let plotFrame = geometry[plotAnchor]
                let xPosition = proxy.position(forX: selectedSummary.date) ?? 0

                if plotFrame.contains(CGPoint(x: xPosition, y: plotFrame.midY)) {
                    Rectangle()
                        .frame(width: 1, height: plotFrame.height)
                        .position(x: xPosition, y: plotFrame.midY)
                        .overlay(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(selectedSummary.date, formatter: mediumDateFormatter)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(String(format: "%.1f hours", Double(selectedSummary.totalMinutes) / 60.0))
                                    .font(.caption.bold())
                                    .foregroundColor(.gray)
                            }
                            .padding(8)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(8)
                            .shadow(radius: 2)
                        }
                }
            }
        }
    }
}


struct StepsWorkoutSleepScatterPlot: View {
    let healthData: [DailyHealthRecord]
    
    private func sleepCategory(for minutes: Int) -> String {
        let hours = Double(minutes) / 60.0
        if hours < 6 {
            return "< 7 hours"
        } else if hours <= 8 {
            return "6-8 hours"
        } else {
            return "> 8 hours"
        }
    }
    
    private var sleepDomain: ClosedRange<Double> {
        let sleepMinutes = healthData.map { Double($0.sleepMinutes) }
        let minSleep = sleepMinutes.min() ?? 360.0
        let maxSleep = sleepMinutes.max() ?? 540.0
        return minSleep...maxSleep
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Steps, Workouts & Sleep")
                .font(.title2.bold())
            Text("90-Day Correlation")
                .font(.caption)
                .foregroundStyle(.secondary)

            scatterPlot
        }
    }
    
    private var scatterPlot: some View {
        Chart(healthData) { record in
            PointMark(
                x: .value("Steps", record.steps),
                y: .value("Workout Minutes", record.workoutMinutes)
            )
            .foregroundStyle(by: .value("Sleep", sleepCategory(for: record.sleepMinutes)))
        }
        .frame(height: 300)
        .padding(.top, 8)
        .chartXAxisLabel("Daily Steps")
        .chartYAxisLabel("Workout Minutes")
        .chartForegroundStyleScale(
                domain: ["< 6 hours", "6-8 hours", "> 8 hours"],
                range: [.blue, .cyan, .purple]
            )
        .chartLegend(position: .bottom, alignment: .center)
    }
}

