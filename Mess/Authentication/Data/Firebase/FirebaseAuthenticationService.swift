import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthenticationService {
    static let shared = FirebaseAuthenticationService()
    
    private let db = Firestore.firestore()
    
    func signInWithGoogle(idToken: String, accessToken: String) async throws -> AuthenticatedUser {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        let authResult = try await Auth.auth().signIn(with: credential)
        
        let user = authResult.user
        return AuthenticatedUser(
            uid: user.uid,
            email: user.email ?? "",
            displayName: user.displayName,
            photoUrl: user.photoURL?.absoluteString
        )
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func getCurrentUser() -> AuthenticatedUser? {
        guard let firebaseUser = Auth.auth().currentUser else { return nil }
        return AuthenticatedUser(
            uid: firebaseUser.uid,
            email: firebaseUser.email ?? "",
            displayName: firebaseUser.displayName,
            photoUrl: firebaseUser.photoURL?.absoluteString
        )
    }
}
