import Foundation
import Combine

class NavigationModel: ObservableObject {
    @Published var navigationPath: [AppDestination] = []
    @Published var currentTab: MainTab = .dashboard
    
    func navigate(to destination: AppDestination) {
        navigationPath.append(destination)
    }
    
    func popToRoot() {
        navigationPath.removeAll()
    }
    
    func pop() {
        navigationPath.removeLast()
    }
    
    func selectTab(_ tab: MainTab) {
        currentTab = tab
    }
}

enum MainTab: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case transactions = "Transactions"
    case payments = "Payments"
    case profile = "Profile"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .dashboard: return "chart.bar"
        case .transactions: return "list.bullet"
        case .payments: return "creditcard"
        case .profile: return "person"
        }
    }
}
