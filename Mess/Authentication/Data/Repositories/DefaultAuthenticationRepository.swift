import Foundation

class DefaultAuthenticationRepository: AuthenticationRepository {
    private let firebaseService: FirebaseAuthenticationService
    
    init(firebaseService: FirebaseAuthenticationService = .shared) {
        self.firebaseService = firebaseService
    }
    
    func signInWithGoogle(idToken: String, accessToken: String) async throws -> AuthenticatedUser {
        try await firebaseService.signInWithGoogle(idToken: idToken, accessToken: accessToken)
    }
    
    func signOut() async throws {
        try firebaseService.signOut()
    }
    
    func getCurrentUser() async throws -> AuthenticatedUser? {
        firebaseService.getCurrentUser()
    }
}
