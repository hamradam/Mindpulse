//
//  MindPulseUITests.swift
//  MindPulseUITests
//
//  Created by Adam Hamr on 27.01.2026.
//

import XCTest

final class MindPulseUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Note: Copy of AccessibilityTag to ensure visibility in UI Tests without target membership changes
    enum AccessibilityTag: String {
        // Navigation
        case activitiesTab
        case statisticsTab
        
        // ContentView
        case newActivityButton
        case settingsButton
        
        // SettingView
        case settingThemeButton
        
        // ThemeSelector
        case themeSelectorCloseButton
        case themeOptionTwilightBloom
        case themeOptionCalmDawn
        
        // NewActivityView
        case newActivityCloseButton
        case newActivitySaveButton
        case newActivityNameField
        case newActivityHRToggle
    }


    @MainActor
    func testTabBarNavigation() throws {
        let app = XCUIApplication()
        app.launch()
        
        let activitiesTab = app.tabBars.buttons[AccessibilityTag.activitiesTab.rawValue]
        let statisticsTab = app.tabBars.buttons[AccessibilityTag.statisticsTab.rawValue]
        
        // Assert initial state (Activities tab selected)
        XCTAssertTrue(activitiesTab.isSelected)
        
        // Switch to Statistics
        statisticsTab.tap()
        XCTAssertTrue(statisticsTab.isSelected)
        
        // Switch back
        activitiesTab.tap()
        XCTAssertTrue(activitiesTab.isSelected)
    }
    
    @MainActor
    func testThemeChange() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Go to Settings
        let settingsButton = app.buttons[AccessibilityTag.settingsButton.rawValue]
        XCTAssertTrue(settingsButton.exists)
        settingsButton.tap()
        
        // Open Theme Selector
        let themeButton = app.buttons[AccessibilityTag.settingThemeButton.rawValue]
        XCTAssertTrue(themeButton.exists)
        themeButton.tap()
        
        // Select Twilight Bloom (Dark)
        let twilightOption = app.otherElements[AccessibilityTag.themeOptionTwilightBloom.rawValue] // Grid items might be "other" or "button" depending on content shape. Using generic query or specific type if known.
        // It has .onTapGesture, so it might not be a standard button unless .accessibilityAddTraits(.isButton) is used.
        // Let's try finding it. Since it matches identifier, standard finding works.
        // But wait, .onTapGesture doesn't automatically make it a button in accessibility tree often.
        // However, I used .accessibilityIdentifier() on the view. Accessing via app.descendants(matching: .any)[id] is safest.
        
        let twilightElement = app.descendants(matching: .any)[AccessibilityTag.themeOptionTwilightBloom.rawValue]
        XCTAssertTrue(twilightElement.waitForExistence(timeout: 2))
        twilightElement.tap()
        
        // Select Calm Dawn (Light)
        let calmDawnElement = app.descendants(matching: .any)[AccessibilityTag.themeOptionCalmDawn.rawValue]
        XCTAssertTrue(calmDawnElement.exists)
        calmDawnElement.tap()
        
        // Close
        let closeButton = app.buttons[AccessibilityTag.themeSelectorCloseButton.rawValue]
        XCTAssertTrue(closeButton.exists)
        closeButton.tap()
    }
    
    @MainActor
    func testNewActivitySheet() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Open New Activity Sheet
        let newActivityButton = app.buttons[AccessibilityTag.newActivityButton.rawValue]
        XCTAssertTrue(newActivityButton.exists)
        newActivityButton.tap()
        
        // Check elements in sheet
        let saveButton = app.buttons[AccessibilityTag.newActivitySaveButton.rawValue]
        let closeButton = app.buttons[AccessibilityTag.newActivityCloseButton.rawValue]
        let nameField = app.textFields[AccessibilityTag.newActivityNameField.rawValue]
        let hrToggle = app.switches[AccessibilityTag.newActivityHRToggle.rawValue] // Toggle appears as switch
        
        XCTAssertTrue(saveButton.exists)
        XCTAssertTrue(closeButton.exists)
        XCTAssertTrue(nameField.exists)
        XCTAssertTrue(hrToggle.exists)
        
        // Type name
        nameField.tap()
        nameField.typeText("UITest Activity")
        
        // Toggle HR
        hrToggle.tap()
        
        // Close (Cancel)
        closeButton.tap()
        
        // Verify sheet is dismissed (Save and Close buttons should disappear)
        XCTAssertFalse(saveButton.exists)
    }
}
