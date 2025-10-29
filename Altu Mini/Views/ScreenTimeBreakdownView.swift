import SwiftUI

// Screentime breakdown per category and by app
struct ScreenTimeBreakdownView: View {
    
    let categories: [ScreenTimeCategory]
    
    private func formatMinutes(_ totalMinutes: Int) -> String {
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Screen Time Breakdown")
                .font(.title2.bold())
                .padding(.bottom, 8)
            
            VStack(spacing: 8) {
                ForEach(categories) { category in
                    DisclosureGroup {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(category.apps) { app in
                                HStack {
                                    Text(app.id)
                                        .font(.callout)
                                    Spacer()
                                    Text(formatMinutes(app.totalMinutes))
                                        .font(.callout)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.top, 8)
                        
                    } label: {
                        HStack {
                            Text(category.id)
                                .font(.headline)
                                .foregroundStyle(Color.primary)
                            Spacer()
                            Text(formatMinutes(category.totalMinutes))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .contentShape(Rectangle())
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                }
            }
        }
    }
}
