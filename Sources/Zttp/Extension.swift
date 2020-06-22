//
//  Extension.swift
//  Zttp
//
//  Created by Alfredo Martinez on 6/14/20.
//

import Foundation

extension Data {
    
    public func decoded<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
    
    public var toDictionary: NSDictionary? {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? NSDictionary
            
            if let parseJSON = json {
                
                return parseJSON
            }
        } catch let error as NSError {
            
            print("error: \(error)")
        }
        
        return nil
    }

}

extension Collection {
    
    public var toJSON: Data? {
        
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            return data
        }
        
        return nil
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

extension Encodable {
    
    public func encoded() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

extension String {
    
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
      guard let object = try? JSONSerialization.data(withJSONObject: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

      return prettyPrintedString
    }
}
extension URLRequest {
    
    public func debug() {
        #if DEBUG
        var result = "curl -k "
        guard
            let method = httpMethod,
            let headers = allHTTPHeaderFields
            else { return }
        
        result += "-X \(method) \\\n"
        for (header, value) in headers {
            result += "-H \"\(header): \(value)\" \\\n"
        }
        
        if let body = httpBody, !body.isEmpty, let string = String(data: body, encoding: .utf8), !string.isEmpty {
            result += "-d '\(string)' \\\n"
        }
        
        guard let url = url else { return }
        
        result += url.absoluteString
        
        var dash: String = ""
        for _ in 0...100 {
            dash += "="
        }
        
        print(dash)
        print(result)
        print(dash)
        
        #endif
    }
}
