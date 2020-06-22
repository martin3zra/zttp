//
//  ZttpResponse.swift
//  Zttp
//
//  Created by Alfredo Martinez on 6/15/20.
//

import Foundation

public class ZttpResponse {
    private let response : HTTPURLResponse?
    private let data: Data?
    private let error: Error?
    
    init() {
        self.response = nil
        self.data = nil
        self.error = nil
    }
    
    init(response: HTTPURLResponse?, data: Data?, error: Error?) {
        self.response = response
        self.data = data
        self.error = error
    }
    
    func header(key : String) -> String? {
        
        return self.response?.allHeaderFields[key] as? String
    }
    
    func headers() -> [String : Any]? {
        
        return self.response?.allHeaderFields as? [String: Any]
    }
    
    public func status() -> Int {
        if response == nil {
            return 0
        }
        
        return response!.statusCode
    }
    
    public func isSuccess() -> Bool {
        return status() >= 200 && status() < 300
    }
    
    public func isOk() -> Bool {
        return isSuccess()
    }
    
    public func isRedirect() -> Bool {
        return status() >= 300 && status() < 400
    }
    
    public func isClientError() -> Bool {
        return status() >= 400 && status() < 500
    }
    
    public func isUnauthorized() -> Bool {
        return status() == 401
    }
    
    public func isForbidden() -> Bool {
        return status() == 403
    }
    
    public func isServerError() -> Bool {
        return status() >= 500
    }
    
    public func toString() -> String? {
        guard let data = self.data else { return nil }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    public func body() -> Data? {
        return self.data
    }
    
    public func asDictionary() -> NSDictionary? {
        return self.data?.toDictionary
    }
    
    public func decode<T: Decodable>() throws -> T {
        guard let data = self.body() else {
            throw ZttpException(.DataCannotBeDecode)
        }
        
        return try data.decoded() as T
    }
    
    public func `throw`() throws -> ZttpException? {
        
        if self.isOk() {
            return nil
        }
        
        if self.status() == 0 {
            throw ZttpException(.InternalServerError)
        }
        
        throw ZttpException(for: self.status())
    }
}
