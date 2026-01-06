import Foundation

struct Transaction: Identifiable, Codable {
    let id: String
    let type: TransactionType
    let amount: Double
    let description: String
    let date: Date
    let status: TransactionStatus
    
    enum TransactionType: String, Codable {
        case credit = "Credit"
        case debit = "Debit"
    }
    
    enum TransactionStatus: String, Codable {
        case completed = "Completed"
        case pending = "Pending"
        case failed = "Failed"
    }
}

protocol TransactionRepository {
    func getTransactions(uid: String) async throws -> [Transaction]
    func getTransaction(uid: String, id: String) async throws -> Transaction?
}
