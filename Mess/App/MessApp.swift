import SwiftUI

@main
struct MessApp: App {
    @StateObject private var appFlow: AppFlowController
    @StateObject private var sessionStore: DefaultSessionStore
    @StateObject private var navigationModel = NavigationModel()
    
    init() {
        let sessionStore = DefaultSessionStore()
        let appFlow = AppFlowController(sessionStore: sessionStore)
        _sessionStore = StateObject(wrappedValue: sessionStore)
        _appFlow = StateObject(wrappedValue: appFlow)
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if appFlow.isSessionLoading {
                    SplashView()
                } else {
                    switch appFlow.currentState {
                    case .splash:
                        SplashView()
                    
                    case .unauthenticated:
                        WelcomeView()
                            .environmentObject(navigationModel)
                            .environmentObject(sessionStore)
                    
                    case .onboarding:
                        OnboardingFlowView(sessionStore: sessionStore)
                            .environmentObject(sessionStore)
                    
                    case .authenticated:
                        MainTabView()
                            .environmentObject(sessionStore)
                    }
                }
            }
            .environmentObject(appFlow)
            .environmentObject(sessionStore)
        }
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.appPrimary.ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(systemName: "fork.knife")
                    .font(.system(size: 64))
                    .foregroundColor(.white)
                
                Text("Mess Canteen")
                    .font(AppTypography.displayMedium)
                    .foregroundColor(.white)
            }
        }
    }
}

struct OnboardingFlowView: View {
    @StateObject private var viewModel: OnboardingViewModel
    @EnvironmentObject var sessionStore: DefaultSessionStore
    @EnvironmentObject var appFlow: AppFlowController
    
    init(sessionStore: SessionStore) {
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(sessionStore: sessionStore))
    }
    
    var body: some View {
        NavigationStack {
            switch viewModel.state.currentStep {
            case .accountDetails:
                AccountDetailsView(viewModel: viewModel)
            case .documentUpload:
                DocumentUploadView(viewModel: viewModel)
            case .success:
                OnboardingSuccessView(viewModel: viewModel)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            appFlow.currentState = .authenticated
                        }
                    }
            }
        }
        .environmentObject(sessionStore)
    }
}

#Preview {
    MessApp()
}
