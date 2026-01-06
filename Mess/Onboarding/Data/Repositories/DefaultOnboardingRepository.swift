import Foundation

class DefaultOnboardingRepository: OnboardingRepository {
    private let firebaseService: FirebaseOnboardingService
    
    init(firebaseService: FirebaseOnboardingService = .shared) {
        self.firebaseService = firebaseService
    }
    
    func checkExistingUser(uid: String) async throws -> Bool {
        try await firebaseService.checkExistingUser(uid: uid)
    }
    
    func uploadDocument(uid: String, documentType: DocumentType, fileUrl: String) async throws {
        try await firebaseService.uploadDocument(uid: uid, documentType: documentType, fileUrl: fileUrl)
    }
    
    func completeOnboarding(uid: String, data: OnboardingData) async throws {
        try await firebaseService.saveOnboardingData(uid: uid, data: data)
    }
    
    func getUserOnboardingData(uid: String) async throws -> OnboardingData? {
        // Implementation would fetch from Firestore
        return nil
    }
}
