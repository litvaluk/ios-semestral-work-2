//
//  HomeView.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 06.06.2022.
//

import SwiftUI

struct HomeView: View {
	@StateObject var viewModel: HomeViewModel
	
	var body: some View {
		NavigationView {
			Group {
				if (!viewModel.reminderMap.isEmpty) {
					List {
						ForEach(Array(viewModel.reminderMap), id: \.key) { dayAndMonth, reminders in
							Section {
								ForEach(reminders) { reminder in
									HomeReminderListItemView(reminder: reminder)
								}
							} header: {
								Text(dayAndMonth)
							}
						}
					}
					.refreshable {
						Task {
							do {
								try await viewModel.fetchReminders()
							} catch {
								print("cannot fetch reminders")
							}
						}
					}
					.listStyle(.plain)
				} else {
					Text("No upcoming reminders")
						.foregroundColor(Color.secondary)
						.italic()
				}
			}
			.navigationTitle("Upcoming")
		}
		.navigationViewStyle(.stack)
		.onAppear {
			Task {
				do {
					try await viewModel.fetchReminders()
				} catch {
					print("cannot fetch reminders")
				}
			}
		}
	}
}

struct HomeReminderListItemView: View {
	let reminder: Reminder
	let df: DateFormatter
	
	init(reminder: Reminder) {
		self.reminder = reminder
		df = DateFormatter()
		df.dateFormat = "HH:mm"
	}
	
	var body: some View {
		HStack {
			ZStack {
				RoundedRectangle(cornerRadius: 15)
					.foregroundColor(.sprinkledPaleGreen)
				getEventImage(eventType: reminder.event)
					.resizable()
					.scaledToFit()
					.padding(10)
					.foregroundColor(.sprinkledGreen)
			}
			.frame(width: 50, height: 50)
			VStack(alignment: .leading, spacing: 0) {
				Text(reminder.event)
				Text(reminder.plantName)
					.font(.subheadline)
					.italic()
			}
			Spacer()
			Text(df.string(from: reminder.date))
		}
	}
	
	private func getEventImage(eventType: String) -> Image {
		switch(eventType) {
		case "Water":
			return Image("Water")
				.renderingMode(.template)
		case "Mist":
			return Image("Mist")
				.renderingMode(.template)
		case "Repot":
			return Image("Repot")
				.renderingMode(.template)
		case "Fertilize":
			return Image("Fertilize")
				.renderingMode(.template)
		default: // prune
			return Image(systemName: "scissors")
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView(viewModel: HomeViewModel(dependencies: dependencies))
	}
}
