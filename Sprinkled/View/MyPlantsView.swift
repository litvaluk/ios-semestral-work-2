//
//  MyPlantsView.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 06.06.2022.
//

import SwiftUI
import Kingfisher

let gridItemSize = CGFloat(105)

struct MyPlantsView: View {
	@StateObject var viewModel: MyPlantsViewModel
	
	var gridItemLayout = [
		GridItem(.adaptive(minimum: gridItemSize, maximum: gridItemSize))
	]
	
	var body: some View {
		NavigationView {
			VStack {
				Picker("My Plants Option", selection: $viewModel.selectedOption, content: {
					Text("Personal").tag(0)
					Text("Team").tag(1)
				})
				.pickerStyle(SegmentedPickerStyle())
				.padding()
				.navigationTitle("My plants")
				ScrollView {
					LazyVGrid(columns: gridItemLayout, spacing: 5) {
						switch (viewModel.selectedOption) {
						case 0:
							ForEach(viewModel.plantEntries, id: \.self) { plantEntry in
								PlantEntryGridItemView(plantEntry: plantEntry)
							}
						default:
							ForEach(viewModel.teams, id: \.self) { team in
								TeamGridItemView(team: team)
							}
						}
					}
					.padding(15)
					.onAppear {
						Task {
							do {
								try await viewModel.fetchPlantEntries()
								try await viewModel.fetchTeams()
							} catch {
								print("cannot fetch")
							}
						}
					}
				}
				Spacer()
			}
		}
		.navigationViewStyle(.stack)
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

struct TeamGridItemView: View {
	let team: Team
	
	init(team: Team) {
		self.team = team
	}
	
	var body: some View {
		NavigationLink(destination: Text("team")) {
			ZStack (alignment: .bottomLeading) {
				Rectangle().fill(.black)
				Text(team.name)
					.bold()
					.foregroundColor(.white)
					.multilineTextAlignment(.leading)
					.padding(6)
			}
			.frame(width: gridItemSize, height: gridItemSize)
			.cornerRadius(15)
		}
	}
}

struct MyPlantsView_Previews: PreviewProvider {
	static var previews: some View {
		MyPlantsView(viewModel: MyPlantsViewModel(dependencies: dependencies))
			.previewInterfaceOrientation(.portrait)
	}
}
