import SwiftUI

struct AskAltuView: View {
    
    @StateObject private var askAltuViewModel: AskAltuViewModel
    
    init(dashboardViewModel: DashboardViewModel) {
        _askAltuViewModel = StateObject(
            wrappedValue: AskAltuViewModel(dashboardViewModel: dashboardViewModel)
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Chat History
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(askAltuViewModel.chatHistory) { message in
                                ChatMessageView(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: askAltuViewModel.chatHistory.count) {
                        if let lastMessageID = askAltuViewModel.chatHistory.last?.id {
                            proxy.scrollTo(lastMessageID, anchor: .bottom)
                        }
                    }
                }
                
                // Error Message
                if let errorMessage = askAltuViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                // Input Area
                HStack(spacing: 12) {
                    TextField("How does exercise relate to sleep?", text: $askAltuViewModel.userQuery, axis: .vertical)
                        .padding(12)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(16)
                        .lineLimit(1...5)
                    
                    if askAltuViewModel.isLoading {
                        ProgressView()
                            .frame(width: 44, height: 44)
                    } else {
                        Button(action: {
                            askAltuViewModel.sendMessage()
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.title)
                                .foregroundColor(askAltuViewModel.userQuery.isEmpty ? .gray : .blue)
                        }
                        .disabled(askAltuViewModel.userQuery.isEmpty)
                    }
                }
                .padding()
            }
            .navigationTitle("Ask Altu")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Chat Window
struct ChatMessageView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
            }
            
            Text(.init(message.text))
                .padding(12)
                .background(message.role == .user ? .blue : Color(.secondarySystemGroupedBackground))
                .foregroundColor(message.role == .user ? .white : .primary)
                .cornerRadius(16)
            
            if message.role == .model {
                Spacer()
            }
        }
    }
}
