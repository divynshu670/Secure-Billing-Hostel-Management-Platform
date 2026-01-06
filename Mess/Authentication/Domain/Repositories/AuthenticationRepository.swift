import Foundation
import Combine

protocol AuthenticationRepository {
    func signInWithGoogle(idToken: String, accessToken: String) async throws -> AuthenticatedUser
    func signOut() async throws
    func getCurrentUser() async throws -> AuthenticatedUser?
}
