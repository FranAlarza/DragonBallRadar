//
//  NetworkManagerTests.swift
//  DragonBallAdvancedTests
//
//  Created by Fran Alarza on 26/9/22.
//

import XCTest
@testable import DragonBallAdvanced

enum MockError: Error {
    case mockError
}

final class NetworkManagerTests: XCTestCase {
    
    private var urlSessionMock: URLSessionMock!
    private var sut: NetworkManager!
    
    override func setUpWithError() throws {
        urlSessionMock = URLSessionMock()
        sut = NetworkManager(session: urlSessionMock)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    // MARK: - LOGIN FUNCTION TESTS
    func testLoginSucces() throws {
        var mockToken: String?
        // GIVEN
        urlSessionMock.data = "Token".data(using: .utf8)
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        // WHEN
        
        sut.login(name: "", password: "") { result in
            switch result {
            case .success(let token):
                mockToken = token!
            case .failure(_): break
                
            }
        }
        
        // THEN
        XCTAssertEqual(mockToken, "Token")
    }
    
    func testLoginWithNoData() {
        // GIVEN
        var error: NetworkError?
        var data: String?
        urlSessionMock.data = nil
        
        // WHEN
        sut.login(name: "", password: "") { result in
            switch result {
            case .success(let responseData):
                data = responseData!
            case .failure(let responseError):
                error = responseError
            }
        }
        // THEN
        XCTAssertEqual(error, .dataError)
        XCTAssertNil(data)
    }
    
    func testLoginWithResponseError() {
        // GIVEN
        var token: String?
        var error: NetworkError?
        urlSessionMock.data = "token".data(using: .utf8)
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!,
                                                  statusCode: 404,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        
        // WHEN
        sut.login(name: "", password: "") { result in
            switch result {
            case .success(let retrievedToken):
                token = retrievedToken
            case .failure(let responseError):
                error = responseError
            }
        }
        
        // THEN
        XCTAssertEqual(error, .responseError)
        XCTAssertNil(token)
    }
    
    func testLoginWithError() {
        // GIVEN
        var token: String?
        var error: NetworkError?
        urlSessionMock.data = "token".data(using: .utf8)
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        urlSessionMock.error = MockError.mockError
        
        // WHEN
        sut.login(name: "", password: "") { result in
            switch result {
            case .success(let retrievedToken):
                token = retrievedToken
            case .failure(let responseError):
                error = responseError
            }
        }
        
        // THEN
        XCTAssertEqual(error, .requestError)
        XCTAssertNil(token)
    }
    
    // MARK: - FETCH DRAGON BALL DATA FUNCTION TESTS
    
    func testWithCharacters() {
        let token = "Mock Token"
        var retrievedError: NetworkError?
        var retrievedHeroes: [Hero] = []
        // GIVEN
        urlSessionMock.data = getData(resource: "heroes")
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        // WHEN
        
        sut.fetchDragonBallData(from: "http",
                                requestBody: nil,
                                token: token,
                                type: [Hero].self) { result in
            switch result {
            case .success(let heroes):
                retrievedHeroes = heroes!
            case .failure(let error):
                retrievedError = error
            }
        }
        // THEN
        //XCTAssertNil(retrievedHeroes)
        XCTAssertEqual(retrievedHeroes.count, 2)
        
    }
    
}

extension NetworkManagerTests {
    func getData(resource: String) -> Data? {
        let bundle = Bundle(for: NetworkManagerTests.self)
        
        guard let path = bundle.path(forResource: resource, ofType: "json") else { return nil }
        
        return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        
    }
}
