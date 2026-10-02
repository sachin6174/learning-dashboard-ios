import Foundation

@MainActor
final class AppModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var isLoggingIn = false
    @Published var loginError: String?
    @Published var courses: [Course] = []
    @Published var isLoading = false
    @Published var courseError: String?

    private let repository = CourseRepository()

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
    }

    func loadCourses() async {
        isLoading = true
        courseError = nil
        defer { isLoading = false }
        do { courses = try await repository.load() }
        catch { courseError = error.localizedDescription }
    }

    func completeLesson(courseID: Int, lessonID: Int) {
        guard let index = courses.firstIndex(where: { $0.id == courseID }) else { return }
        courses[index].completeLesson(lessonID)
        repository.save(courses)
    }
}
