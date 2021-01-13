//
//  IError.swift
//  FREESTYLE
//
//  Created by Alicia Monserrath Castro Hernandez on 30/10/20.
//

import Foundation

public protocol IError: Error {
    var key: String { get }
    var code: Int { get }
    var domain: String { get }

    func messageError() -> String
}

public extension IError {
    var code: Int {
        return 0
    }

    var domain: String {
        return "Error"
    }

    var key: String {
        return "\(domain)-\(code)"
    }
}
