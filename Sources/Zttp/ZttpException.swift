//
//  Exception.swift
//  Zttp
//
//  Created by Alfredo Martinez on 6/14/20.
//

import Foundation

protocol CustomStringConvertible : Error{
    var title: String { get }
    var description: String { get }
}

protocol CustomIntegerConvertible : Error {
    var statusCode: Int { get }
}

public class ZttpException: Error {
    public var httpError: HttpError!
    
    public init(_ httpError: HttpError) {
        self.httpError = httpError
    }
    
    public init(for status: Int) {
        self.httpError = HttpError(rawValue: status)!
    }
}

public enum HttpError : Int {
    
    // 300 Redirection
    case MultipleChoices = 300
    case MovedPermanently
    case Found
    case SeeOther
    case NotModified
    case UseProxy
    case SwitchProxy
    case TemporaryRedirect
    case PermanentRedirect
    // 400 Client Error
    case BadRequest = 400
    case Unauthorized
    case PaymentRequired
    case Forbidden
    case NotFound
    case MethodNotAllowed
    case NotAcceptable
    case ProxyAuthenticationRequired
    case RequestTimeout
    case Conflict
    case Gone
    case LengthRequired
    case PreconditionFailed
    case PayloadTooLarge
    case URITooLong
    case UnsupportedMediaType
    case RangeNotSatisfiable
    case ExpectationFailed
    case ImATeapot
    case MisdirectedRequest = 421
    case UnprocessableEntity
    case Locked
    case FailedDependency
    case UpgradeRequired = 426
    case PreconditionRequired = 428
    case TooManyRequests
    case RequestHeaderFieldsTooLarge = 431
    case UnavailableForLegalReasons = 451
    // 500 Server Error
    case InternalServerError = 500
    case NotImplemented
    case BadGateway
    case ServiceUnavailable
    case GatewayTimeout
    case HTTPVersionNotSupported
    case VariantAlsoNegotiates
    case InsufficientStorage
    case LoopDetected
    case NotExtended = 510
    case NetworkAuthenticationRequired
    // Custom
    case DataCannotBeDecode = 601
    case DataCannotBePersisted
    case NotInternetConnection
    case PermissionNotGranted
    case CanRetryRequest
    case Cancelled
    case BadURL
    
    var title: String {
        return "oops"
    }
    
    var description: String {
        return self.message
    }
    
    var statusCode: Int {
        return self.rawValue
    }
    
    private var message: String {
        return "\(self.statusCode)"
    }
}
