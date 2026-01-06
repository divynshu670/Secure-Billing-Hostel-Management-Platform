import SwiftUI

struct TransactionsView: View {
    @StateObject private var viewModel: HistoryViewModel
    
    init(sessionStore: SessionStore) {
        _viewModel = StateObject(wrappedValue: HistoryViewModel(sessionStore: sessionStore))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Transactions")
                            .headlineLarge()
                        Spacer()
                    }
                    .padding(16)
                    .background(Color.appSurface)
                    
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                        Spacer()
                    } else if let errorMessage = viewModel.errorMessage {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.appError)
                            Text(errorMessage)
                                .font(AppTypography.bodyMedium)
                                .multilineTextAlignment(.center)
                            Button(action: {
                                Task {
                                    await viewModel.loadTransactions()
                                }
                            }) {
                                Text("Retry")
                                    .font(AppTypography.labelLarge)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 8)
                                    .background(Color.appPrimary)
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                            }
                        }
                        Spacer()
                    } else if viewModel.transactions.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 48))
                                .foregroundColor(.appSecondary)
                            Text("No transactions yet")
                                .font(AppTypography.bodyMedium)
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                // Summary Cards
                                HStack(spacing: 12) {
                                    TransactionSummaryCard(
                                        title: "Credits",
                                        amount: viewModel.totalCredit,
                                        color: .appSuccess
                                    )
                                    TransactionSummaryCard(
                                        title: "Debits",
                                        amount: viewModel.totalDebit,
                                        color: .appError
                                    )
                                }
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                                
                                // Transactions List
                                VStack(spacing: 8) {
                                    ForEach(viewModel.transactions) { transaction in
                                        TransactionRowView(transaction: transaction)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.top, 12)
                            }
                            .padding(.bottom, 32)
                        }
                    }
                }
            }
            .task {
                await viewModel.loadTransactions()
            }
        }
    }
}

struct TransactionSummaryCard: View {
    let title: String
    let amount: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTypography.labelMedium)
                .foregroundColor(.appSecondary)
            Text(String(format: "₹%.2f", amount))
                .font(AppTypography.headlineLarge)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.appSurface)
        .cornerRadius(8)
    }
}

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: transaction.type == .credit ? "arrow.down.left" : "arrow.up.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(transaction.type == .credit ? .appSuccess : .appError)
                .frame(width: 40, height: 40)
                .background(transaction.type == .credit ? Color.appSuccess.opacity(0.1) : Color.appError.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.description)
                    .font(AppTypography.labelMedium)
                    .foregroundColor(.appPrimary)
                Text(transaction.date.formattedDateTime())
                    .font(AppTypography.bodySmall)
                    .foregroundColor(.appSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%s%.2f", transaction.type == .credit ? "+" : "-", transaction.amount))
                    .font(AppTypography.labelMedium)
                    .foregroundColor(transaction.type == .credit ? .appSuccess : .appError)
                Text(transaction.status.rawValue)
                    .font(AppTypography.bodySmall)
                    .foregroundColor(.appSecondary)
            }
        }
        .padding(12)
        .background(Color.appSurface)
        .cornerRadius(8)
    }
}

#Preview {
    TransactionsView(sessionStore: DefaultSessionStore())
}
