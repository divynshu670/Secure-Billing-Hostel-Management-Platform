import SwiftUI

class AppTheme: ObservableObject {
    @Published var isDarkMode = false
    
    var backgroundColor: Color {
        isDarkMode ? Color(red: 0.1, green: 0.1, blue: 0.1) : AppColors.background
    }
    
    var surfaceColor: Color {
        isDarkMode ? Color(red: 0.15, green: 0.15, blue: 0.15) : AppColors.surface
    }
    
    var textColor: Color {
        isDarkMode ? Color.white : AppColors.textPrimary
    }
    
    var secondaryTextColor: Color {
        isDarkMode ? Color(red: 0.8, green: 0.8, blue: 0.8) : AppColors.textSecondary
    }
}

extension View {
    func themedBackground(_ theme: AppTheme) -> some View {
        self.background(theme.backgroundColor)
    }
    
    func themedSurface(_ theme: AppTheme) -> some View {
        self.background(theme.surfaceColor)
    }
}
