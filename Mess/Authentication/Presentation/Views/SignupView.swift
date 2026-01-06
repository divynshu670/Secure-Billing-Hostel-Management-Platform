import SwiftUI

struct SignupView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.appPrimary)
                }
                Spacer()
                Text("Create Account")
                    .headlineLarge()
                Spacer()
                Color.clear.frame(width: 44)
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 64))
                    .foregroundColor(.appPrimary)
                
                Text("Create Your Account")
                    .font(AppTypography.headlineMedium)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    TextField("Email", text: .constant(""))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: .constant(""))
                        .textFieldStyle(.roundedBorder)
                    
                    SecureField("Confirm Password", text: .constant(""))
                        .textFieldStyle(.roundedBorder)
                }
                
                Button(action: {}) {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.appPrimary)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("Already have an account?")
                    .font(AppTypography.bodySmall)
                Button(action: { navigationModel.navigate(to: .login) }) {
                    Text("Sign In")
                        .font(AppTypography.labelSmall)
                        .foregroundColor(.appPrimary)
                }
            }
            .padding(.bottom, 32)
        }
        .background(Color.appBackground)
    }
}

#Preview {
    NavigationStack {
        SignupView()
            .environmentObject(NavigationModel())
    }
}
