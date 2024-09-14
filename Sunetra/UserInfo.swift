//
//  UserInfo.swift
//  Sunetra
//
//  Created by Anmol Ranjan on 31/05/24.
//

import Foundation

// Struct for User details
class UserInfo {

    static let shared = UserInfo()
    
    var name: String = ""
    var gender: String = ""
    var dob: Date = Date() {
        didSet {
            self.age = calculateAge(from: dob)
        }
    }
    var glasses: Bool = false
    var email: String?
    var profileImageUrl : String?

    private(set) var age: Int = 0

    private init() {
        self.age = calculateAge(from: dob)
    }
    
    // Calculating age based on provided date
    private func calculateAge(from date: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: date, to: Date())
        return ageComponents.year ?? 0
    }
}
