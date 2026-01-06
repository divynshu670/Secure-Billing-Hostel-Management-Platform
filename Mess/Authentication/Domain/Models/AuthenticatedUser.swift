import Foundation

struct AuthenticatedUser: Codable, Equatable {
    let uid: String
    let email: String
    let displayName: String?
    let photoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case uid, email, displayName, photoUrl
    }
}
