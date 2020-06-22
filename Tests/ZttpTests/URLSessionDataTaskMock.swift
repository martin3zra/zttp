//
//  URLSessionDataTaskMock.swift
//  ZttpTests
//
//  Created by Alfredo Martinez on 6/21/20.
//

import Foundation

// We create a partial mock by subclassing the original class
class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}
