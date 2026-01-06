import SwiftUI
import Charts

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @EnvironmentObject var sessionStore: DefaultSessionStore
    
    init(sessionStore: SessionStore) {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(sessionStore: sessionStore))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome")
                                .font(AppTypography.bodySmall)
                                .foregroundColor(.appSecondary)
                            Text(sessionStore.currentSession?.displayName ?? "User")
                                .headlineLarge()
                        }
                        Spacer()
                        Image(systemName: "bell")
                            .font(.system(size: 20))
                            .foregroundColor(.appPrimary)
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
                        }
                        Spacer()
                    } else if let summary = viewModel.summary {
                        ScrollView {
                            VStack(spacing: 16) {
                                // Balance Card
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Total Balance")
                                        .font(AppTypography.labelMedium)
                                        .foregroundColor(.appSecondary)
                                    Text(String(format: "₹%.2f", summary.totalBalance))
                                        .font(AppTypography.displaySmall)
                                        .foregroundColor(summary.totalBalance >= 0 ? .appSuccess : .appError)
                                    HStack(spacing: 4) {
                                        Image(systemName: summary.totalBalance >= 0 ? "arrow.up.right" : "arrow.down.left")
                                            .font(.system(size: 10, weight: .semibold))
                                        Text("Updated today")
                                            .font(AppTypography.bodySmall)
                                    }
                                    .foregroundColor(.appSecondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(16)
                                .background(Color.appSurface)
                                .cornerRadius(12)
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                                
                                // Quick Stats
                                HStack(spacing: 12) {
                                    StatCard(title: "Credits", value: summary.creditAmount, color: .appSuccess)
                                    StatCard(title: "Debits", value: summary.debitAmount, color: .appError)
                                    StatCard(title: "Pending", value: summary.pendingPayments, color: .appWarning)
                                }
                                .padding(.horizontal, 16)
                                .padding(.top, 12)
                                
                                // Chart Section
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Monthly Overview")
                                        .font(AppTypography.labelLarge)
                                        .foregroundColor(.appPrimary)
                                    
                                    HStack(spacing: 16) {
                                        Circle()
                                            .fill(Color.appSuccess)
                                            .frame(width: 12, height: 12)
                                        Text("Credits: ₹\(String(format: "%.0f", summary.creditAmount))")
                                            .font(AppTypography.bodySmall)
                                        
                                        Spacer()
                                        
                                        Circle()
                                            .fill(Color.appError)
                                            .frame(width: 12, height: 12)
                                        Text("Debits: ₹\(String(format: "%.0f", summary.debitAmount))")
                                            .font(AppTypography.bodySmall)
                                    }
                                    .padding(.horizontal, 12)
                                    
                                    SimpleBarChart(credits: summary.creditAmount, debits: summary.debitAmount)
                                        .frame(height: 150)
                                }
                                .padding(16)
                                .background(Color.appSurface)
                                .cornerRadius(12)
                                .padding(.horizontal, 16)
                                .padding(.top, 12)
                            }
                            .padding(.bottom, 32)
                        }
                    }
                }
            }
            .task {
                await viewModel.loadDashboard()
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTypography.labelSmall)
                .foregroundColor(.appSecondary)
            Text(String(format: "₹%.0f", value))
                .font(AppTypography.headlineSmall)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.appSurface)
        .cornerRadius(8)
    }
}

struct SimpleBarChart: View {
    let credits: Double
    let debits: Double
    
    var maxValue: Double {
        max(credits, debits, 1000)
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 24) {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.appSuccess)
                    .frame(height: CGFloat(credits / maxValue * 120))
                Text("Credits")
                    .font(AppTypography.labelSmall)
                    .foregroundColor(.appSecondary)
            }
            
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.appError)
                    .frame(height: CGFloat(debits / maxValue * 120))
                Text("Debits")
                    .font(AppTypography.labelSmall)
                    .foregroundColor(.appSecondary)
            }
            
            Spacer()
        }
        .frame(height: 150)
    }
}

#Preview {
    DashboardView(sessionStore: DefaultSessionStore())
        .environmentObject(DefaultSessionStore())
}
