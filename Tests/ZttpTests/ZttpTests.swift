import XCTest
@testable import Zttp

final class ZttpTests: XCTestCase {
    
    private var session: URLSessionMock!
    override func setUp() {
        self.session = URLSessionMock()
    }
    
    override func tearDown() {
        self.session = nil
    }
    
    func testQueryParamsCanBePassedAsAnArray() {
        let url = buildURL(status: 200)
        self.session.data = Data("{\"key\":12}".utf8)
        self.session.response = buildHTTPURLResponse(url: url, status: 200)
        
        let expectation = XCTestExpectation(description: "is OK")
        let queryParams: Dictionary<String, Any> = ["foo": "bar", "baz":"quz"]
        
        do {
            let response = try Zttp
                .withSession(session)
                .afterSend(then: {
                    expectation.fulfill()
                })
                .get(url: url.absoluteString, queryParams: queryParams)
            
            wait(for: [expectation], timeout: 10)
            
            guard let dic = response.asDictionary(), let query = dic["query"]  as? Dictionary<String, Any> else {
                XCTFail("header not found")
                return
            }
            
            //Ensure has the same keys and values
            let queries = query.filter { (element: Dictionary<String, Any>.Element) -> Bool in
                return queryParams[element.key] != nil
                    && element.value as? NSObject == queryParams[element.key] as? NSObject
            }
            
            AssertCount(queries, queryParams.count)
        } catch let err {
            XCTFail(err.localizedDescription)
        }
        
    }
    
    func testQueryParametersInUrlsAreRespected() {
        let url = buildURL(status: 200)
        self.session.data = Data("{\"key\":12}".utf8)
        self.session.response = buildHTTPURLResponse(url: url, status: 200)
        
        let expectation = XCTestExpectation(description: "is OK")
        
        do {
            let response = try Zttp
                .withSession(session)
                .afterSend(then: {
                    expectation.fulfill()
                })
                .get(url: url.absoluteString + "?foo=bar&baz=quz")
            
            wait(for: [expectation], timeout: 10)
            
            guard let dic = response.asDictionary(), let query = dic["query"]  as? Dictionary<String, Any> else {
                XCTFail("header not found")
                return
            }
            
            //Ensure has the same keys and values
            let queryParams: Dictionary<String, Any> = ["foo": "bar", "baz":"quz"]
            let queries = query.filter { (element: Dictionary<String, Any>.Element) -> Bool in
                return queryParams[element.key] != nil
                    && element.value as? NSObject == queryParams[element.key] as? NSObject
            }
            
            AssertCount(queries, queryParams.count)
        } catch let err {
            XCTFail(err.localizedDescription)
        }
    }
    
    func testQueryParametersInUrlsCanBeCombinedWithArrayParameters() {
        let url = buildURL(status: 200)
        self.session.data = Data("{\"key\":12}".utf8)
        self.session.response = buildHTTPURLResponse(url: url, status: 200)
        
        let expectation = XCTestExpectation(description: "is OK")
        
        do {
            let response = try Zttp
                .withSession(session)
                .afterSend(then: {
                    expectation.fulfill()
                })
                .get(url: url.absoluteString + "?foo=bar", queryParams: ["baz":"quz"])
            
            wait(for: [expectation], timeout: 10)
            
            guard let dic = response.asDictionary(), let query = dic["query"]  as? Dictionary<String, Any> else {
                XCTFail("header not found")
                return
            }
            
            //Ensure has the same keys and values
            let queryParams: Dictionary<String, Any> = ["foo": "bar", "baz":"quz"]
            let queries = query.filter { (element: Dictionary<String, Any>.Element) -> Bool in
                return queryParams[element.key] != nil
                    && element.value as? NSObject == queryParams[element.key] as? NSObject
            }
            
            AssertCount(queries, queryParams.count)
        } catch let err {
            XCTFail(err.localizedDescription)
        }
    }
    
    func testOptionsCanBeSetAllAtOnce() {
        let url = buildURL(status: 200)
        self.session.data = Data("{\"key\":12}".utf8)
        self.session.response = buildHTTPURLResponse(url: url, status: 200)
        
        let expectation = XCTestExpectation(description: "is OK")
        
        do {
            let response = try Zttp
                .withSession(session)
                .withHeaders(headers: ["Accept" : "text/html"])
                .afterSend(then: {
                    expectation.fulfill()
                })
                .get(url: url.absoluteString)
            
            wait(for: [expectation], timeout: 10)
            
            guard let dic = response.asDictionary(), let headers = dic["headers"]  as? Dictionary<String, Any> else {
                XCTFail("header not found")
                return
            }
            
            //Ensure has the same keys and values
            let headerParams: Dictionary<String, Any> = ["Accept": "text/html"]
            let result = headers.filter { (element: Dictionary<String, Any>.Element) -> Bool in
                return headerParams[element.key] != nil
                    && element.value as? NSObject == headerParams[element.key] as? NSObject
            }
            
            AssertCount(result, headerParams.count)
        } catch let err {
            XCTFail(err.localizedDescription)
        }
    }
    
