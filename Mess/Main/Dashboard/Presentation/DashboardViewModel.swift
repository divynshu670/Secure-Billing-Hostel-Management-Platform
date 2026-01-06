import Foundation
import Combine

class DashboardViewModel: ObservableObject {
    @Published var summary: DashboardSummary?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let transactionRepository: TransactionRepository
    private let billingRepository: BillingRepository
    private let sessionStore: SessionStore
    
    init(
        transactionRepository: TransactionRepository = FirestoreTransactionRepository(),
        billingRepository: BillingRepository = FirestoreBillingRepository(),
        sessionStore: SessionStore
    ) {
        self.transactionRepository = transactionRepository
        self.billingRepository = billingRepository
        self.sessionStore = sessionStore
    }
    
    @MainActor
    func loadDashboard() async {
        guard let session = (sessionStore as? DefaultSessionStore)?.currentSession else {
            errorMessage = "No active session"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let transactions = try await transactionRepository.getTransactions(uid: session.uid)
            let payments = try await billingRepository.getPayments(uid: session.uid)
            
            let credits = transactions.filter { $0.type == .credit }.reduce(0) { $0 + $1.amount }
            let debits = transactions.filter { $0.type == .debit }.reduce(0) { $0 + $1.amount }
            let pending = payments.filter { $0.status != .paid }.reduce(0) { $0 + $1.amount }
            
            summary = DashboardSummary(
                totalBalance: credits - debits,
                creditAmount: credits,
                debitAmount: debits,
                pendingPayments: pending,
                lastTransactionDate: transactions.first?.date,
                monthlySpending: debits
            )
        } catch {
            errorMessage = "Failed to load dashboard: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
