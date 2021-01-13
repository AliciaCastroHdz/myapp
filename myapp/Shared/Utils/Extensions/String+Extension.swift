//
//  String+Extension.swift
//  myapp
//
//  Created by Alicia Monserrath Castro Hernandez on 13/01/21.
//

import Foundation

extension String {
    func isValid() -> Bool {
        return !self.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
