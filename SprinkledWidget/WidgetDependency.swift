//
//  WidgetDependency.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 19.06.2022.
//

final class WidgetDependency {
	fileprivate init() {}
	
	lazy var plantRepository: PlantRepositoryType = PlantRepository()
}

extension WidgetDependency: HasPlantRepository {}

let dependencies = WidgetDependency()
