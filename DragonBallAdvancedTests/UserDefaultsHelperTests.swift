//
//  UserDefaultsHelperTests.swift
//  UserDefaultsHelperTests
//
//  Created by Fran Alarza on 6/9/22.
//

import XCTest
@testable import DragonBallAdvanced

class UserDefaultsHelperTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        UserDefaultsHelper.deleteItem(key: .tutorial)
    }

    func testSaveItems() throws {
        let item = true
        UserDefaultsHelper.saveItems(item: item, key: .tutorial)
        guard let result = UserDefaultsHelper.getItems(key: .tutorial) as? Bool else { return }
        XCTAssertTrue(result)
        
    }
    


}
