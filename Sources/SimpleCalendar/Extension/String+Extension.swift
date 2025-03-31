//
//  String+Extensions.swift
//  SimpleCalendar
//
//  Created by hs on 3/26/25.
//

extension String {
	func truncate(_ length: Int = 10) -> String {
		if self.count > length {
			return String(self.prefix(length)) + ".."
		} else {
			return self
		}
	}
}
