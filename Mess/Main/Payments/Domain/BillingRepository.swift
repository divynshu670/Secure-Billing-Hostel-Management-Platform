import Foundation

struct Payment: Identifiable, Codable {
    let id: String
    let amount: Double
    let dueDate: Date
    let paidDate: Date?
    let status: PaymentStatus
    let month: String
    
    enum PaymentStatus: String, Codable {
        case paid = "Paid"
        case pending = "Pending"
        case overdue = "Overdue"
    }
}

protocol BillingRepository {
    func getPayments(uid: String) async throws -> [Payment]
    func getPayment(uid: String, id: String) async throws -> Payment?
    func makePayment(uid: String, paymentId: String, amount: Double) async throws -> Bool
}
