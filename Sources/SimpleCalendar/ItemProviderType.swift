//
//  ItemProviderType.swift
//  SimpleCalendar
//
//  Created by hs on 3/30/25.
//

import Foundation

public protocol ItemProviderType {
	associatedtype T: Itemable
	func read(from: Date, to: Date) -> [Date: [T]]
}
