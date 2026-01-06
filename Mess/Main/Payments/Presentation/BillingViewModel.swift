import Foundation
import Combine

class BillingViewModel: ObservableObject {
    @Published var payments: [Payment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let billingRepository: BillingRepository
    private let sessionStore: SessionStore
    
    init(
        billingRepository: BillingRepository = FirestoreBillingRepository(),
        sessionStore: SessionStore
    ) {
        self.billingRepository = billingRepository
        self.sessionStore = sessionStore
    }
    
    @MainActor
    func loadPayments() async {
        guard let session = (sessionStore as? DefaultSessionStore)?.currentSession else {
            errorMessage = "No active session"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            payments = try await billingRepository.getPayments(uid: session.uid)
        } catch {
            errorMessage = "Failed to load payments: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    var totalPending: Double {
        payments.filter { $0.status == .pending || $0.status == .overdue }
            .reduce(0) { $0 + $1.amount }
    }
    
    var totalPaid: Double {
        payments.filter { $0.status == .paid }
            .reduce(0) { $0 + $1.amount }
    }
    
    var pendingPayments: [Payment] {
        payments.filter { $0.status == .pending || $0.status == .overdue }
    }
}
