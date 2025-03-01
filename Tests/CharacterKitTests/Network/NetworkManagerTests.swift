//
//  NetworkManagerTests.swift
//
//
//  Created by Tes on 01/03/2025.
//

import Foundation
import XCTest
@testable import CharacterKit

final class NetworkManagerTests: XCTestCase {
    func testFetchWithValidURL() {
        // Given
        let expectation = expectation(description: "Fetch data from URL")
        let session = MockURLSession()
        let networkManager = NetworkManager(session: session)
        let url = URL(string: "https://example.com")!
        
        let jsonData = """
        {
            "id": 1,
            "name": "Rick"
        }
        """.data(using: .utf8)!
        
        session.data = jsonData
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // When
        networkManager.fetch(from: url) { (result: Result<TestModel, NetworkError>) in
            // Then
            switch result {
            case .success(let model):
                XCTAssertEqual(model.id, 1)
                XCTAssertEqual(model.name, "Rick")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchWithNetworkError() {
        // Given
        let expectation = expectation(description: "Fetch data with network error")
        let session = MockURLSession()
        let networkManager = NetworkManager(session: session)
        let url = URL(string: "https://example.com")!
        
        let error = NSError(domain: "test", code: 1, userInfo: nil)
        session.error = error
        
        // When
        networkManager.fetch(from: url) { (result: Result<TestModel, NetworkError>) in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let networkError):
                if case .requestFailed(let underlyingError) = networkError {
                    XCTAssertEqual((underlyingError as NSError).code, error.code)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected requestFailed error but got \(networkError)")
                }
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchWithInvalidResponse() {
        // Given
        let expectation = expectation(description: "Fetch data with invalid response")
        let session = MockURLSession()
        let networkManager = NetworkManager(session: session)
        let url = URL(string: "https://example.com")!
        
        session.data = Data()
        session.response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        // When
        networkManager.fetch(from: url) { (result: Result<TestModel, NetworkError>) in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let networkError):
                XCTAssertEqual(networkError, .invalidResponse)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchWithDecodingError() {
        // Given
        let expectation = expectation(description: "Fetch data with decoding error")
        let session = MockURLSession()
        let networkManager = NetworkManager(session: session)
        let url = URL(string: "https://example.com")!
        
        let invalidJsonData = "invalid json".data(using: .utf8)!
        session.data = invalidJsonData
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // When
        networkManager.fetch(from: url) { (result: Result<TestModel, NetworkError>) in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let networkError):
                if case .decodingFailed = networkError {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected decodingFailed error but got \(networkError)")
                }
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchWithInvalidURL() {
        // Given
        let expectation = expectation(description: "Fetch data with invalid URL string")
        let networkManager = NetworkManager()
        let invalidURLString = "invalid url"
        
        // When
        networkManager.fetch(from: invalidURLString) { (result: Result<TestModel, NetworkError>) in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let networkError):
                XCTAssertEqual(networkError, .invalidURL)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    private struct TestModel: Decodable {
        let id: Int
        let name: String
    }
}

// Mock URLSession for testing
class MockURLSession: URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask {
            completionHandler(self.data, self.response, self.error)
        }
    }
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask {
            completionHandler(self.data, self.response, self.error)
        }
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}
