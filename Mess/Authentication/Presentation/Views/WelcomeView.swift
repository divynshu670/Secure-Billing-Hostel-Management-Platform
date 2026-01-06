import SwiftUI

struct WelcomeView: View {
    @StateObject private var navigationModel = NavigationModel()
    
    var body: some View {
        NavigationStack(path: $navigationModel.navigationPath) {
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 60))
                        .foregroundColor(.appPrimary)
                    
                    Text("Mess Canteen")
                        .font(AppTypography.displayLarge)
                        .foregroundColor(.appPrimary)
                    
                    Text("Manage your mess billing effortlessly")
                        .font(AppTypography.bodyMedium)
                        .foregroundColor(.appSecondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: {
                        navigationModel.navigate(to: .login)
                    }) {
                        Text("Get Started")
                            .font(AppTypography.labelLarge)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.appPrimary)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    HStack(spacing: 8) {
                        Text("Already have an account?")
                            .font(AppTypography.bodySmall)
                        Button(action: {
                            navigationModel.navigate(to: .login)
                        }) {
                            Text("Sign In")
                                .font(AppTypography.labelMedium)
                                .foregroundColor(.appPrimary)
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
            .background(Color.appBackground)
            .navigationDestination(for: AppDestination.self) { destination in
                switch destination {
                case .login:
                    LoginView()
                case .signup:
                    SignupView()
                default:
                    EmptyView()
                }
            }
        }
        .environmentObject(navigationModel)
    }
}

#Preview {
    WelcomeView()
}
