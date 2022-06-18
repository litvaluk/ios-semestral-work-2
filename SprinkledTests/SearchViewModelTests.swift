//
//  SprinkledTests.swift
//  SprinkledTests
//
//  Created by Lukáš Litvan on 18.06.2022.
//

import XCTest
@testable import Sprinkled

class SprinkledTests: XCTestCase {
	private var viewModel: SearchViewModel!
	
	override func setUp() {
		super.setUp()
		viewModel = SearchViewModel(dependencies: dependencies)
	}
	
	override func tearDown() {
		super.tearDown()
		viewModel = nil
	}
	
	func testPlantSearchEmptyString() throws {
		// given
		viewModel.searchText = ""
		viewModel.plants = [
			Plant(id: "1", latinName: "latin1", commonName: "common1", description: "desc1", pictureUrl: "url1", temperatureMin: 1, temperatureMax: 2, leafColor: "leafColor1", bloomColor: "bloomColor1", light: "light1", zoneMin: 1, zoneMax: 2),
			Plant(id: "2", latinName: "latin2", commonName: "common2", description: "desc2", pictureUrl: "url2", temperatureMin: 3, temperatureMax: 4, leafColor: "leafColor2", bloomColor: "bloomColor2", light: "light2", zoneMin: 3, zoneMax: 4),
			Plant(id: "3", latinName: "latin3", commonName: "common3", description: "desc3", pictureUrl: "url3", temperatureMin: 5, temperatureMax: 6, leafColor: "leafColor3", bloomColor: "bloomColor3", light: "light3", zoneMin: 5, zoneMax: 6),
			Plant(id: "4", latinName: "latin4", commonName: "common4", description: "desc4", pictureUrl: "url4", temperatureMin: 7, temperatureMax: 8, leafColor: "leafColor4", bloomColor: "bloomColor4", light: "light4", zoneMin: 7, zoneMax: 8),
			Plant(id: "5", latinName: "latin5", commonName: "common5", description: "desc5", pictureUrl: "url5", temperatureMin: 9, temperatureMax: 10, leafColor: "leafColor5", bloomColor: "bloomColor5", light: "light5", zoneMin: 9, zoneMax: 10)
		]
		
		// when
		let filtered = viewModel.filteredPlants
		
		// then
		XCTAssertTrue(filtered.count == 5)
	}
	
	func testPlantSearchNoMatch() throws {
		// given
		viewModel.searchText = "nomatch"
		viewModel.plants = [
			Plant(id: "1", latinName: "latin1", commonName: "common1", description: "desc1", pictureUrl: "url1", temperatureMin: 1, temperatureMax: 2, leafColor: "leafColor1", bloomColor: "bloomColor1", light: "light1", zoneMin: 1, zoneMax: 2),
			Plant(id: "2", latinName: "latin2", commonName: "common2", description: "desc2", pictureUrl: "url2", temperatureMin: 3, temperatureMax: 4, leafColor: "leafColor2", bloomColor: "bloomColor2", light: "light2", zoneMin: 3, zoneMax: 4),
			Plant(id: "3", latinName: "latin3", commonName: "common3", description: "desc3", pictureUrl: "url3", temperatureMin: 5, temperatureMax: 6, leafColor: "leafColor3", bloomColor: "bloomColor3", light: "light3", zoneMin: 5, zoneMax: 6),
			Plant(id: "4", latinName: "latin4", commonName: "common4", description: "desc4", pictureUrl: "url4", temperatureMin: 7, temperatureMax: 8, leafColor: "leafColor4", bloomColor: "bloomColor4", light: "light4", zoneMin: 7, zoneMax: 8),
			Plant(id: "5", latinName: "latin5", commonName: "common5", description: "desc5", pictureUrl: "url5", temperatureMin: 9, temperatureMax: 10, leafColor: "leafColor5", bloomColor: "bloomColor5", light: "light5", zoneMin: 9, zoneMax: 10)
		]
		
		// when
		let filtered = viewModel.filteredPlants
		
		// then
		XCTAssertTrue(filtered.isEmpty)
	}
	
