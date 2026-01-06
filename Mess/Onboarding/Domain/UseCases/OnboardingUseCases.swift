import Foundation

class CheckExistingUser {
    private let repository: OnboardingRepository
    
    init(repository: OnboardingRepository) {
        self.repository = repository
    }
    
    func execute(uid: String) async throws -> Bool {
        try await repository.checkExistingUser(uid: uid)
    }
}

class UploadDocument {
    private let repository: OnboardingRepository
    
    init(repository: OnboardingRepository) {
        self.repository = repository
    }
    
    func execute(uid: String, documentType: DocumentType, fileUrl: String) async throws {
        try await repository.uploadDocument(uid: uid, documentType: documentType, fileUrl: fileUrl)
    }
}

class CompleteOnboarding {
    private let repository: OnboardingRepository
    
    init(repository: OnboardingRepository) {
        self.repository = repository
    }
    
    func execute(uid: String, data: OnboardingData) async throws {
        try await repository.completeOnboarding(uid: uid, data: data)
    }
}
