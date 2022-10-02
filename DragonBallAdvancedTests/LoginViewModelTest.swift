//
//  LoginViewModelTest.swift
//  DragonBallAdvancedTests
//
//  Created by Fran Alarza on 2/10/22.
//

import XCTest
@testable import DragonBallAdvanced

final class LoginViewModelTest: XCTestCase {
    
    private var sut: LoginViewModel!
    private var sutProtocol: LoginViewModelProtocol!
    private var urlSessionMock: URLSessionMock!

    override func setUpWithError() throws {
        urlSessionMock = URLSessionMock()
        sut = LoginViewModel()
        sut.networkManager = NetworkManager(session: URLSessionMock())
        sutProtocol.login(user: "", password: "")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
