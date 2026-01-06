import SwiftUI

enum AppFlowState {
    case splash
    case unauthenticated
    case onboarding
    case authenticated
}

class AppFlowController: ObservableObject {
    @Published var currentState: AppFlowState = .splash
    @Published var isSessionLoading = true
    
    private let sessionStore: SessionStore
    
    init(sessionStore: SessionStore = DefaultSessionStore()) {
        self.sessionStore = sessionStore
        setupFlow()
    }
    
    private func setupFlow() {
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000) // Splash screen delay
            
            do {
                try await sessionStore.loadSession()
                
                if let session = (sessionStore as? DefaultSessionStore)?.currentSession {
                    await MainActor.run {
                        self.currentState = session.isOnboarded ? .authenticated : .onboarding
                        self.isSessionLoading = false
                    }
                } else {
                    await MainActor.run {
                        self.currentState = .unauthenticated
                        self.isSessionLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.currentState = .unauthenticated
                    self.isSessionLoading = false
                }
            }
        }
    }
    
    func resetFlow() {
        currentState = .unauthenticated
    }
}
