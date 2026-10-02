import XCTest
@testable import LearningDashboard

final class CourseTests: XCTestCase {
    func testCompletingLessonChangesProgressOnlyOnce() {
        var course = Course(id: 1, title: "Python", instructor: "A", progress: 65, lessons: 20)
        course.completeLesson(2)
        XCTAssertEqual(course.progress, 70)
        XCTAssertTrue(course.completedLessonIDs.contains(2))
        course.completeLesson(2)
        XCTAssertEqual(course.progress, 70)
    }
}
