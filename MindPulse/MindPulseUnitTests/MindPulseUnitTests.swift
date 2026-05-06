//
//  ActivitiesViewModelTests.swift
//  MindPulseUnitTests
//
//  Created by Adam Hamr on 27.01.2026.
//

import XCTest
@testable import MindPulse

final class ActivitiesViewModelTests: XCTestCase {
    
    private var dataManagerMock: DataManagerMock!
    private var watchConnectorMock: WatchConnectorMock!
    private var sut: ActivitiesViewModel!

    override func setUp() async throws {
        try await super.setUp()
        
        dataManagerMock = DataManagerMock()
        watchConnectorMock = WatchConnectorMock()
        
        await MainActor.run {
            DIContainer.shared.register(DataManaging.self, cached: true) { [unowned self] in
                self.dataManagerMock
            }
            
            DIContainer.shared.register(WatchConnecting.self, cached: true) { [unowned self] in
                self.watchConnectorMock
            }
            
            // Initialize System Under Test
            sut = ActivitiesViewModel()
        }
    }

    override func tearDown() async throws {
        sut = nil
        dataManagerMock = nil
        watchConnectorMock = nil
        // Ideally, we should reset DIContainer, but it doesn't have a reset method exposed. 
        // Given factory pattern usage, we just re-register in next setUp.
        try await super.tearDown()
    }

    func testFetchActivities() async {
        // Arrange
        let activities = [
            ActivityModel(id: UUID(), name: "Run", emoji: "🏃", color: .blue, hrRecording: true),
            ActivityModel(id: UUID(), name: "Sleep", emoji: "😴", color: .green, hrRecording: false)
        ]
        dataManagerMock.fetchAllActivitiesReturnValue = activities
        

        
        await MainActor.run {
            sut.fetchActivities()
        }
        
        
        XCTAssertTrue(dataManagerMock.fetchAllActivitiesCalled)
        let stateActivities = await MainActor.run { sut.state.activities }
        XCTAssertEqual(stateActivities.count, 2)
        XCTAssertEqual(stateActivities.first?.name, "Run")
        
        XCTAssertTrue(watchConnectorMock.sendActivityCalled)
    }

    func testAddActivity() async {

        let newActivity = ActivityModel(id: UUID(), name: "Yoga", emoji: "🧘", color: .purple, hrRecording: true)
        
        // Act
        await MainActor.run {
            sut.addActivity(newActivity: newActivity)
        }
        
        // Assert
        XCTAssertTrue(dataManagerMock.addActivityCalled)
        XCTAssertEqual(dataManagerMock.addedActivity?.id, newActivity.id)
        
        XCTAssertTrue(watchConnectorMock.sendActivityCalled)
        XCTAssertEqual(watchConnectorMock.sentActivity?.id, newActivity.id)
    }
    
    func testDeleteActivity() async {
        // Arrange
        let activityId = UUID()
        dataManagerMock.deleteActivityReturnValue = true
        
        // Act
        await MainActor.run {
            sut.deleteActivity(activityId: activityId)
        }
        
        // Assert
        XCTAssertTrue(dataManagerMock.deleteActivityCalled)
        XCTAssertEqual(dataManagerMock.deletedActivityId, activityId)
        
        XCTAssertTrue(watchConnectorMock.deleteActivityCalled)
        XCTAssertEqual(watchConnectorMock.deletedActivityId, activityId)
        
        // It should also fetch activities after delete
        XCTAssertTrue(dataManagerMock.fetchAllActivitiesCalled)
    }
}


