import Foundation

protocol OnboardingRepository {
    func checkExistingUser(uid: String) async throws -> Bool
    func uploadDocument(uid: String, documentType: DocumentType, fileUrl: String) async throws
    func completeOnboarding(uid: String, data: OnboardingData) async throws
    func getUserOnboardingData(uid: String) async throws -> OnboardingData?
}
