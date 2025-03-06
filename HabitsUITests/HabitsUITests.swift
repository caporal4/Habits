//
//  HabitsUITests.swift
//  HabitsUITests
//
//  Created by Brendan Caporale on 3/1/25.
//

import XCTest

final class HabitsUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }
    
    func testAppHasBasicButtonsOnLaunch() throws {
        XCTAssertTrue(app.navigationBars.buttons["Add Habit"].exists, "There should be a Add Habit button.")
    }
    
    func testNoHabitsAtStart() {
        XCTAssertEqual(app.cells.count, 0, "There should be no list rows initially.")
    }
    
    func testAddingAndDeletingHabitsWorks() {
        app.buttons["Add Habit"].tap()
        app.textFields["Enter the habit title here"].tap()
        app.typeText("New Habit")
        app.textFields["Amount"].tap()
        app.typeText("1")
        app.buttons["Save"].tap()
        XCTAssertEqual(app.cells.count, 1, "There should be 1 row after habit is saved.")
        
        app.buttons["New Habit"].tap()
        XCTAssertTrue(app.navigationBars.buttons["Habits"].exists, "There should be a Habits button.")
        XCTAssertTrue(app.navigationBars.buttons["Edit Habit"].exists, "There should be a Edit Habit button.")
        XCTAssertTrue(app.navigationBars.buttons["Delete Habit"].exists, "There should be a Delete Habit button.")
        XCTAssertTrue(app.buttons["Complete Task"].exists, "There should be a Complete Task button.")
        XCTAssertTrue(app.buttons["Undo Task"].exists, "There should be a Undo Task button.")
        
        app.buttons["Delete Habit"].tap()
        XCTAssertTrue(app.buttons["Cancel"].exists, "There should be a Cancel button.")
        XCTAssertTrue(app.buttons["Delete"].exists, "There should be a Cancel button.")
        app.buttons["Delete"].tap()
        XCTAssertEqual(app.cells.count, 0, "There should be 0 rows after habit is deleted.")
    }
    
    func testSwipeToDeleteWorks() {
        app.buttons["ADD SAMPLES"].tap()
        
        for tapCount in (0...4).reversed() {
            app.cells.firstMatch.swipeLeft()
            app.buttons["Delete"].tap()

            XCTAssertEqual(app.cells.count, tapCount, "There should be \(tapCount) rows in the list.")
        }
    }
    
    func testTextIsVisible() {
        let myLabel = app.staticTexts["Habits"]
        XCTAssertEqual("Habits", myLabel.label)
    }
    
    func testEditingHabits() {
        app.buttons["Add Habit"].tap()
        app.textFields["Enter the habit title here"].tap()
        app.typeText("New Habit")
        app.textFields["Amount"].tap()
        app.typeText("1")
        app.buttons["Save"].tap()
        
        app.buttons["New Habit"].tap()
        app.buttons["Edit Habit"].tap()
        app.textFields["Enter the habit title here"].tap()
        app.typeText("Edited ")
        app.buttons["Save"].tap()
        
        app.buttons["Habits"].tap()
        let myLabel = app.staticTexts["Edited New Habit"]
        XCTAssertEqual("Edited New Habit", myLabel.label)
    }
}