    func testPostContentIsJsonByDefault() {
        let url = buildURL(status: 200)
        self.session.data = Data("{\"key\":12}".utf8)
        self.session.response = buildHTTPURLResponse(url: url, status: 200)
        
        let expectation = XCTestExpectation(description: "is OK")
        
        do {
            let response = try Zttp
                .withSession(session)
                .afterSend(then: {
                    expectation.fulfill()
                })
                .post(url: url.absoluteString)
            
            wait(for: [expectation], timeout: 10)
            
            guard let dic = response.asDictionary(), let headers = dic["headers"]  as? Dictionary<String, Any> else {
                XCTFail("header not found")
                return
            }
            
            //Ensure has the same keys and values
            let headerParams: Dictionary<String, Any> = ["Content-Type": "application/json"]
            let result = headers.filter { (element: Dictionary<String, Any>.Element) -> Bool in
                return headerParams[element.key] != nil
                    && element.value as? NSObject == headerParams[element.key] as? NSObject
            }
            
            AssertCount(result, headerParams.count)
        } catch let err {
            XCTFail(err.localizedDescription)
        }
    }
    
    func testPostContentCanBeSentAsFormParams() {
        let url = buildURL(status: 200)
        self.session.data = Data("{\"key\":12}".utf8)
        self.session.response = buildHTTPURLResponse(url: url, status: 200)
        
        let expectation = XCTestExpectation(description: "is OK")
        
        do {
            let response = try Zttp
                .withSession(session)
                .asFormParams()
                .afterSend(then: {
                    expectation.fulfill()
                })
                .post(url: url.absoluteString)
            
            wait(for: [expectation], timeout: 10)
            
            guard let dic = response.asDictionary(), let headers = dic["headers"]  as? Dictionary<String, Any> else {
                XCTFail("header not found")
                return
            }
            
            //Ensure has the same keys and values
            let headerParams: Dictionary<String, Any> = ["Content-Type": "application/x-www-form-urlencoded"]
            let result = headers.filter { (element: Dictionary<String, Any>.Element) -> Bool in
                return headerParams[element.key] != nil
                    && element.value as? NSObject == headerParams[element.key] as? NSObject
            }
            
            AssertCount(result, headerParams.count)
        } catch let err {
            XCTFail(err.localizedDescription)
        }
    }
    
    func testTheAcceptHeaderCanBeSetViaShortcut() {
        let url = buildURL(status: 200)
        self.session.data = Data("{\"key\":12}".utf8)
        self.session.response = buildHTTPURLResponse(url: url, status: 200)
        
        let expectation = XCTestExpectation(description: "is OK")
        
        do {
            let response = try Zttp
                .withSession(session)
                .accept(header: "banana/sandwich")
                .afterSend(then: {
                    expectation.fulfill()
                })
                .post(url: url.absoluteString)
            
            wait(for: [expectation], timeout: 10)
            
            guard let dic = response.asDictionary(), let headers = dic["headers"]  as? Dictionary<String, Any> else {
                XCTFail("header not found")
                return
            }
            
            //Ensure has the same keys and values
            let headerParams: Dictionary<String, Any> = ["Accept": "banana/sandwich"]
            let result = headers.filter { (element: Dictionary<String, Any>.Element) -> Bool in
                return headerParams[element.key] != nil
                    && element.value as? NSObject == headerParams[element.key] as? NSObject
            }
            
            AssertCount(result, headerParams.count)
        } catch let err {
            XCTFail(err.localizedDescription)
        }
    }
    
    func testCanCheckIfAResponseIsSuccess() {
        
        let url = buildURL(status: 200)
        self.session.response = buildHTTPURLResponse(url: url, status: 200)
        
        let expectation = XCTestExpectation(description: "is OK")
        
        do {
            let response = try Zttp
                .withSession(session)
                .afterSend(then: {
                    expectation.fulfill()
                })
                .get(url: url.absoluteString)
            
            wait(for: [expectation], timeout: 10)
            
            XCTAssert(response.isOk())
            XCTAssertFalse(response.isClientError())
            XCTAssertFalse(response.isServerError())
            
        } catch let err {
            XCTFail(err.localizedDescription)
        }
        
    }
    
