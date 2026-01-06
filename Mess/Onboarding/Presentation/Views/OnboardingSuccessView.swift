import SwiftUI

struct OnboardingSuccessView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @EnvironmentObject var sessionStore: DefaultSessionStore
    @State private var navigateToMain = false
    
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.appSuccess)
                    
                    Text("Onboarding Complete!")
                        .font(AppTypography.displayMedium)
                        .foregroundColor(.appPrimary)
                    
                    Text("Your account has been set up successfully")
                        .font(AppTypography.bodyMedium)
                        .foregroundColor(.appSecondary)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: {
                        navigateToMain = true
                    }) {
                        Text("Go to Home")
                            .font(AppTypography.labelLarge)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.appPrimary)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
            
            if navigateToMain {
                NavigationLink(destination: MainTabView().environmentObject(sessionStore)) {
                    EmptyView()
                }
                .hidden()
            }
        }
    }
}

#Preview {
    OnboardingSuccessView(viewModel: OnboardingViewModel(sessionStore: DefaultSessionStore()))
        .environmentObject(DefaultSessionStore())
}