	func testPlantSearchMatchOneLatin() throws {
		// given
		viewModel.searchText = "in1"
		viewModel.plants = [
			Plant(id: "1", latinName: "latin1", commonName: "common1", description: "desc1", pictureUrl: "url1", temperatureMin: 1, temperatureMax: 2, leafColor: "leafColor1", bloomColor: "bloomColor1", light: "light1", zoneMin: 1, zoneMax: 2),
			Plant(id: "2", latinName: "latin2", commonName: "common2", description: "desc2", pictureUrl: "url2", temperatureMin: 3, temperatureMax: 4, leafColor: "leafColor2", bloomColor: "bloomColor2", light: "light2", zoneMin: 3, zoneMax: 4),
			Plant(id: "3", latinName: "latin3", commonName: "common3", description: "desc3", pictureUrl: "url3", temperatureMin: 5, temperatureMax: 6, leafColor: "leafColor3", bloomColor: "bloomColor3", light: "light3", zoneMin: 5, zoneMax: 6),
			Plant(id: "4", latinName: "latin4", commonName: "common4", description: "desc4", pictureUrl: "url4", temperatureMin: 7, temperatureMax: 8, leafColor: "leafColor4", bloomColor: "bloomColor4", light: "light4", zoneMin: 7, zoneMax: 8),
			Plant(id: "5", latinName: "latin5", commonName: "common5", description: "desc5", pictureUrl: "url5", temperatureMin: 9, temperatureMax: 10, leafColor: "leafColor5", bloomColor: "bloomColor5", light: "light5", zoneMin: 9, zoneMax: 10)
		]
		
		// when
		let filtered = viewModel.filteredPlants
		
		// then
		XCTAssertTrue(filtered.count == 1)
		XCTAssertTrue(filtered[0].id == "1")
	}
	
	func testPlantSearchMatchOneCommon() throws {
		// given
		viewModel.searchText = "on3"
		viewModel.plants = [
			Plant(id: "1", latinName: "latin1", commonName: "common1", description: "desc1", pictureUrl: "url1", temperatureMin: 1, temperatureMax: 2, leafColor: "leafColor1", bloomColor: "bloomColor1", light: "light1", zoneMin: 1, zoneMax: 2),
			Plant(id: "2", latinName: "latin2", commonName: "common2", description: "desc2", pictureUrl: "url2", temperatureMin: 3, temperatureMax: 4, leafColor: "leafColor2", bloomColor: "bloomColor2", light: "light2", zoneMin: 3, zoneMax: 4),
			Plant(id: "3", latinName: "latin3", commonName: "common3", description: "desc3", pictureUrl: "url3", temperatureMin: 5, temperatureMax: 6, leafColor: "leafColor3", bloomColor: "bloomColor3", light: "light3", zoneMin: 5, zoneMax: 6),
			Plant(id: "4", latinName: "latin4", commonName: "common4", description: "desc4", pictureUrl: "url4", temperatureMin: 7, temperatureMax: 8, leafColor: "leafColor4", bloomColor: "bloomColor4", light: "light4", zoneMin: 7, zoneMax: 8),
			Plant(id: "5", latinName: "latin5", commonName: "common5", description: "desc5", pictureUrl: "url5", temperatureMin: 9, temperatureMax: 10, leafColor: "leafColor5", bloomColor: "bloomColor5", light: "light5", zoneMin: 9, zoneMax: 10)
		]
		
		// when
		let filtered = viewModel.filteredPlants
		
		// then
		XCTAssertTrue(filtered.count == 1)
		XCTAssertTrue(filtered[0].id == "3")
	}
	
	func testPlantSearchMatchAll() throws {
		// given
		viewModel.searchText = "lat"
		viewModel.plants = [
			Plant(id: "1", latinName: "latin1", commonName: "common1", description: "desc1", pictureUrl: "url1", temperatureMin: 1, temperatureMax: 2, leafColor: "leafColor1", bloomColor: "bloomColor1", light: "light1", zoneMin: 1, zoneMax: 2),
			Plant(id: "2", latinName: "latin2", commonName: "common2", description: "desc2", pictureUrl: "url2", temperatureMin: 3, temperatureMax: 4, leafColor: "leafColor2", bloomColor: "bloomColor2", light: "light2", zoneMin: 3, zoneMax: 4),
			Plant(id: "3", latinName: "latin3", commonName: "common3", description: "desc3", pictureUrl: "url3", temperatureMin: 5, temperatureMax: 6, leafColor: "leafColor3", bloomColor: "bloomColor3", light: "light3", zoneMin: 5, zoneMax: 6),
			Plant(id: "4", latinName: "latin4", commonName: "common4", description: "desc4", pictureUrl: "url4", temperatureMin: 7, temperatureMax: 8, leafColor: "leafColor4", bloomColor: "bloomColor4", light: "light4", zoneMin: 7, zoneMax: 8),
			Plant(id: "5", latinName: "latin5", commonName: "common5", description: "desc5", pictureUrl: "url5", temperatureMin: 9, temperatureMax: 10, leafColor: "leafColor5", bloomColor: "bloomColor5", light: "light5", zoneMin: 9, zoneMax: 10)
		]
		
		// when
		let filtered = viewModel.filteredPlants
		
		// then
		XCTAssertTrue(filtered.count == 5)
	}
}
