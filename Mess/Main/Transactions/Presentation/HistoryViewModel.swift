import Foundation
import Combine

class HistoryViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let transactionRepository: TransactionRepository
    private let sessionStore: SessionStore
    private var cancellables = Set<AnyCancellable>()
    
    init(
        transactionRepository: TransactionRepository = FirestoreTransactionRepository(),
        sessionStore: SessionStore
    ) {
        self.transactionRepository = transactionRepository
        self.sessionStore = sessionStore
    }
    
    @MainActor
    func loadTransactions() async {
        guard let session = (sessionStore as? DefaultSessionStore)?.currentSession else {
            errorMessage = "No active session"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            transactions = try await transactionRepository.getTransactions(uid: session.uid)
        } catch {
            errorMessage = "Failed to load transactions: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    var creditTransactions: [Transaction] {
        transactions.filter { $0.type == .credit }
    }
    
    var debitTransactions: [Transaction] {
        transactions.filter { $0.type == .debit }
    }
    
    var totalCredit: Double {
        creditTransactions.reduce(0) { $0 + $1.amount }
    }
    
    var totalDebit: Double {
        debitTransactions.reduce(0) { $0 + $1.amount }
    }
}
