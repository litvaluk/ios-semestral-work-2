//
//  PlantEntryView.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 12.06.2022.
//

import SwiftUI
import Kingfisher

struct PlantEntryView: View {
	@Environment(\.presentationMode) var presentationMode
	
	@StateObject var viewModel: PlantEntryViewModel
	
	var body: some View {
		VStack(spacing: 0) {
			ZStack (alignment: .bottomLeading) {
				if !viewModel.plantEntry.images.isEmpty {
					KFImage(URL(string: viewModel.plantEntry.images[0])!)
						.resizable()
						.scaledToFill()
						.frame(height: 250)
				} else {
					Image("NoImage")
						.resizable()
						.scaledToFill()
						.frame(height: 250)
				}
				HStack {
					VStack(alignment: .leading) {
						Text(viewModel.plantEntry.name)
							.font(.title2)
							.bold()
							.foregroundColor(.white)
							.multilineTextAlignment(.leading)
					}
					Spacer()
				}
				.padding()
			}
			.cornerRadius(15)
			HStack {
				NavigationLink(destination: PlantView(viewModel: PlantViewModel(plant: viewModel.plant!, dependencies: dependencies))) {
					ZStack {
						RoundedRectangle(cornerRadius: 15)
							.foregroundColor(.sprinkledGray)
						Text("View plant detail")
							.foregroundColor(.primary)
					}
				}
				Spacer()
				Button {
					presentationMode.wrappedValue.dismiss()
					viewModel.deletePlantEntry(id: viewModel.plantEntry.id!)
				} label: {
					ZStack {
						RoundedRectangle(cornerRadius: 15)
							.foregroundColor(.sprinkledGray)
						Image(systemName: "trash")
							.foregroundColor(.red)
					}
					.frame(width: 50)
				}
			}
			.frame(height: 50)
			.padding()
			Picker("Plant Entry Picker", selection: $viewModel.pickerSelection) {
				Text("History").tag(0)
				Text("Reminders").tag(1)
			}
			.pickerStyle(.segmented)
			.padding()
			if (viewModel.pickerSelection == 0) {
				List {
					ForEach(viewModel.events.sorted()) { event in
						EventListItemView(event: event, user: viewModel.users.first {
							$0.id! == event.createdBy
						} ?? User(id: "1", email: "unknown"))
					}
				}
				.listStyle(.plain)
				.padding([.trailing])
			} else {
				List {
					Text("Reminder #1")
					Text("Reminder #2")
				}
				.listStyle(.plain)
				.padding([.trailing])
			}
		}
		.ignoresSafeArea(.all, edges: [.top])
		.onAppear {
			Task {
				do {
					try await viewModel.fetchEvents()
					try await viewModel.fetchUsers()
					try await viewModel.fetchPlant()
				} catch {
					print("cannot fetch plant/events")
				}
			}
		}
	}
}

struct EventListItemView: View {
	let event: Event
	let user: User
	
	var body: some View {
		HStack {
			ZStack {
				RoundedRectangle(cornerRadius: 15)
					.foregroundColor(.sprinkledPaleGreen)
				Image(systemName: getIconSystemName(eventType: event.type))
					.resizable()
					.scaledToFit()
					.padding(10)
					.foregroundColor(.sprinkledGreen)
			}
			.frame(width: 50, height: 50)
			HStack {
				VStack(alignment: .leading, spacing: 6) {
					Text(event.type)
						.font(.subheadline)
					Text(user.email)
						.font(.caption)
				}
				Spacer()
				VStack(alignment: .trailing, spacing: 6) {
					Text(getDateString(date: event.createdAt))
						.font(.subheadline)
					Text(getTimeString(date: event.createdAt))
						.font(.caption)
				}
			}
		}
	}
	
	func getIconSystemName(eventType: String) -> String {
		switch(eventType) {
		case "Water":
			return "drop.fill"
		default:
			return "leaf.fill"
		}
	}
	
	func getDateString(date: Date) -> String {
		let df = DateFormatter()
		df.dateFormat = "MMM d, y"
		return df.string(from: date)
	}
	
	func getTimeString(date: Date) -> String {
		let df = DateFormatter()
		df.dateFormat = "HH:mm"
		return df.string(from: date)
	}
}

struct PlantEntryView_Previews: PreviewProvider {
	static var previews: some View {
		let plantEntry = PlantEntry(id: "1", name: "My plant", plant: "1", user: "1", team: nil, createdBy: "1", createdAt: .now, images: [])
		PlantEntryView(viewModel: PlantEntryViewModel(dependencies: dependencies, plantEntry: plantEntry))
	}
}
