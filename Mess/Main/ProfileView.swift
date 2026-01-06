import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var sessionStore: DefaultSessionStore
    @Environment(\.dismiss) var dismiss
    @State private var showLogoutAlert = false
    @State private var loggedOut = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Profile")
                            .headlineLarge()
                        Spacer()
                    }
                    .padding(16)
                    .background(Color.appSurface)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            // Profile Header
                            VStack(spacing: 12) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 64))
                                    .foregroundColor(.appPrimary)
                                
                                VStack(spacing: 4) {
                                    Text(sessionStore.currentSession?.displayName ?? "User")
                                        .font(AppTypography.headlineMedium)
                                        .foregroundColor(.appPrimary)
                                    Text(sessionStore.currentSession?.email ?? "")
                                        .font(AppTypography.bodySmall)
                                        .foregroundColor(.appSecondary)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                            .background(Color.appSurface)
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            
                            // Account Settings
                            VStack(spacing: 0) {
                                SettingRowView(
                                    icon: "person.fill",
                                    title: "Edit Profile",
                                    color: .appPrimary
                                )
                                Divider().padding(.horizontal, 16)
                                SettingRowView(
                                    icon: "lock.fill",
                                    title: "Change Password",
                                    color: .appPrimary
                                )
                                Divider().padding(.horizontal, 16)
                                SettingRowView(
                                    icon: "bell.fill",
                                    title: "Notifications",
                                    color: .appAccent
                                )
                            }
                            .background(Color.appSurface)
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                            
                            // App Settings
                            VStack(spacing: 0) {
                                SettingRowView(
                                    icon: "sun.max.fill",
                                    title: "Theme",
                                    color: .appAccent
                                )
                                Divider().padding(.horizontal, 16)
                                SettingRowView(
                                    icon: "globe",
                                    title: "Language",
                                    color: .appPrimary
                                )
                                Divider().padding(.horizontal, 16)
                                SettingRowView(
                                    icon: "questionmark.circle.fill",
                                    title: "Help & Support",
                                    color: .appPrimary
                                )
                            }
                            .background(Color.appSurface)
                            .cornerRadius(12)
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                            
                            // Logout Button
                            Button(action: { showLogoutAlert = true }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "arrow.left.circle.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.appError)
                                    
                                    Text("Logout")
                                        .font(AppTypography.labelLarge)
                                        .foregroundColor(.appError)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.appSurface)
                                .cornerRadius(12)
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                        }
                        .padding(.bottom, 32)
                    }
                }
            }
            .alert("Logout", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Logout", role: .destructive) {
                    Task {
                        try await sessionStore.clearSession()
                        loggedOut = true
                    }
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
            .navigationDestination(isPresented: $loggedOut) {
                WelcomeView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct SettingRowView: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
                .frame(width: 28)
            
            Text(title)
                .font(AppTypography.bodyMedium)
                .foregroundColor(.appPrimary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.appSecondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    ProfileView()
        .environmentObject(DefaultSessionStore())
}
