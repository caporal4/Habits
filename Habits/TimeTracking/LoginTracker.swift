//
//  LoginTracker.swift
//  Habits
//
//  Created by Brendan Caporale on 3/3/25.
//

import Foundation

class LoginTracker: Codable {
    var loginList = [Date]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(loginList) {
                UserDefaults.standard.set(encoded, forKey: "list")
            }
        }
    }
    
    init() {
        if let savedList = UserDefaults.standard.data(forKey: "list") {
            if let decodedList = try? JSONDecoder().decode([Date].self, from: savedList) {
                loginList = decodedList
                return
            }
        }
        loginList = []
    }
}
