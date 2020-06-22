//
//  ZttpRequest.swift
//  Zttp
//
//  Created by Alfredo Martinez on 6/15/20.
//

import Foundation

public class ZttpRequest {
    
    private let urlString: String
    private let method: String
    private let options: Dictionary<String, Any>?
    private let debug: Bool!
    private let contentType : RequestContentType!
    
    init(urlString: String, method: String, debug: Bool, options: Dictionary<String, Any>? = nil, contentType: RequestContentType) {
        self.urlString = urlString
        self.method = method
        self.options = options
        self.debug = debug
        self.contentType = contentType
    }
    
    private func buildURLRequest() throws -> URLRequest {
        
        guard var components = URLComponents(string: self.urlString) else {
            throw ZttpException(.BadURL)
        }
        
        if let options = self.options, let items = options["query"] as? Dictionary<String, Any> {
            
            if components.queryItems?.count ?? 0 == 0 {
                components.queryItems = []
            }
            
            items.forEach { (arg0) in
                let (key, value) = arg0
                components.queryItems?.append(URLQueryItem(name: key, value: value as? String))
            }
            
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = self.method
        
        request = computedOptions(request: request)
        
        if debug {
            request.debug()
        }
        
        return request
    }
    
    func asURLRequest() throws -> URLRequest {
        return try buildURLRequest()
    }
    
    private func computedOptions(request : URLRequest) -> URLRequest {
        var original = request
        original.timeoutInterval = TimeInterval(10 * 1000)
        
        if let options = self.options, let headers = options["header"] as? Dictionary<String, String> {
            headers.forEach { (arg0) in
                let (key, value) = arg0
                original.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        //Check if content type was especified, if not, then set as JSON by default
        if original.allHTTPHeaderFields?["Content-Type"] == nil {
            original.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let options = self.options, let body = options["body"] as? Dictionary<String, Any> {
            if body.count > 0 {
                
                switch contentType {
                case .json:
                    original.httpBody = body.toJSON
                    break
                case .formData:
                    original.httpBody = computedFormBody(withParams: body)
                    break
                default:
                    break
                }
            }
        }
        
        return original
    }
    
    
    private func computedFormBody(withParams parameters: [String: Any]) -> Data? {
    
        var params: [String] = []
        
        for (key, value) in parameters {
            params.append(key + "=\(value)")
        }
        
        return params
            .map{ String($0)}
            .joined(separator: "&")
            .data(using: .utf8)
    }
}
