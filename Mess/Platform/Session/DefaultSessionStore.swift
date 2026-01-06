import Foundation
import Combine

class DefaultSessionStore: SessionStore, ObservableObject {
    @Published private(set) var currentSession: UserSession?
    
    private let userDefaults = UserDefaults.standard
    private let sessionKey = "com.app.session"
    private let sessionSubject = CurrentValueSubject<UserSession?, Never>(nil)
    
    var sessionPublisher: AnyPublisher<UserSession?, Never> {
        sessionSubject.eraseToAnyPublisher()
    }
    
    init() {
        do {
            try loadSession()
        } catch {
            print("Failed to load session: \(error)")
        }
    }
    
    func saveSession(_ session: UserSession) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(session)
        userDefaults.set(data, forKey: sessionKey)
        
        await MainActor.run {
            self.currentSession = session
            self.sessionSubject.send(session)
        }
    }
    
    func loadSession() async throws {
        guard let data = userDefaults.data(forKey: sessionKey) else {
            await MainActor.run {
                self.currentSession = nil
                self.sessionSubject.send(nil)
            }
            return
        }
        
        let decoder = JSONDecoder()
        let session = try decoder.decode(UserSession.self, from: data)
        
        await MainActor.run {
            self.currentSession = session
            self.sessionSubject.send(session)
        }
    }
    
    func clearSession() async throws {
        userDefaults.removeObject(forKey: sessionKey)
        
        await MainActor.run {
            self.currentSession = nil
            self.sessionSubject.send(nil)
        }
    }
}
