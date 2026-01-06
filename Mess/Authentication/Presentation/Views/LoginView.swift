import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    @EnvironmentObject private var sessionStore: DefaultSessionStore
    @Environment(\.dismiss) var dismiss
    
    init(
        authRepository: AuthenticationRepository = DefaultAuthenticationRepository(),
        sessionStore: SessionStore
    ) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(authRepository: authRepository, sessionStore: sessionStore))
    }
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.appPrimary)
                }
                Spacer()
                Text("Sign In")
                    .headlineLarge()
                Spacer()
                Color.clear.frame(width: 44)
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "person.circle")
                    .font(.system(size: 64))
                    .foregroundColor(.appPrimary)
                
                Text("Welcome Back")
                    .font(AppTypography.headlineMedium)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                // Google Sign In Button
                GoogleSignInButton(action: handleGoogleSignIn)
                
                HStack(spacing: 0) {
                    VStack {
                        Divider()
                    }
                    Text("or")
                        .font(AppTypography.bodySmall)
                        .foregroundColor(.appSecondary)
                        .padding(.horizontal, 8)
                    VStack {
                        Divider()
                    }
                }
                
                // Email & Password fields
                VStack(spacing: 12) {
                    TextField("Email", text: $viewModel.state.email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.state.password)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(action: {}) {
                        Text("Forgot Password?")
                            .font(AppTypography.labelSmall)
                            .foregroundColor(.appPrimary)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                if let errorMessage = viewModel.state.errorMessage {
                    Text(errorMessage)
                        .font(AppTypography.bodySmall)
                        .foregroundColor(.appError)
                        .padding(12)
                        .background(Color.appError.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Button(action: {}) {
                    if viewModel.state.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Sign In")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.appPrimary)
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(viewModel.state.isLoading)
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .font(AppTypography.bodySmall)
                Button(action: { navigationModel.navigate(to: .signup) }) {
                    Text("Sign Up")
                        .font(AppTypography.labelSmall)
                        .foregroundColor(.appPrimary)
                }
            }
            .padding(.bottom, 32)
        }
        .background(Color.appBackground)
    }
    
    private func handleGoogleSignIn() {
        Task {
            // Note: In a real app, you'd integrate GoogleSignIn SDK properly
            // This is a placeholder
            print("Google Sign In tapped")
        }
    }
}

#Preview {
    NavigationStack {
        LoginView(sessionStore: DefaultSessionStore())
            .environmentObject(NavigationModel())
    }
}
