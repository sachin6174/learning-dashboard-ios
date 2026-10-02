import SwiftUI

@main
struct LearningDashboardApp: App {
    @StateObject private var model = AppModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if model.isLoggedIn { DashboardView() }
                else { LoginView() }
            }
            .environmentObject(model)
        }
    }
}
