//
//  AppDependency.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 04.06.2022.
//

final class AppDependency {
	fileprivate init() { }
	
	lazy var plantRepository: PlantRepositoryType = PlantRepository()
}

extension AppDependency: HasPlantRepository {}

let dependencies = AppDependency()
