//
//  ContentView.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 04.06.2022.
//

import SwiftUI

struct SearchView: View {
	@StateObject var viewModel: SearchViewModel
	
	var body: some View {
		List(viewModel.plants) { plant in
			VStack(alignment: .leading, spacing: 5) {
				Text(plant.latinName)
					.font(.title2)
					.bold()
				Text(plant.commonName ?? "none")
					.italic()
			}
		}
		.onAppear {
			Task {
				do {
					try await viewModel.fetchPlants()
					print(viewModel.plants)
				} catch {
					print("cannot fetch plants")
				}
			}
		}
	}
}

struct SearchView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView(viewModel: SearchViewModel(dependencies: dependencies))
	}
}
