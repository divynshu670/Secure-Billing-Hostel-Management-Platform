import SwiftUI

struct AppColors {
    static let primary = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let secondary = Color(red: 0.1, green: 0.3, blue: 0.6)
    static let accent = Color(red: 1.0, green: 0.6, blue: 0.1)
    static let background = Color(red: 0.98, green: 0.98, blue: 1.0)
    static let surface = Color.white
    static let error = Color(red: 0.9, green: 0.2, blue: 0.2)
    static let success = Color(red: 0.2, green: 0.7, blue: 0.3)
    static let warning = Color(red: 1.0, green: 0.7, blue: 0.2)
    
    // Text colors
    static let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let textTertiary = Color(red: 0.7, green: 0.7, blue: 0.7)
}

extension Color {
    static let appBackground = AppColors.background
    static let appSurface = AppColors.surface
    static let appPrimary = AppColors.primary
    static let appSecondary = AppColors.secondary
    static let appAccent = AppColors.accent
    static let appError = AppColors.error
    static let appSuccess = AppColors.success
    static let appWarning = AppColors.warning
}
