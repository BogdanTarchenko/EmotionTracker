//
//  WelcomeViewControllerUITests.swift
//  EmotionTracker
//
//  Created by Богдан Тарченко on 12.03.2025.
//


import XCTest
@testable import EmotionTracker

final class WelcomeViewControllerUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testWelcomeTitleLabelExists() {
        let welcomeLabels = app.staticTexts
        
        let firstLabel = welcomeLabels.firstMatch
        XCTAssertTrue(firstLabel.exists, "Заголовок приветствия должен быть виден на экране")
    }
    
    func testAppleIDButtonExistsAndTappable() {
        let appleIDButton = app.otherElements["AppleIDButton"]
        XCTAssertTrue(appleIDButton.exists, "Кнопка входа через Apple ID должна быть видна на экране")
        XCTAssertTrue(appleIDButton.isHittable, "Кнопка входа через Apple ID должна быть доступна для нажатия")
        
        appleIDButton.tap()
    }
} 
