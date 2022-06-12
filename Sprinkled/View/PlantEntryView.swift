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
			Spacer()
		}
		.ignoresSafeArea(.all, edges: [.top])
		.onAppear {
			Task {
				do {
					try await viewModel.fetchPlant()
				} catch {
					print("cannot fetch plant")
				}
			}
		}
    }
}

struct PlantEntryView_Previews: PreviewProvider {
    static var previews: some View {
		let plantEntry = PlantEntry(id: "1", name: "My plant", plant: "1", user: "1", team: nil, createdBy: "1", createdAt: .now, images: [])
		PlantEntryView(viewModel: PlantEntryViewModel(dependencies: dependencies, plantEntry: plantEntry))
    }
}
