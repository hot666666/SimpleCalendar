//  SimpleCalendar.swift
//  SimpleCalendar
//
//  Created by hs on 3/29/25.
//

import SwiftUI

public struct SimpleCalendar<ItemProvider: ItemProviderType>: View {
	@ObservedObject private var viewModel: ViewModel<ItemProvider>
	
	private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 1), count: 7)
	
	public init(itemProvider: ItemProvider) {
		self.viewModel = ViewModel(itemProvider: itemProvider)
	}
	
	public var body: some View {
		VStack {
			calendarHeader
			
			gridHeader
			gridContent
		}
		.padding()
		.background(.ultraThinMaterial)
		.onAppear {
			viewModel.handle(.load)
		}
		.sheet(item: $viewModel.selectedDate) { calendarDate in
			// TODO: - sheet 뷰 작성
			ForEach(viewModel.items[calendarDate.date] ?? []) { item in
				Text(item.content)
			}
		}
	}
	
	private var gridContent: some View {
		LazyVGrid(columns: columns, alignment: .leading, spacing: 1) {
			ForEach(viewModel.calendarDates) { calendarDate in
				DayCell(
					calendarDate: calendarDate,
					items: viewModel.items[calendarDate.date] ?? []
				)
				.onTapGesture {
					viewModel.handle(.selectDate(calendarDate))
				}
				.opacity(calendarDate.isCurrentMonth ? 1.0 : 0.5)
				.background(.ultraThickMaterial)
			}
		}
		.background(Color.primary.opacity(0.4))
		.border(Color.primary.opacity(0.4))
	}
	
	private var calendarHeader: some View {
		HStack(alignment: .center) {
			Button(action: {
				viewModel.handle(.prevMonth)
			}) {
				Image(systemName: "chevron.left")
					.font(.title)
			}
			
			Text(viewModel.currentMonth.monthYear)
				.font(.headline)
			
			Button(action: {
				viewModel.handle(.nextMonth)
				
			}) {
				Image(systemName: "chevron.right")
					.font(.title)
			}
		}
		.foregroundColor(.primary)
		.padding()
	}
	
	private var gridHeader: some View {
		HStack(spacing: 0) {
			ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { weekday in
				Text(weekday)
					.font(.caption)
					.frame(maxWidth: .infinity)
			}
		}
	}
}

// MARK: - DayCell
private struct DayCell<T: Itemable>: View {
	private let maxItemCount = 4
	
	let calendarDate: CalendarDate
	let items: [T]
	
	var body: some View {
		VStack(alignment: .leading, spacing: 3) {
			dayHeader
			ForEach(items.prefix(maxItemCount)) { item in
				DayCellItem(item: item)
					.padding(.horizontal, 2)
			}
			if items.count > maxItemCount {
				moreItems
					.padding(.horizontal, 2)
			}
			Spacer()
		}
	}
	
	private var dayHeader: some View {
		Text(calendarDate.date.day)
			.foregroundColor(.primary)
			.font(.subheadline)
			.padding([.top, .trailing], 4)
			.frame(maxWidth: .infinity, alignment: .trailing)
			.bold(calendarDate.isToday)
	}
	
	private var moreItems: some View {
		Text("+\(items.count - maxItemCount)...")
			.font(.caption2)
			.opacity(0.5)
	}
}

// MARK: - DayCellItem
private struct DayCellItem<T: Itemable>: View {
	let item: T
	
	var body: some View {
		Text(item.content)
			.lineLimit(1)
			.font(.caption)
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(item.color)
			.cornerRadius(2)
	}
}
