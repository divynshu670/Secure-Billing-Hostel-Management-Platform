import Foundation
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var state = OnboardingState()
    
    private let onboardingRepository: OnboardingRepository
    private let sessionStore: SessionStore
    private var cancellables = Set<AnyCancellable>()
    
    var isAccountDetailsValid: Bool {
        !state.firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !state.lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !state.hostelName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !state.roomNumber.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var requiredDocumentsUploaded: Bool {
        state.uploadedDocuments.count >= 2 // At least 2 documents required
    }
    
    init(
        onboardingRepository: OnboardingRepository = DefaultOnboardingRepository(),
        sessionStore: SessionStore
    ) {
        self.onboardingRepository = onboardingRepository
        self.sessionStore = sessionStore
    }
    
    func nextStep() {
        let currentIndex = state.currentStep.rawValue
        if currentIndex < OnboardingStep.allCases.count - 1 {
            state.currentStep = OnboardingStep(rawValue: currentIndex + 1)!
        }
    }
    
    func previousStep() {
        let currentIndex = state.currentStep.rawValue
        if currentIndex > 0 {
            state.currentStep = OnboardingStep(rawValue: currentIndex - 1)!
        }
    }
    
    func addDocument(type: DocumentType, fileUrl: String) {
        state.uploadedDocuments[type] = fileUrl
        state.errorMessage = nil
    }
    
    @MainActor
    func completeOnboarding() async {
        guard let session = (sessionStore as? DefaultSessionStore)?.currentSession else {
            state.errorMessage = "No active session"
            return
        }
        
        state.isLoading = true
        state.errorMessage = nil
        
        do {
            let onboardingData = OnboardingData(
                firstName: state.firstName,
                lastName: state.lastName,
                email: session.email,
                hostelName: state.hostelName,
                roomNumber: state.roomNumber,
                documents: state.uploadedDocuments.map { type, url in
                    OnboardingData.Document(type: type, fileUrl: url, uploadedAt: Date())
                }
            )
            
            try await onboardingRepository.completeOnboarding(uid: session.uid, data: onboardingData)
            
            // Update session with onboarding completion
            var updatedSession = session
            updatedSession = UserSession(
                uid: updatedSession.uid,
                email: updatedSession.email,
                displayName: "\(state.firstName) \(state.lastName)",
                photoUrl: updatedSession.photoUrl,
                isOnboarded: true,
                createdAt: updatedSession.createdAt
            )
            try await sessionStore.saveSession(updatedSession)
            
            state.successMessage = "Onboarding completed successfully!"
            nextStep()
        } catch {
            state.errorMessage = "Failed to complete onboarding: \(error.localizedDescription)"
        }
        
        state.isLoading = false
    }
}
