import Foundation
import Combine

protocol SessionStore {
    var currentSession: UserSession? { get }
    var sessionPublisher: AnyPublisher<UserSession?, Never> { get }
    
    func saveSession(_ session: UserSession) async throws
    func loadSession() async throws
    func clearSession() async throws
}
