import SwiftUI

struct PaymentsView: View {
    @StateObject private var viewModel: BillingViewModel
    
    init(sessionStore: SessionStore) {
        _viewModel = StateObject(wrappedValue: BillingViewModel(sessionStore: sessionStore))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Payments")
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
                                    await viewModel.loadPayments()
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
                    } else if viewModel.payments.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "creditcard")
                                .font(.system(size: 48))
                                .foregroundColor(.appSecondary)
                            Text("No payments found")
                                .font(AppTypography.bodyMedium)
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 12) {
                                // Summary Cards
                                HStack(spacing: 12) {
                                    PaymentSummaryCard(
                                        title: "Pending",
                                        amount: viewModel.totalPending,
                                        color: .appWarning
                                    )
                                    PaymentSummaryCard(
                                        title: "Paid",
                                        amount: viewModel.totalPaid,
                                        color: .appSuccess
                                    )
                                }
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                                
                                // Payments List
                                VStack(spacing: 8) {
                                    ForEach(viewModel.payments) { payment in
                                        PaymentRowView(payment: payment)
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
                await viewModel.loadPayments()
            }
        }
    }
}

struct PaymentSummaryCard: View {
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

struct PaymentRowView: View {
    let payment: Payment
    
    var statusColor: Color {
        switch payment.status {
        case .paid: return .appSuccess
        case .pending: return .appWarning
        case .overdue: return .appError
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "creditcard.fill")
                .font(.system(size: 16))
                .foregroundColor(statusColor)
                .frame(width: 40, height: 40)
                .background(statusColor.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(payment.month)
                    .font(AppTypography.labelMedium)
                    .foregroundColor(.appPrimary)
                Text("Due: \(payment.dueDate.formattedDate())")
                    .font(AppTypography.bodySmall)
                    .foregroundColor(.appSecondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "₹%.2f", payment.amount))
                    .font(AppTypography.labelMedium)
                    .foregroundColor(.appPrimary)
                Text(payment.status.rawValue)
                    .font(AppTypography.bodySmall)
                    .foregroundColor(statusColor)
            }
        }
        .padding(12)
        .background(Color.appSurface)
        .cornerRadius(8)
    }
}

#Preview {
    PaymentsView(sessionStore: DefaultSessionStore())
}
