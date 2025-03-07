//
//  Units.swift
//  Habits
//
//  Created by Brendan Caporale on 3/3/25.
//

import Foundation
import SwiftUI

struct Units {
    let count = NSLocalizedString("Count", comment: "Unit")
    let millileter = NSLocalizedString("mL", comment: "Unit")
    let ounce = NSLocalizedString("Ounce", comment: "Unit")
    let gallon = NSLocalizedString("Gallon", comment: "Unit")
    let mile = NSLocalizedString("Mile", comment: "Unit")
    let kilometer = NSLocalizedString("Kilometer", comment: "Unit")
    let second = NSLocalizedString("Second", comment: "Unit")
    let minute = NSLocalizedString("Hour", comment: "Unit")
    let hour = NSLocalizedString("Minute", comment: "Unit")
    var list: [String] {
        return [count, millileter, ounce, gallon, mile, kilometer, second, minute, hour]
    }

    let counts = NSLocalizedString("Counts", comment: "Unit")
    let millileters = NSLocalizedString("mLs", comment: "Unit")
    let ounces = NSLocalizedString("Ounces", comment: "Unit")
    let gallons = NSLocalizedString("Gallons", comment: "Unit")
    let miles = NSLocalizedString("Miles", comment: "Unit")
    let kilometers = NSLocalizedString("Kilometers", comment: "Unit")
    let seconds = NSLocalizedString("Seconds", comment: "Unit")
    let minutes = NSLocalizedString("Hours", comment: "Unit")
    let hours = NSLocalizedString("Minutes", comment: "Unit")
    var pluralList: [String] {
        return [counts, millileters, ounces, gallons, miles, kilometers, seconds, minutes, hours]
    }
}
