//
//  PlantView.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 10.06.2022.
//

import SwiftUI
import Kingfisher

struct PlantView: View {
	@StateObject var viewModel: PlantViewModel
	
	var body: some View {
		VStack(spacing: 0) {
			ZStack (alignment: .bottomLeading) {
				if let url = viewModel.plant.pictureUrl {
					KFImage(URL(string: url)!)
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
						Text(viewModel.plant.latinName)
							.font(.title2)
							.bold()
							.foregroundColor(.white)
							.multilineTextAlignment(.leading)
						Text(viewModel.plant.commonName ?? "none")
							.font(.title3)
							.bold()
							.italic()
							.foregroundColor(.white)
							.multilineTextAlignment(.leading)
					}
					Spacer()
					Button {
						viewModel.isAddNewPlantEntrySheetShown.toggle()
					} label: {
						ZStack {
							RoundedRectangle(cornerRadius: 15)
								.frame(width: 60, height: 60)
								.foregroundColor(.sprinkledGreen)
							Image(systemName: "plus")
								.resizable()
								.scaledToFit()
								.frame(width: 30, height: 30)
								.foregroundColor(.white)
						}
					}
					.sheet(isPresented: $viewModel.isAddNewPlantEntrySheetShown) {
						VStack (spacing: 15) {
							Text("Add new plant entry")
								.font(.title)
							Text(viewModel.plant.latinName)
								.font(.title2)
							TextField("Name", text: $viewModel.newPlantEntryName)
								.padding()
								.background(.thinMaterial)
								.cornerRadius(10)
								.textInputAutocapitalization(.never)
							Spacer()
							Button(action: viewModel.addNewPlantEntry) {
								Text("Add")
									.foregroundColor(.white)
									.frame(maxWidth: .infinity)
							}
							.padding()
							.background(Color.sprinkledGreen)
							.cornerRadius(10)
						}
						.padding()
					}
				}
				.padding()
			}
			.cornerRadius(15)
			ScrollView {
				InfoBoxesView(plant: viewModel.plant)
					.padding()
				VStack {
					Text("Description")
						.font(.headline)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding([.bottom], 2)
					Text(viewModel.plant.description ?? "No description")
						.italic()
				}
				.padding([.leading, .trailing, .bottom])
			}
		}
		.ignoresSafeArea(.all, edges: [.top])
	}
	
	
}

struct InfoBoxesView: View {
	let plant: Plant
	
	var body: some View {
		VStack {
			HStack {
				InfoBoxView(imageName: "Temperature", header: "Temperature", value: "\(plant.temperatureMin!) °C - \(plant.temperatureMax!) °C")
				InfoBoxView(imageName: getLightIcon(light: plant.light!), header: "Light", value: plant.light!)
			}
			.frame(height: 80)
			HStack {
				InfoBoxView(imageName: "Earth", header: "Zone", value: "\(plant.zoneMin!) - \(plant.zoneMax!)")
				
				InfoBoxView(imageName: "Leaf", header: "Color", value: plant.leafColor!)
			}
			.frame(height: 80)
		}
	}
	
	private func getLightIcon(light: String) -> String {
		switch(light) {
		case "Strong light":
			return "PartlyCloudy"
		default:
			return "Sunny"
		}
	}
}

struct InfoBoxView: View {
	let imageName: String
	let header: String
	let value: String
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 15)
				.foregroundColor(.sprinkledGray)
			HStack {
				Image(imageName)
					.resizable()
					.font(Font.title.weight(.thin))
					.scaledToFit()
					.frame(width: 40, height: 40)
				VStack (alignment: .leading) {
					Text(header)
						.font(.subheadline)
					Text(value)
						.font(.subheadline)
				}
				.frame(maxWidth: .infinity)
			}
			.padding()
		}
	}
}

struct PlantView_Previews: PreviewProvider {
	private static let plant = Plant(id: "123", latinName: "Zamioculcas zamifolia", commonName: "ZZ plant", description: "This is a really brief description of the plant named zamioculcas zamifolia, commonly known as zz plant.", pictureUrl: nil, temperatureMin: 10, temperatureMax: 30, leafColor: "Dark green", bloomColor: nil, light: "Strong light", zoneMin: 9, zoneMax: 11)
	static var previews: some View {
		PlantView(viewModel: PlantViewModel(plant: plant, dependencies: dependencies))
	}
}

// "http://www.tropicopia.com/house-plant//thumbnails/5790.jpg"
