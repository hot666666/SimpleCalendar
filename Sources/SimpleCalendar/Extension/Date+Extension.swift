//
//  Date+Extension.swift
//  SimpleCalendar
//
//  Created by hs on 3/26/25.
//

import Foundation

extension Date {
	var day: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "d"
		return formatter.string(from: self)
	}
	
	var monthYear: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM yyyy"
		return formatter.string(from: self)
	}
}
		
