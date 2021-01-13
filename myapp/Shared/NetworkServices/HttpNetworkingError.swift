//
//  HttpNetworkingError.swift
//  FREESTYLE
//
//  Created by Alicia Monserrath Castro Hernandez on 30/10/20.
//

import Foundation

public enum HttpRequestError {
    case parsingError
    case mappingError

    private var domain: String {
        return "HTTPRequestError"
    }

    private var code: Int {
        switch self {
        case .parsingError:
            return -2
        case .mappingError:
            return -3
        }
    }

    private var messageError: String {
        switch self {
        case .parsingError:
            return "Error: Parsing json failed"
        case .mappingError:
            return "Error: Mapping object response failed"
        }
    }

    public var error: NSError {
        return NSError(domain: self.domain, code: self.code, userInfo: [NSLocalizedDescriptionKey: self.messageError])
    }
}

public enum HttpNetworkingError: IError {
    case unauthorized
    case badCredentials
    case inputDataNilOrZeroLength
    case jsonSerializationFailed(Error)
    case notResponse
    case requestDontFulfilled(Int)
    case noInternetConnection
    case unknown(Error)

    public init(_ error: NSError) {
        let codeError: Int = error.code
        switch codeError {
        case -1009:
            self = .noInternetConnection
        default:
            self = .unknown(error)
        }
    }

    public var code: Int {
        switch self {
        case .inputDataNilOrZeroLength:
            return 100
        case .jsonSerializationFailed:
            return 200
        case .notResponse:
            return 300
        case .requestDontFulfilled:
            return 400
        case .unauthorized:
            return 401
        case .badCredentials:
            return 500
        case .noInternetConnection:
            return 600
        default:
            return 0
        }
    }

    public var domain: String {
        switch self {
        default:
            return "HttpNetworking"
        }
    }

    public func messageError() -> String {
        switch self {
        case .inputDataNilOrZeroLength:
            return "Response could not be serialized, input data was nil or zero length."
        case .jsonSerializationFailed(let error):
            return "JSON could not be serialized because of error: " + error.localizedDescription
        case .notResponse:
            return "No response from API."
        case .requestDontFulfilled(let statusCode):
            return "The request has been accepted for processing, but the processing has not been completed (StatusCode = \(statusCode)"
        case .unauthorized:
            return "you are not authenticated correctly, please re authenticate and try again."
        case .badCredentials:
            return "The credentials supplied are not correct or do not grant access to this resource."
        case .noInternetConnection:
            return "No internet Connection."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
