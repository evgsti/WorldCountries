//
//  WorldCountriesApp.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import SwiftUI
import SwiftData

@main
struct WorldCountriesApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CountryItem.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            CountryListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
