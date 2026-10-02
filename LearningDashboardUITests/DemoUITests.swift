import XCTest

final class DemoUITests: XCTestCase {
    func testDemoFlow() {
        let app = XCUIApplication()
        app.launchArguments = ["-resetDemoCache"]
        app.launch()

        let email = app.textFields["Email"]
        XCTAssertTrue(email.waitForExistence(timeout: 5))
        email.tap()
        email.typeText("demo@example.com")

        let password = app.secureTextFields["Password"]
        password.tap()
        password.typeText("demo123")
        app.buttons["loginButton"].tap()

        let course = app.staticTexts["Python Programming"]
        XCTAssertTrue(course.waitForExistence(timeout: 5))
        course.tap()
        XCTAssertTrue(app.staticTexts["Progress: 65%"].waitForExistence(timeout: 5))
        app.buttons.containing(.staticText, identifier: "Introduction").firstMatch.tap()
        XCTAssertTrue(app.staticTexts["Progress: 70%"].waitForExistence(timeout: 5))

        app.navigationBars.buttons["Offline"].tap()
        XCTAssertTrue(app.navigationBars.buttons["Offline cache"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["70% complete · 20 lessons"].waitForExistence(timeout: 5))

        // Relaunch to show the progress comes from local storage.
        app.terminate()
        app.launchArguments = []
        app.launch()
        let emailAgain = app.textFields["Email"]
        XCTAssertTrue(emailAgain.waitForExistence(timeout: 5))
        emailAgain.tap()
        emailAgain.typeText("demo@example.com")
        let passwordAgain = app.secureTextFields["Password"]
        passwordAgain.tap()
        passwordAgain.typeText("demo123")
        app.buttons["loginButton"].tap()
        let savedCourse = app.staticTexts["70% complete · 20 lessons"]
        XCTAssertTrue(savedCourse.waitForExistence(timeout: 5))
    }
}
