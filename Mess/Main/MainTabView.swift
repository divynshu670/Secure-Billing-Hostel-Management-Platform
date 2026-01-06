import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var sessionStore: DefaultSessionStore
    @State private var selectedTab: MainTab = .dashboard
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                DashboardView(sessionStore: sessionStore)
                    .tabItem {
                        Label(MainTab.dashboard.rawValue, systemImage: MainTab.dashboard.icon)
                    }
                    .tag(MainTab.dashboard)
                
                TransactionsView(sessionStore: sessionStore)
                    .tabItem {
                        Label(MainTab.transactions.rawValue, systemImage: MainTab.transactions.icon)
                    }
                    .tag(MainTab.transactions)
                
                PaymentsView(sessionStore: sessionStore)
                    .tabItem {
                        Label(MainTab.payments.rawValue, systemImage: MainTab.payments.icon)
                    }
                    .tag(MainTab.payments)
                
                ProfileView(sessionStore: sessionStore)
                    .tabItem {
                        Label(MainTab.profile.rawValue, systemImage: MainTab.profile.icon)
                    }
                    .tag(MainTab.profile)
            }
            .accentColor(.appPrimary)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(DefaultSessionStore())
}
