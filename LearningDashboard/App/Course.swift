import Foundation

struct Course: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let instructor: String
    var progress: Int
    let lessons: Int
    var completedLessonIDs: Set<Int> = []

    enum CodingKeys: String, CodingKey {
        case id, title, instructor, progress, lessons, completedLessonIDs
    }

    init(id: Int, title: String, instructor: String, progress: Int, lessons: Int,
         completedLessonIDs: Set<Int> = []) {
        self.id = id
        self.title = title
        self.instructor = instructor
        self.progress = progress
        self.lessons = lessons
        self.completedLessonIDs = completedLessonIDs
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        title = try values.decode(String.self, forKey: .title)
        instructor = try values.decode(String.self, forKey: .instructor)
        progress = try values.decode(Int.self, forKey: .progress)
        lessons = try values.decode(Int.self, forKey: .lessons)
        completedLessonIDs = try values.decodeIfPresent(Set<Int>.self, forKey: .completedLessonIDs) ?? []
    }

    mutating func completeLesson(_ lessonID: Int) {
        guard (0..<lessons).contains(lessonID), completedLessonIDs.insert(lessonID).inserted else { return }
        progress = min(100, progress + max(1, Int((100.0 / Double(lessons)).rounded())))
    }
}
