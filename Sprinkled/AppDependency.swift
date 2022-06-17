//
//  AppDependency.swift
//  Sprinkled
//
//  Created by Lukáš Litvan on 04.06.2022.
//

final class AppDependency {
	fileprivate init() {}
	
	lazy var plantRepository: PlantRepositoryType = PlantRepository()
	lazy var plantEntryRepository: PlantEntryRepositoryType = PlantEntryRepository()
	lazy var teamRepository: TeamRepositoryType = TeamRepository()
	lazy var userRepository: UserRepositoryType = UserRepository()
	lazy var eventRepository: EventRepositoryType = EventRepository()
	lazy var notificationManager: NotificationManagerType = NotificationManager(dependencies: dependencies)
	lazy var reminderRepository: ReminderRepositoryType = ReminderRepository()
}

extension AppDependency: HasPlantRepository {}
extension AppDependency: HasPlantEntryRepository {}
extension AppDependency: HasTeamRepository {}
extension AppDependency: HasUserRepository {}
extension AppDependency: HasEventRepository {}
extension AppDependency: HasNotificationManager {}
extension AppDependency: HasReminderRepository {}

let dependencies = AppDependency()
