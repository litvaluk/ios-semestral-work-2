//
//  MyPlantsView2.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 08.06.2022.
//

import FirebaseAuth
import SwiftUI

struct MyPlantsView: View {
	@StateObject var viewModel: MyPlantsViewModel
	
	var body: some View {
		NavigationView {
			List {
				Section {
					NavigationLink(destination: PlantEntryListView(viewModel: PlantEntryListViewModel(ownerType: .user, owner: Auth.auth().currentUser!.uid, navigationTitle: "Personal", dependencies: dependencies))) {
						Text("Personal")
					}
					.navigationTitle("My plants")
				}
				Section(header: TeamHeaderView(viewModel: viewModel)) {
					ForEach(viewModel.teams) { team in
						NavigationLink(destination: PlantEntryListView(viewModel: PlantEntryListViewModel(ownerType: .team, owner: team.id!, navigationTitle: team.name, dependencies: dependencies)).navigationBarItems(trailing: NavigationLink(destination: TeamSettingsView(viewModel: TeamSettingsViewModel(team: team, dependencies: dependencies))) {
							Image(systemName: "gearshape.fill")
						})
						) {
							Text(team.name)
						}
					}
				}
				.textCase(.none)
			}
		}
		.onAppear {
			Task {
				do {
					try await viewModel.fetchTeams()
				} catch {
					print("cannot fetch teams")
				}
			}
		}
	}
}

struct TeamHeaderView: View {
	@StateObject var viewModel: MyPlantsViewModel
	
	var body: some View {
		HStack {
			Text("TEAM")
				.font(.headline)
			if (viewModel.isFetchingTeams) {
				ProgressView()
					.padding(.leading, 5)
			}
			Spacer()
			Button {
				viewModel.isAddNewTeamSheetShown.toggle()
			} label: {
				Image(systemName: "plus")
			}
			.sheet(isPresented: $viewModel.isAddNewTeamSheetShown) {
				VStack (spacing: 15) {
					Text("Add new team")
						.font(.title)
						.foregroundColor(.primary)
					TextField("Name", text: $viewModel.newTeamName)
						.padding()
						.background(.thinMaterial)
						.foregroundColor(.primary)
						.cornerRadius(10)
					Spacer()
					Button(action: viewModel.addNewTeam) {
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
	}
}

struct MyPlantsView_Previews: PreviewProvider {
	static var previews: some View {
		MyPlantsView(viewModel: MyPlantsViewModel(dependencies: dependencies))
	}
}
