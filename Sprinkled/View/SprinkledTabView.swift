//
//  SprinkledTabView.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 18.06.2022.
//

import SwiftUI
import FirebaseAuth

struct SprinkledTabView: View {
	@StateObject var viewModel: SprinkledTabViewModel
	
    var body: some View {
		Group {
			if (viewModel.currentUser != nil) {
				TabView {
					HomeView(viewModel: HomeViewModel(dependencies: dependencies)).tabItem {
						Image(systemName: "house")
					}
					MyPlantsView(viewModel: MyPlantsViewModel(dependencies: dependencies)).tabItem {
						Image(systemName: "leaf")
					}
					SearchView(viewModel: SearchViewModel(dependencies: dependencies)).tabItem {
						Image(systemName: "magnifyingglass")
					}
					SettingsView(viewModel: SettingsViewModel(dependencies: dependencies)).tabItem {
						Image(systemName: "gearshape")
					}
				}
			} else {
				AuthView(viewModel: AuthViewModel(dependencies: dependencies))
			}
		}
		.accentColor(.sprinkledGreen)
		.errorAlert(error: $viewModel.error)
		.onAppear {
			Task {
				await viewModel.onAppear()
			}
		}
    }
}

struct SprinkledTabView_Previews: PreviewProvider {
    static var previews: some View {
        SprinkledTabView(viewModel: SprinkledTabViewModel(dependencies: dependencies))
    }
}
