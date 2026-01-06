import Foundation

class BuildDashboardSummary {
    private let repository: DashboardRepository
    
    init(repository: DashboardRepository) {
        self.repository = repository
    }
    
    func execute(uid: String) async throws -> DashboardSummary {
        try await repository.getDashboardSummary(uid: uid)
    }
}
