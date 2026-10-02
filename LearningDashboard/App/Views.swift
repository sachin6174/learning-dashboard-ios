import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var model: AppModel
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Spacer()
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 38))
                        .foregroundStyle(.blue)
                        .accessibilityHidden(true)
                    Spacer()
                }
                .listRowBackground(Color.clear)
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("Password", text: $password)
                    .textContentType(.password)
                if let error = model.loginError {
                    Text(error).foregroundStyle(.red)
                }
                Button {
                    Task { await model.login(email: email, password: password) }
                } label: {
                    if model.isLoggingIn { ProgressView() }
                    else { Text("Login") }
                }
                .disabled(model.isLoggingIn)
                .accessibilityIdentifier("loginButton")
            }
            .navigationTitle("Login")
        }
    }
}

struct DashboardView: View {
    @EnvironmentObject private var model: AppModel

    var body: some View {
        NavigationStack {
            Group {
                if model.isLoading && model.courses.isEmpty {
                    ProgressView("Loading courses…")
                } else if let error = model.courseError, model.courses.isEmpty {
                    ContentUnavailableView(error, systemImage: "wifi.exclamationmark")
                } else if model.courses.isEmpty {
                    ContentUnavailableView("No courses", systemImage: "books.vertical")
                } else {
                    List(model.courses) { course in
                        NavigationLink(value: course.id) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(course.title).font(.headline)
                                Text("Instructor: \(course.instructor)")
                                ProgressView(value: Double(course.progress), total: 100)
                                Text("\(course.progress)% complete · \(course.lessons) lessons")
                                    .font(.subheadline).foregroundStyle(.secondary)
                                Text("Continue").foregroundStyle(.blue)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .navigationDestination(for: Int.self) { CourseDetailsView(courseID: $0) }
                }
            }
            .navigationTitle("My Courses")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(model.offlineMode ? "Offline cache" : "Offline") {
                        Task { await model.setOfflineMode(!model.offlineMode) }
                    }
                    Button("Retry") { Task { await model.loadCourses() } }
                }
            }
            .task { if model.courses.isEmpty { await model.loadCourses() } }
        }
    }
}

struct CourseDetailsView: View {
    @EnvironmentObject private var model: AppModel
    let courseID: Int

    private let lessonNames = ["Introduction", "Variables & Data Types", "Functions", "OOP"]

    var body: some View {
        Group {
            if let course = model.courses.first(where: { $0.id == courseID }) {
                List {
                    Section {
                        Text("Progress: \(course.progress)%")
                        ProgressView(value: Double(course.progress), total: 100)
                    }
                    Section("Lessons") {
                        ForEach(0..<course.lessons, id: \.self) { lessonID in
                            let completed = course.completedLessonIDs.contains(lessonID)
                            Button {
                                model.completeLesson(courseID: courseID, lessonID: lessonID)
                            } label: {
                                HStack {
                                    Text(lessonID < lessonNames.count ? lessonNames[lessonID] : "Lesson \(lessonID + 1)")
                                    Spacer()
                                    Text(completed ? "✓ Completed" : "○ Pending")
                                }
                            }
                            .disabled(completed)
                        }
                    }
                }
                .navigationTitle(course.title)
            }
        }
    }
}
