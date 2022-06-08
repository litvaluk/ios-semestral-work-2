//
//  AppDependency.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 04.06.2022.
//

final class AppDependency {
	fileprivate init() { }
	
	lazy var plantRepository: PlantRepositoryType = PlantRepository()
	lazy var plantEntryRepository: PlantEntryRepositoryType = PlantEntryRepository()
	lazy var teamRepository: TeamRepositoryType = TeamRepository()
}

extension AppDependency: HasPlantRepository {}
extension AppDependency: HasPlantEntryRepository {}
extension AppDependency: HasTeamRepository {}

let dependencies = AppDependency()
