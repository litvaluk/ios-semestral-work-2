//
//  SearchView.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 04.06.2022.
//

import SwiftUI
import FirebaseAuth
import Kingfisher

struct SearchView: View {
	@StateObject var viewModel: SearchViewModel
	
	var body: some View {
		NavigationView {
			if (!viewModel.isFetchedAtLeastOnce) {
				ProgressView()
					.scaleEffect(1.5)
					.padding(100)
			}
			List(viewModel.filteredPlants.sorted()) { plant in
				NavigationLink(destination: PlantView(viewModel: PlantViewModel(plant: plant, dependencies: dependencies))) {
					PlantListItemView(plant: plant)
				}
			}
			.searchable(text: $viewModel.searchText)
			.refreshable {
				await viewModel.fetchPlants()
			}
			.listStyle(.inset)
			.navigationTitle("Search plants")
		}
		.navigationViewStyle(.stack)
		.errorAlert(error: $viewModel.error)
		.onAppear {
			Task {
				await viewModel.fetchPlants()
			}
		}
	}
}

struct PlantListItemView: View {
	let plant: Plant
	
	init(plant: Plant) {
		self.plant = plant
	}
	
	var body: some View {
		HStack {
			if let url = plant.pictureUrl {
				KFImage(URL(string: url)!)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 60, height: 60, alignment: .center)
					.clipped()
					.cornerRadius(8)
					.padding(2)
			} else {
				Image("NoImage")
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: 60, height: 60, alignment: .center)
					.clipped()
					.cornerRadius(8)
					.padding(2)
			}
			VStack(alignment: .leading, spacing: 5) {
				Text(plant.latinName)
					.font(.title3)
					.bold()
				Text(plant.commonName ?? "none")
					.italic()
			}
		}
	}
}

struct SearchView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView(viewModel: SearchViewModel(dependencies: dependencies))
	}
}
