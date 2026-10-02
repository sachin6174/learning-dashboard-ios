import Foundation
import OSLog

@MainActor
final class AppModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var isLoggingIn = false
    @Published var loginError: String?
    @Published var courses: [Course] = []
    @Published var isLoading = false
    @Published var courseError: String?
    @Published var offlineMode = false

    private let repository = CourseRepository()
    private let logger = Logger(subsystem: "in.sachin.LearningDashboard", category: "app")

    init() {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("-resetDemoCache") {
            UserDefaults.standard.removeObject(forKey: "cachedCourses")
        }
        #endif
    }

    func login(email: String, password: String) async {
        loginError = nil
        guard email.contains("@"), email.split(separator: "@").last?.contains(".") == true else {
            loginError = "Enter a valid email address."
            return
        }
        guard !password.isEmpty else {
            loginError = "Enter your password."
            return
        }
        isLoggingIn = true
        defer { isLoggingIn = false }
        try? await Task.sleep(for: .milliseconds(350))
        isLoggedIn = true // Mock authentication.
        logger.info("Mock login succeeded")
    }

    func loadCourses() async {
        isLoading = true
        courseError = nil
        defer { isLoading = false }
        do {
            courses = try await repository.load()
            logger.info("Loaded \(self.courses.count) courses")
        } catch {
            courseError = error.localizedDescription
            logger.error("Course load failed: \(error.localizedDescription)")
        }
    }

    func setOfflineMode(_ enabled: Bool) async {
        offlineMode = enabled
        if enabled {
            logger.info("Offline cache mode enabled")
        }
        await loadCourses()
    }

    func completeLesson(courseID: Int, lessonID: Int) {
        guard let index = courses.firstIndex(where: { $0.id == courseID }) else { return }
        courses[index].completeLesson(lessonID)
        repository.save(courses)
        logger.info("Saved lesson completion for course \(courseID)")
    }
}
