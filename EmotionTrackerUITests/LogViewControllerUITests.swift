//
//  LogViewControllerUITests.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 12.03.2025.
//


import XCTest
@testable import EmotionTracker

final class LogViewControllerUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
        let appleIDButton = app.otherElements["AppleIDButton"]
        appleIDButton.tap()
    }
    
    func testMainElementsExist() {
        let navBar = app.otherElements["LogNavBar"]
        XCTAssertTrue(navBar.exists, "Навигационная панель должна быть видна на экране")
        
        let titleLabel = app.staticTexts["LogTitleLabel"]
        XCTAssertTrue(titleLabel.exists, "Заголовок должен быть виден на экране")
        
        let activityRing = app.otherElements["ActivityRingView"]
        XCTAssertTrue(activityRing.exists, "Кольцо активности должно быть видно на экране")
        
        let addButton = app.otherElements["AddNoteButton"]
        XCTAssertTrue(addButton.exists, "Кнопка добавления заметки должна быть видна на экране")
        XCTAssertTrue(addButton.isHittable, "Кнопка добавления заметки должна быть доступна для нажатия")
    }
    
    func testAddNewEmotion() {
        let addButton = app.otherElements["AddNoteButton"]
        addButton.tap()
        
        let addNoteView = app.otherElements["AddNoteView"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: addNoteView, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(addNoteView.exists, "Экран добавления заметки должен появиться")
        
        let emotionCircle = app.otherElements["RedEmotionCircle_0"]
        XCTAssertTrue(emotionCircle.waitForExistence(timeout: 2), "Кружок эмоции должен быть виден")
        emotionCircle.tap()
        
        let nextButton = app.buttons["EmotionPickerButton"]
        XCTAssertTrue(nextButton.waitForExistence(timeout: 2), "Кнопка перехода должна появиться")
        nextButton.tap()
        
        let editNoteView = app.otherElements["EditNoteView"]
        XCTAssertTrue(editNoteView.waitForExistence(timeout: 5), "Экран редактирования должен появиться")
        
        // тут валится тест, не знаю, что не так, ведь я задал идентификатор кнопке
        let saveButton = app.otherElements["SaveNoteButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2), "Кнопка сохранения должна быть видна")
        
        XCTAssertTrue(saveButton.isHittable, "Кнопка сохранения должна быть доступна для нажатия")
        
        saveButton.tap()
        
        let activityRing = app.otherElements["ActivityRingView"]
        XCTAssertTrue(activityRing.waitForExistence(timeout: 5), "Кольцо активности должно быть видно после возврата")
    }
} 
