import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var state = LoginState()
    
    private let authRepository: AuthenticationRepository
    private let sessionStore: SessionStore
    private var cancellables = Set<AnyCancellable>()
    
    init(
        authRepository: AuthenticationRepository = DefaultAuthenticationRepository(),
        sessionStore: SessionStore
    ) {
        self.authRepository = authRepository
        self.sessionStore = sessionStore
    }
    
    @MainActor
    func signInWithGoogle(idToken: String, accessToken: String) async {
        state.isLoading = true
        state.errorMessage = nil
        
        do {
            let user = try await authRepository.signInWithGoogle(idToken: idToken, accessToken: accessToken)
            let session = UserSession(
                uid: user.uid,
                email: user.email,
                displayName: user.displayName,
                photoUrl: user.photoUrl,
                isOnboarded: false,
                createdAt: Date()
            )
            try await sessionStore.saveSession(session)
            state.isLoggedIn = true
        } catch {
            state.errorMessage = "Sign in failed: \(error.localizedDescription)"
        }
        
        state.isLoading = false
    }
}
