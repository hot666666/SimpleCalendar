//
//  ViewModel.swift
//  SimpleCalendar
//
//  Created by hs on 3/29/25.
//

import SwiftUI

public class ViewModel<ItemProvider: ItemProviderType>: ObservableObject {
	enum Action {
		case nextMonth
		case prevMonth
		case load
		case selectDate(CalendarDate)
	}
	
	private let calendar = Calendar.current
	private let itemProvider: ItemProvider
	
	private var startDate: Date = .now
	private var endDate: Date = .now
	@Published var currentMonth: Date {
		didSet {
			updateDateRange()
		}
	}
	@Published var selectedDate: CalendarDate?
	@Published var items: [Date: [ItemProvider.T]] = [:]
	
	init(itemProvider: ItemProvider) {
		self.itemProvider = itemProvider
		/// CalendarDate 계산 및 달 이동에 이용되므로, 날짜의 시작 시점으로 설정
		self.currentMonth = calendar.startOfDay(for: .now)
		/// init에서는 didSet이 호출되지 않으므로 직접 호출
		updateDateRange()
	}
	
	func handle(_ action: Action) {
		switch action {
		case .nextMonth:
			moveMonth(by: 1)
			loadItems()
		case .prevMonth:
			moveMonth(by: -1)
			loadItems()
		case .load:
			loadItems()
		case .selectDate(let date):
			selectedDate = date
		}
	}
	
	var calendarDates: [CalendarDate] {
		var dates: [CalendarDate] = []
		var currentDate = startDate
		
		while currentDate <= endDate {
			let isCurrentMonth = calendar.isDate(currentDate, equalTo: currentMonth, toGranularity: .month)
			let isToday = calendar.isDateInToday(currentDate)
			dates.append(CalendarDate(date: currentDate, isCurrentMonth: isCurrentMonth, isToday: isToday))
			currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
		}
		
		return dates
	}
	
	private func loadItems() {
		self.items = itemProvider.read(from: startDate, to: endDate)
	}
	
	private func updateDateRange() {
		let range = calculateDateRange(for: currentMonth)
		self.startDate = range.start
		self.endDate = range.end
	}
	
	private func moveMonth(by value: Int) {
		/// currentMonth 업데이트 시, startDate와 endDate도 이에 맞춰 업데이트가 수행(didSet)
		self.currentMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) ?? currentMonth
	}
}

extension ViewModel {
	private func calculateDateRange(for month: Date) -> (start: Date, end: Date) {
		guard let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month)),
					let monthRange = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else {
			return (month, month)
		}
		
		let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
		let leadingDays = firstWeekday - 1
		
		guard let startDate = calendar.date(byAdding: .day, value: -leadingDays, to: firstDayOfMonth),
					let endDate = calendar.date(byAdding: .day, value: monthRange.count + (6 - (monthRange.count + leadingDays - 1) % 7) - 1, to: firstDayOfMonth) else {
			return (firstDayOfMonth, firstDayOfMonth)
		}
		
		return (start: startDate, end: endDate)
	}
}
