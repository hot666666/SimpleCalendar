//
//  CalendarDate.swift
//  SimpleCalendar
//
//  Created by hs on 3/29/25.
//

import SwiftUI

struct CalendarDate: Identifiable {
	let id: String = UUID().uuidString
	let date: Date
	let isCurrentMonth: Bool
	let isToday: Bool
}
