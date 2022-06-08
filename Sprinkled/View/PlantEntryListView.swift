//
//  PlantEntryListView.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 08.06.2022.
//

import SwiftUI
import Kingfisher

struct PlantEntryListView: View {
	@StateObject var viewModel: PlantEntryListViewModel
	
	var gridItemLayout = [
		GridItem(.adaptive(minimum: 105, maximum: 105))
	]
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: gridItemLayout, spacing: 5) {
				ForEach(viewModel.plantEntries, id: \.self) { plantEntry in
					PlantEntryGridItemView(plantEntry: plantEntry)
				}
			}
			.padding(15)
			.onAppear {
				Task {
					do {
						try await viewModel.fetchPlantEntries()
					} catch {
						print("cannot fetch")
					}
				}
			}
		}
		.navigationTitle(viewModel.navigationTitle)
	}
}

struct PlantEntryGridItemView: View {
	let plantEntry: PlantEntry
	
	init(plantEntry: PlantEntry) {
		self.plantEntry = plantEntry
	}
	
	var body: some View {
		NavigationLink(destination: Text("text")) {
			ZStack (alignment: .bottomLeading) {
				GeometryReader { gr in
					if (plantEntry.images.isEmpty) {
						Image("NoImage")
							.resizable()
							.scaledToFill()
							.frame(height: gr.size.width)
					} else {
						KFImage(URL(string: plantEntry.images[0]))
							.resizable()
							.scaledToFill()
							.frame(height: gr.size.width)
					}
				}
				.clipped()
				.aspectRatio(1, contentMode: .fit)
				Text(plantEntry.name)
					.bold()
					.foregroundColor(.white)
					.multilineTextAlignment(.leading)
					.padding(6)
			}
			.cornerRadius(15)
		}
	}
}

struct PlantEntryListView_Previews: PreviewProvider {
	static var previews: some View {
		PlantEntryListView(viewModel: PlantEntryListViewModel(ownerType: .team, owner: "test", navigationTitle: "Personal", dependencies: dependencies))
	}
}
