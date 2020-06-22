//
//  URLSessionMock.swift
//  ZttpTests
//
//  Created by Alfredo Martinez on 6/21/20.
//

import Foundation

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    // Properties that enable us to set exactly what data or error
    // we want our mocked URLSession to return for any request.
    var data: Data?
    var error: Error?
    var response: HTTPURLResponse?

    override func dataTask(
        with request: URLRequest,
        completionHandler: @escaping CompletionHandler
    ) -> URLSessionDataTask {
        var data = self.data
        let error = self.error
        let response = self.response
        
        var queries : [String: Any] = [:]
        let queriesString = request.url?.query?.components(separatedBy: "&")
        queriesString?.forEach({ (item) in
            let queryItem = item.components(separatedBy: "=")
            if queryItem.count == 2 {
                queries[queryItem[0]] = queryItem[1]
            }
        })
        
        let components: Dictionary<String, Any> = [
            "data": data?.toDictionary as Any,
            "headers": request.allHTTPHeaderFields as Any,
            "query": queries
        ]
        
        data = components.toJSON

        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }
}
