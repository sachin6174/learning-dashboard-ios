import Foundation

struct CourseRepository {
    private let cacheKey = "cachedCourses"
    private let storage: UserDefaults

    init(storage: UserDefaults = .standard) { self.storage = storage }

    func load() async throws -> [Course] {
        // The bundled JSON stands in for an API response. The cache is used first,
        // so a previously loaded dashboard remains available without a network.
        if let data = storage.data(forKey: cacheKey),
           let courses = try? JSONDecoder().decode([Course].self, from: data) {
            return courses
        }
        guard let url = Bundle.main.url(forResource: "courses", withExtension: "json") else {
            throw CourseError.missingData
        }
        let courses = try JSONDecoder().decode([Course].self, from: Data(contentsOf: url))
        save(courses)
        return courses
    }

    func save(_ courses: [Course]) {
        guard let data = try? JSONEncoder().encode(courses) else { return }
        storage.set(data, forKey: cacheKey)
    }
}

enum CourseError: LocalizedError {
    case missingData
    var errorDescription: String? { "Courses could not be loaded. Please try again." }
}
