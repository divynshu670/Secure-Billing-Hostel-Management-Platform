import Foundation
import FirebaseFirestore

class FirebaseOnboardingService {
    static let shared = FirebaseOnboardingService()
    private let db = Firestore.firestore()
    private let usersCollection = "users"
    
    func checkExistingUser(uid: String) async throws -> Bool {
        let doc = try await db.collection(usersCollection).document(uid).getDocument()
        return doc.exists
    }
    
    func uploadDocument(uid: String, documentType: DocumentType, fileUrl: String) async throws {
        let timestamp = Date()
        try await db.collection(usersCollection).document(uid).updateData([
            "documents.\(documentType.rawValue).fileUrl": fileUrl,
            "documents.\(documentType.rawValue).uploadedAt": timestamp
        ])
    }
    
    func saveOnboardingData(uid: String, data: OnboardingData) async throws {
        try await db.collection(usersCollection).document(uid).setData([
            "firstName": data.firstName,
            "lastName": data.lastName,
            "email": data.email,
            "hostelName": data.hostelName,
            "roomNumber": data.roomNumber,
            "onboardingCompleted": true,
            "onboardingCompletedAt": Date()
        ], merge: true)
    }
}
