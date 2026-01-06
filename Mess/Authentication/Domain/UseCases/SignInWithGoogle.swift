import Foundation

class SignInWithGoogle {
    private let repository: AuthenticationRepository
    
    init(repository: AuthenticationRepository) {
        self.repository = repository
    }
    
    func execute(idToken: String, accessToken: String) async throws -> AuthenticatedUser {
        try await repository.signInWithGoogle(idToken: idToken, accessToken: accessToken)
    }
}
