import Foundation

class AppEnvironment {
    static let shared = AppEnvironment()
    
    let sessionStore: SessionStore
    let authRepository: AuthenticationRepository
    let onboardingRepository: OnboardingRepository
    let transactionRepository: TransactionRepository
    let billingRepository: BillingRepository
    
    init(
        sessionStore: SessionStore = DefaultSessionStore(),
        authRepository: AuthenticationRepository = DefaultAuthenticationRepository(),
        onboardingRepository: OnboardingRepository = DefaultOnboardingRepository(),
        transactionRepository: TransactionRepository = FirestoreTransactionRepository(),
        billingRepository: BillingRepository = FirestoreBillingRepository()
    ) {
        self.sessionStore = sessionStore
        self.authRepository = authRepository
        self.onboardingRepository = onboardingRepository
        self.transactionRepository = transactionRepository
        self.billingRepository = billingRepository
    }
}
