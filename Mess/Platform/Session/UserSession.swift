import Foundation

struct UserSession: Codable, Equatable {
    let uid: String
    let email: String
    let displayName: String?
    let photoUrl: String?
    let isOnboarded: Bool
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case uid, email, displayName, photoUrl, isOnboarded, createdAt
    }
}
