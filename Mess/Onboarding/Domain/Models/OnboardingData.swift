import Foundation

struct OnboardingData: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let hostelName: String
    let roomNumber: String
    let documents: [Document]
    
    struct Document: Codable {
        let type: DocumentType
        let fileUrl: String
        let uploadedAt: Date
    }
}

enum DocumentType: String, Codable, CaseIterable {
    case idProof = "ID Proof"
    case hostelLetter = "Hostel Letter"
    case profilePhoto = "Profile Photo"
    
    var displayName: String { rawValue }
}
