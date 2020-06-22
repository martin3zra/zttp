//
//  Notification.swift
//  Zttp
//
//  Created by Alfredo Martinez on 6/14/20.
//

import Foundation

public extension Notification.Name {
    static let zttpRequestStarted = Notification.Name(rawValue: "requestStarted")
    static let zttpRequestFinished = Notification.Name(rawValue: "requestFinished")
}

func dispatch(event: Notification.Name) {
    NotificationCenter.default.post(name: event, object: nil)
}
