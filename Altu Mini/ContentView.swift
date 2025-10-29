import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: DashboardViewModel
    
    var body: some View {
        TabView {
            // Health Dashboard
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "heart.text.square")
                }

            // Ask Altu
            AskAltuView(dashboardViewModel: viewModel)
                .tabItem {
                    Label("Ask Altu", systemImage: "sparkle")
                }
        }
    }
}
