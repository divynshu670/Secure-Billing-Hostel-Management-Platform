import SwiftUI

struct AppTypography {
    // Display styles
    static let displayLarge = Font.system(size: 32, weight: .bold)
    static let displayMedium = Font.system(size: 28, weight: .bold)
    static let displaySmall = Font.system(size: 24, weight: .bold)
    
    // Headline styles
    static let headlineLarge = Font.system(size: 22, weight: .semibold)
    static let headlineMedium = Font.system(size: 18, weight: .semibold)
    static let headlineSmall = Font.system(size: 16, weight: .semibold)
    
    // Body styles
    static let bodyLarge = Font.system(size: 16, weight: .regular)
    static let bodyMedium = Font.system(size: 14, weight: .regular)
    static let bodySmall = Font.system(size: 12, weight: .regular)
    
    // Label styles
    static let labelLarge = Font.system(size: 14, weight: .semibold)
    static let labelMedium = Font.system(size: 12, weight: .semibold)
    static let labelSmall = Font.system(size: 11, weight: .semibold)
}

extension Text {
    func displayLarge() -> some View {
        self.font(AppTypography.displayLarge)
    }
    
    func headlineLarge() -> some View {
        self.font(AppTypography.headlineLarge)
    }
    
    func bodyLarge() -> some View {
        self.font(AppTypography.bodyLarge)
    }
    
    func labelMedium() -> some View {
        self.font(AppTypography.labelMedium)
    }
}
