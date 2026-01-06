import Foundation

struct DashboardSummary: Codable {
    let totalBalance: Double
    let creditAmount: Double
    let debitAmount: Double
    let pendingPayments: Double
    let lastTransactionDate: Date?
    let monthlySpending: Double
}

protocol DashboardRepository {
    func getDashboardSummary(uid: String) async throws -> DashboardSummary
}
