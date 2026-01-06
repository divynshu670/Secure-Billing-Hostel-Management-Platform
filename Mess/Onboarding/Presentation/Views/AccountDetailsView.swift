import SwiftUI

struct AccountDetailsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.appPrimary)
                }
                Spacer()
                Text("Account Details")
                    .headlineLarge()
                Spacer()
                Color.clear.frame(width: 44)
            }
            .padding(.horizontal, 16)
            
            ProgressView(value: viewModel.state.currentStep.progress)
                .tint(.appPrimary)
                .padding(.horizontal, 16)
            
            ScrollView {
                VStack(spacing: 16) {
                    Text("Please provide your account details")
                        .font(AppTypography.bodyMedium)
                        .foregroundColor(.appSecondary)
                    
                    VStack(spacing: 12) {
                        TextField("First Name", text: $viewModel.state.firstName)
                            .textFieldStyle(.roundedBorder)
                        
                        TextField("Last Name", text: $viewModel.state.lastName)
                            .textFieldStyle(.roundedBorder)
                        
                        TextField("Hostel Name", text: $viewModel.state.hostelName)
                            .textFieldStyle(.roundedBorder)
                        
                        TextField("Room Number", text: $viewModel.state.roomNumber)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                    }
                    
                    if let errorMessage = viewModel.state.errorMessage {
                        Text(errorMessage)
                            .font(AppTypography.bodySmall)
                            .foregroundColor(.appError)
                            .padding(12)
                            .background(Color.appError.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 16)
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: { viewModel.nextStep() }) {
                    if viewModel.state.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Continue")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(viewModel.isAccountDetailsValid ? Color.appPrimary : Color.appPrimary.opacity(0.5))
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(!viewModel.isAccountDetailsValid || viewModel.state.isLoading)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color.appBackground)
    }
}

#Preview {
    AccountDetailsView(viewModel: OnboardingViewModel(sessionStore: DefaultSessionStore()))
}
