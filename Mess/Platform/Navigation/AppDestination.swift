import Foundation

enum AppDestination: Hashable {
    case welcome
    case login
    case signup
    case accountDetails
    case documentUpload
    case onboardingSuccess
    case main
    case dashboard
    case transactions
    case payments
    case profile
    
    var id: String {
        switch self {
        case .welcome: return "welcome"
        case .login: return "login"
        case .signup: return "signup"
        case .accountDetails: return "accountDetails"
        case .documentUpload: return "documentUpload"
        case .onboardingSuccess: return "onboardingSuccess"
        case .main: return "main"
        case .dashboard: return "dashboard"
        case .transactions: return "transactions"
        case .payments: return "payments"
        case .profile: return "profile"
        }
    }
}
