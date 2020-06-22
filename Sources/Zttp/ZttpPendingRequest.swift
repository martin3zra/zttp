//
//  ZttpPendingRequest.swift
//  Zttp
//
//  Created by Alfredo Martinez on 6/15/20.
//

import Foundation

/// `ZttpPendingRequest` create and manages Zttp `Request` types during their lifetimes.
public class ZttpPendingRequest {
    // MARK: - PROPERTIES
    /// Shared a singleton instance used by all `ZttpPendingRequest` APIs. Cannot be modified.
    public static let `default` = ZttpPendingRequest()
    /// Options hold all the option used on the current `Request` such headers, queryItems, body.
    private var options : [String: Any] = [:]
    /// needDebug indicate if the current `Request` need to be debugged in the console.
    private var needDebug : Bool = false
    /// ContentType indicate the type of `Request` that will be perfomed, his values can be `application/json`, `application/x-www-form-urlencoded`, `multipart/mixed`
    private var contentType: RequestContentType = .json
    
    private var urlSession: URLSession = .shared
    
    private var beforeSendCallbacks: [() -> Void] = []
    private var afterSendCallbacks: [() -> Void] = []
    // MARK: - OPTIONS
    
    public func withSession(_ urlSession: URLSession) -> ZttpPendingRequest {
        let this = ZttpPendingRequest.default
        this.urlSession = urlSession
        return ZttpPendingRequest.default
    }
    
    /// Debug current `Request` when the aplication is running in debug mode.
    /// - Returns: A new instance of `ZttpPendingRequest`.
    public func debug() -> ZttpPendingRequest {
        needDebug = true
        return ZttpPendingRequest.default
    }
    
    /// asJSON set the `Content-Type` header of the curren `Request` as `application/json`
    /// - Returns: A new instance of `ZttpPendingRequest`.
    public func asJSON() -> ZttpPendingRequest {
        let this = ZttpPendingRequest.default
        this.contentType = .json
        return this.withHeader(headers: ["Content-Type" : "application/json"])
    }
    
    /// asFormParams set the `Content-Type` header of the current `Request` as `application/x-www-form-urlencoded`
    /// - Returns: A new instance of `ZttpPendingRequest`.
    public func asFormParams() -> ZttpPendingRequest
    {
        let this = ZttpPendingRequest.default
        this.contentType = .formData
        return this.withHeader(headers: ["Content-Type" : "application/x-www-form-urlencoded"])
    }
    
    /// accept set the `Accept` header of the current `Request` equal to the given value.
    /// - Parameters:
    ///    - header: `String` value to be use as the `Accept` header of the `Request`
    /// - Returns: A new instance of `ZttpPendingRequest`.
    public func accept(header: String) -> ZttpPendingRequest {
        return withHeader(headers: ["Accept" : header])
    }
    
    /// withHeader set the header values of the current `Request` equal to the given values.
    /// - Parameters:
    ///    - headers: `[String: String]` values to be use as the headers of the `Request`
    /// - Returns: A new instance of `ZttpPendingRequest`.
    public func withHeader(headers: [String: String]) -> ZttpPendingRequest {
        let this = ZttpPendingRequest.`default`
        
        if var _headers = this.options["header"] as? [String: String] {
            _headers.merge(dict: headers)
            this.options["header"] = _headers
        } else {
            this.options["header"] = headers
        }
        
        return this
    }
    
    // MARK: - HTTP METHODS
    
    /// Perform a `Request` to the given `URL` using `GET` as `HTTPMethod`.
    /// - Parameters:
    ///    - url: `String` value that represent the full URL that the `Request` will be hitting.
    ///    - queryParams: `QueryItem` (a.k.a. `[String: Any]`) to be encoded into the `URLRequest`. `nil` by default.
    /// - Returns: A new instance of `ZttpResponse`.
    public func get(
        url: String,
        queryParams: Dictionary<String, Any>? = nil
    ) throws -> ZttpResponse {
        return try ZttpPendingRequest.`default`.send(
            method: "GET",
            urlString: url,
            options: ["query": queryParams ?? [] as Any]
        )
    }
    
    /// Perform a `Request` to the given `URL` using `POST` as `HTTPMethod`.
    /// - Parameters:
    ///    - url: `String` value that represent the full URL that the `Request` will be hitting.
    ///    - params: `Parameters` (a.k.a. `[String: Any]`) to be encoded into the `URLRequest`. as body, `nil` by default.
    /// - Returns: A new instance of `ZttpResponse`.
    public func post(
        url: String,
        params: Dictionary<String, Any>? = nil
    ) throws -> ZttpResponse {
        return try ZttpPendingRequest.`default`.send(
            method: "POST",
            urlString: url,
            options: ["body": params ?? [] as Any]
        )
    }
    
