//
//  StackOverflowUsersNetworkTests.swift
//  StackOverflowUsersNetworkTests
//
//  Created by Osagie Zogie-Odigie on 25/11/2019.
//  Copyright © 2019 Osagie Zogie-Odigie. All rights reserved.
//

import XCTest
@testable import StackOverflowUsers

class StackOverflowUsersNetworkTests: XCTestCase {

    var systemUnderTest: URLSession!
    
    override func setUp() {
      super.setUp()
      systemUnderTest = URLSession(configuration: .default)
    }
    
    override func tearDown() {
      systemUnderTest = nil
      super.tearDown()
    }

}
