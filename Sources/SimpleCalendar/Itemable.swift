//
//  Item.swift
//  SimpleCalendar
//
//  Created by hs on 3/30/25.
//

import SwiftUI

public protocol Itemable: Identifiable {
	var id: String { get }
	var date: Date { get set }
	var content: String { get set }
	var color: Color { get set }
	
	init(date: Date, content: String, color: Color)
}