    /// Perform a `Request` to the given `URL` using `PATCH` as `HTTPMethod`.
    /// - Parameters:
    ///    - url: `String` value that represent the full URL that the `Request` will be hitting.
    ///    - params: `Parameters` (a.k.a. `[String: Any]`) to be encoded into the `URLRequest`. as body, `nil` by default.
    /// - Returns: A new instance of `ZttpResponse`.
    public func patch(
        url: String,
        params: Dictionary<String, Any>? = nil
    ) throws -> ZttpResponse {
        return try ZttpPendingRequest.`default`.send(
            method: "PATCH",
            urlString: url,
            options: ["body": params ?? [] as Any]
        )
    }
    
    /// Perform a `Request` to the given `URL` using `PUT` as `HTTPMethod`.
    /// - Parameters:
    ///    - url: `String` value that represent the full URL that the `Request` will be hitting.
    ///    - params: `Parameters` (a.k.a. `[String: Any]`) to be encoded into the `URLRequest`. as body, `nil` by default.
    /// - Returns: A new instance of `ZttpResponse`.
    public func put(
        url: String,
        params: Dictionary<String, Any>? = nil
    ) throws -> ZttpResponse {
        return try ZttpPendingRequest.`default`.send(
            method: "PUT",
            urlString: url,
            options: ["body": params ?? [] as Any]
        )
    }
    
    /// Perform a `Request` to the given `URL` using `DELETE` as `HTTPMethod`.
    /// - Parameters:
    ///    - url: `String` value that represent the full URL that the `Request` will be hitting.
    ///    - params: `Parameters` (a.k.a. `[String: Any]`) to be encoded into the `URLRequest`. as body, `nil` by default.
    /// - Returns: A new instance of `ZttpResponse`.
    public func delete(
        url: String,
        params: Dictionary<String, Any>? = nil
    ) throws -> ZttpResponse {
        return try ZttpPendingRequest.`default`.send(
            method: "DELETE",
            urlString: url,
            options: ["body": params ?? [] as Any]
        )
    }
}

extension ZttpPendingRequest {
    
    /// Send build and perform the `Request` using the given parameters.
    /// - Parameters
    ///     - method: `HTTPMethod` (a.k.a `GET`, `POST`, `PUT`, `PATH`, `DELETE`)
    ///     - urlString: `String` value that represent the full URL that the `Request` will be hitting.
    ///     - options: `Option` (a.k.a. `[String: Any]`) to be encoded into the `URLRequest`. as body, `nil` by default.
    /// - Returns: A new instance of `ZttpResponse`.
    private func send(
        method: String,
        urlString: String,
        options: Dictionary<String, Any>? = nil
    ) throws -> ZttpResponse {
        
        //When the request is been building we check if the user send additional options
        //if it so, then we merge this options with the given previously for the same
        //request instance.
        if let options = options {
            self.options.merge(dict: options)
        }
        
        // Create a new instance ZttpRequest passing the URL as string, the HTTPMethod
        // a flag that indicate if this request need to be printed in the console,
        // the options as headers, queryItem and the Content-Type.
        let request = ZttpRequest(
            urlString: urlString,
            method: method,
            debug: needDebug,
            options: self.options,
            contentType: contentType
        )
        
        let requestObject = try request.asURLRequest()
        
        var data: Data?
        var response: URLResponse?
        var error: Error?

        self.beforeSendCallbacks.forEach({$0()})
        
        // Dispatch `RequestStarted` event, that will allows to the caller be notify
        // when the request start, and they can perform any operation on the main
        // thread, like presenting a loading message to the user.
        dispatch(event: .zttpRequestStarted)
        
        // Use `DispatchSemaphore` to avoid the callback hell, this allows us to wait
        // until the request is completed and then we can throw an exception or
        // just return the `ZttpResponse`
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global(qos: .background).async {
            
            self.urlSession.dataTask(with: requestObject) { (d, resp, e) in
                data = d
                response = resp
                error = e
                
                semaphore.signal()
            }.resume()
        }
        
        // Wait until the `signal` is received, this work as Future promise.
        _ = semaphore.wait(timeout: .distantFuture)
        
        // Dispatch `RequestFinished` event, that will allows to the caller be notify
        // when the request finished, and they can reverse any operation on the main
        // thread, like removing a loading message to the user.
        dispatch(event: .zttpRequestFinished)
        
        self.afterSendCallbacks.forEach({$0()})
        
        resetRequestOptions()
        
        return ZttpResponse(
            response: response as? HTTPURLResponse,
            data: data,
            error: error
        )
    }
    
    /// Reset all the options of the performed `Request`
    private func resetRequestOptions() {
        options = [:]
        needDebug = false
        contentType = .json
        beforeSendCallbacks = []
        afterSendCallbacks = []
    }
    
    public func beforeSend(then closure: @escaping () -> Void) -> ZttpPendingRequest {
        let this = ZttpPendingRequest.default
        this.beforeSendCallbacks.append(closure)
        return this
    }
    
    public func afterSend(then closure: @escaping () -> Void) -> ZttpPendingRequest {
        let this = ZttpPendingRequest.default
        this.afterSendCallbacks.append(closure)
        return this
    }
}
