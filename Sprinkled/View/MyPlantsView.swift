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
						NavigationLink(destination: PlantEntryListView(viewModel: PlantEntryListViewModel(ownerType: .team, owner: team.id!, navigationTitle: team.name, dependencies: dependencies))) {
							Text(team.name)
						}
					}
				}
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
			Text("Team")
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
				Text("Add new team")
			}
		}
	}
}

struct MyPlantsView_Previews: PreviewProvider {
	static var previews: some View {
		MyPlantsView(viewModel: MyPlantsViewModel(dependencies: dependencies))
	}
}
