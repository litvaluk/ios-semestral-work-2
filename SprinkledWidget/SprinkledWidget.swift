//
//  SprinkledWidget.swift
//  SprinkledWidget
//
//  Created by Lukáš Litvan on 18.06.2022.
//

import WidgetKit
import SwiftUI
import Intents
import FirebaseCore

struct SprinkledWidgetProvider: IntentTimelineProvider {
	func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SprinkledWidgetEntry>) -> Void) {
		Task {
			let date = Date()
			let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: date)!
			do {
				let randomPlant = try await dependencies.plantRepository.getAll().randomElement()!
				let entry = SprinkledWidgetEntry(date: date, configuration: configuration, latinName: randomPlant.latinName, commonName: randomPlant.commonName!, imageUrl: URL(string: randomPlant.pictureUrl!))
				completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
			} catch {
				print("Failed to fetch plants.")
				completion(Timeline(entries: [], policy: .after(nextUpdate)))
			}
		}
	}
	
	typealias Dependencies = HasPlantRepository
	private let dependencies: Dependencies
	
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
	}
	
    func placeholder(in context: Context) -> SprinkledWidgetEntry {
		.previewEntry
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SprinkledWidgetEntry) -> ()) {
		completion(.previewEntry)
    }
}

struct SprinkledWidgetEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
	let latinName: String
	let commonName: String
	let imageUrl: URL?
	
	static let previewEntry = SprinkledWidgetEntry(date: .now, configuration: ConfigurationIntent(), latinName: "Latin name", commonName: "Common name", imageUrl: URL(string: "http://www.tropicopia.com/house-plant//thumbnails/5604.jpg"))
}

struct SprinkledWidgetEntryView : View {
    var entry: SprinkledWidgetProvider.Entry

    var body: some View {
		ZStack(alignment: .bottomLeading) {
			Rectangle().overlay {
				getImageFromUrl(url: entry.imageUrl)
					.resizable()
					.aspectRatio(contentMode: .fill)
			}
			LinearGradient(colors: [.black, .black.opacity(0), .black.opacity(0)], startPoint: .bottom, endPoint: .top)
			VStack(alignment: .leading) {
				Text(entry.latinName)
					.multilineTextAlignment(.leading)
					.foregroundColor(.white)
					.font(.caption)
				Text(entry.commonName)
					.multilineTextAlignment(.leading)
					.foregroundColor(.white)
					.font(.caption2)
			}
			.padding()
		}
    }
	
	func getImageFromUrl(url: URL?) -> Image {
		if let url = url, let imageData = try? Data(contentsOf: url), let uiImage = UIImage(data: imageData) {
			return Image(uiImage: uiImage)
		}
		else {
			return Image("NoImage")
		}
	}
}

@main
struct SprinkledWidget: Widget {
	init() {
		FirebaseApp.configure()
	}
		
    let kind: String = "SprinkledWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: SprinkledWidgetProvider(dependencies: dependencies)) { entry in
            SprinkledWidgetEntryView(entry: entry)
        }
		.supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .configurationDisplayName("Random plant")
        .description("See random plant from Sprinkled database.")
    }
}

struct SprinkledWidget_Previews: PreviewProvider {
    static var previews: some View {
		SprinkledWidgetEntryView(entry: .previewEntry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