    func testCanCheckIfAResponseIsClientError() {
        
        let url = buildURL(status: 404)
        self.session.response = buildHTTPURLResponse(url: url, status: 404)
        
        let expectation = XCTestExpectation(description: "is Client Error")
        
        do {
            let response = try Zttp
                .withSession(session)
                .afterSend(then: {
                    expectation.fulfill()
                })
                .get(url: url.absoluteString)
            
            wait(for: [expectation], timeout: 10)
            
            XCTAssert(response.isClientError())
            XCTAssertFalse(response.isSuccess())
            XCTAssertFalse(response.isServerError())
            
        } catch let err {
            XCTFail(err.localizedDescription)
        }
        
    }
    
    func testCanCheckIfAResponseIsServerError() {
        
        let url = buildURL(status: 500)
        self.session.response = buildHTTPURLResponse(url: url, status: 500)
        
        let expectation = XCTestExpectation(description: "is Server Error")
        
        do {
            let response = try Zttp
                .withSession(session)
                .afterSend(then: {
                    expectation.fulfill()
                })
                .get(url: url.absoluteString)
            
            wait(for: [expectation], timeout: 10)
            
            XCTAssert(response.isServerError())
            XCTAssertFalse(response.isSuccess())
            XCTAssertFalse(response.isClientError())
            
        } catch let err {
            XCTFail(err.localizedDescription)
        }
        
    }
    
    func testIsOkIsAnAliasForIsSuccess() {
        
        let url = buildURL(status: 200)
        self.session.response = buildHTTPURLResponse(url: url, status: 200)
        
        let expectation = XCTestExpectation(description: "is Success")
        
        do {
            let response = try Zttp
                .withSession(session)
                .afterSend(then: {
                    expectation.fulfill()
                })
                .get(url: url.absoluteString)
            
            wait(for: [expectation], timeout: 10)
            
            XCTAssert(response.isOk())
            XCTAssert(response.isSuccess())
            XCTAssertFalse(response.isServerError())
            XCTAssertFalse(response.isClientError())
            
        } catch let err {
            XCTFail(err.localizedDescription)
        }
        
    }
    
    func testMultipleCallbacksCanBeRunBeforeSendingTheRequest() {
        
        let url = buildURL(status: 200)
        self.session.response = buildHTTPURLResponse(url: url, status: 200)
        
        let expectation = XCTestExpectation(description: "is Success")
        var states : [String :String] = [:]
        
        do {
            let response = try Zttp
                .withSession(session)
                .afterSend(then: {
                    states["url"] = url.absoluteString
                })
                .afterSend(then: {
                    states["bananas"] = "Yellows"
                    expectation.fulfill()
                })
                .get(url: url.absoluteString)
            
            wait(for: [expectation], timeout: 10)
            
            XCTAssert(response.isOk())
            XCTAssertEqual(url.absoluteString, states["url"])
            XCTAssertEqual("Yellows", states["bananas"])
            
        } catch let err {
            XCTFail(err.localizedDescription)
        }
        
    }
    
    func buildHTTPURLResponse (url: URL, status: Int) -> HTTPURLResponse? {
        return HTTPURLResponse(url: url , statusCode: status, httpVersion: nil, headerFields: nil)
    }
    
    func buildURL(status: Int) -> URL {
        return URL(string: "https://httpbin.org/status/\(status)")!
    }
    
    static var allTests = [
        ("testQueryParamsCanBePassedAsAnArray", testQueryParamsCanBePassedAsAnArray),
        ("testQueryParametersInUrlsAreRespected", testQueryParametersInUrlsAreRespected),
        ("testQueryParametersInUrlsCanBeCombinedWithArrayParameters", testQueryParametersInUrlsCanBeCombinedWithArrayParameters),
        ("testOptionsCanBeSetAllAtOnce", testOptionsCanBeSetAllAtOnce),
        ("testPostContentIsJsonByDefault", testPostContentIsJsonByDefault),
        ("testPostContentCanBeSentAsFormParams", testPostContentCanBeSentAsFormParams),
        ("testTheAcceptHeaderCanBeSetViaShortcut", testTheAcceptHeaderCanBeSetViaShortcut),
        ("testCanCheckIfAResponseIsSuccess", testCanCheckIfAResponseIsSuccess),
        ("testCanCheckIfAResponseIsClientError", testCanCheckIfAResponseIsClientError),
        ("testCanCheckIfAResponseIsServerError", testCanCheckIfAResponseIsServerError),
        ("testIsOkIsAnAliasForIsSuccess", testIsOkIsAnAliasForIsSuccess),
        ("testMultipleCallbacksCanBeRunBeforeSendingTheRequest", testMultipleCallbacksCanBeRunBeforeSendingTheRequest)
    ]
    
    func AssertCount<C>(_ collection: C?, _ count: Int) where C: Collection {
        XCTAssertEqual(collection?.count, count)
    }
}

extension Array where Element: Equatable {
    func contains(array: [Element]) -> Bool {
        for item in array {
            if !self.contains(item) { return false }
        }
        return true
    }
}
