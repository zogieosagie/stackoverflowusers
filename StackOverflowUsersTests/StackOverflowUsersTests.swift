//
//  StackOverflowUsersTests.swift
//  StackOverflowUsersTests
//
//  Created by Osagie Zogie-Odigie on 20/11/2019.
//  Copyright © 2019 Osagie Zogie-Odigie. All rights reserved.
//

import XCTest
@testable import StackOverflowUsers

class StackOverflowUsersTests: XCTestCase {

    
    var systemUnderTest: StackOverflowUsersViewModel!
    
    override func setUp() {
        
      super.setUp()
      systemUnderTest = StackOverflowUsersViewModel()
      systemUnderTest.stackOverflowUsers = mockStackOverflowUsers()
    }
    
    override func tearDown() {
      systemUnderTest = nil
      super.tearDown()
    }
    
    func testUserBlocking(){
        
        systemUnderTest.blockUserRequest(forItem: 0)
        XCTAssertTrue(systemUnderTest.blockedStatus(forCellAtIndex: 0), "Expected Blocked Status for user to be true")
    }
    
    func testFollowUser(){
        
        systemUnderTest.followUserRequest(forItem: 0)
        XCTAssertTrue(systemUnderTest.followStatus(forCellAtIndex: 0), "Expected follow Status for user to be true")
    }
    
    func testUnFollowUser(){
        
        systemUnderTest.unFollowUserRequest(forItem: 0)
        XCTAssertFalse(systemUnderTest.followStatus(forCellAtIndex: 0), "Expected follow Status for user to be false")
    }
    
    func testExpandRequest(){
        
        systemUnderTest.expandCollapseRequest(forItem: 0)
        XCTAssertTrue(systemUnderTest.expandedStatus(forCellAtIndex: 0), "Expected expand status to be true")
    }
    
    func testExpandCollapseRequest(){
        systemUnderTest.expandCollapseRequest(forItem: 0)
        systemUnderTest.expandCollapseRequest(forItem: 0)
        XCTAssertFalse(systemUnderTest.expandedStatus(forCellAtIndex: 0), "Expected expand status to be false")
    }
    
    func testBlockUserForcesCollapse(){
        
        systemUnderTest.expandCollapseRequest(forItem: 0)
        XCTAssertTrue(systemUnderTest.expandedStatus(forCellAtIndex: 0), "Expected expand status to be true")
        
        systemUnderTest.blockUserRequest(forItem: 0)
        XCTAssertTrue(systemUnderTest.blockedStatus(forCellAtIndex: 0), "Expected Blocked Status for user to be true")
        XCTAssertFalse(systemUnderTest.expandedStatus(forCellAtIndex: 0), "Expected expand status to be false")
    }
    
    func mockStackOverflowUsers() -> [StackOverflowUser] {
        let jsonString = """
        {
            "display_name": "Jon Skeet",
            "profile_image": "https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=128&d=identicon&r=PG",
            "reputation": 1146196
        }
        """

        let jsonData = jsonString.data(using: .utf8)!
        let mockUser = try! JSONDecoder().decode(StackOverflowUser.self, from: jsonData)
        let mockUsers = [mockUser]
        
        return mockUsers
    }

}
