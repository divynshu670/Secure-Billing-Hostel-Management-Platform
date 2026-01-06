import Foundation

struct OnboardingState {
    // Account Details
    var firstName: String = ""
    var lastName: String = ""
    var hostelName: String = ""
    var roomNumber: String = ""
    
    // Document Upload
    var selectedDocumentType: DocumentType?
    var uploadedDocuments: [DocumentType: String] = [:]
    
    // UI State
    var currentStep: OnboardingStep = .accountDetails
    var isLoading: Bool = false
    var errorMessage: String?
    var successMessage: String?
}

enum OnboardingStep: Int, CaseIterable {
    case accountDetails = 0
    case documentUpload = 1
    case success = 2
    
    var title: String {
        switch self {
        case .accountDetails: return "Account Details"
        case .documentUpload: return "Upload Documents"
        case .success: return "Success"
        }
    }
    
    var progress: Double {
        Double(rawValue + 1) / Double(OnboardingStep.allCases.count)
    }
}
