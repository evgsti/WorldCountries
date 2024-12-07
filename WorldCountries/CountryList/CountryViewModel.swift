//
//  WorldCountriesViewModel.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import Foundation
import SwiftData

@MainActor
final class CountryViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var isLoading = false
    @Published private(set) var countries: [CountryItem] = []
    @Published var currentFilter: CountryFilter = .all
    
    var filteredCountries: [CountryItem] {
        let locale = Locale.current.language.languageCode?.identifier ?? "en"
        let translationKey = switch locale {
            case "ru": "rus"
            case "es": "spa"
            default: "eng"
        }
        
        let filtered = if currentFilter == .favorites {
            countries.filter { $0.isFavorite }
        } else {
            countries
        }
        
        if searchText.isEmpty {
            return filtered.sorted { $0.name.common < $1.name.common }
        } else {
            return filtered
                .filter { country in
                    let localizedName = country.translations[translationKey]?.common ?? country.name.common
                    return localizedName.localizedCaseInsensitiveContains(searchText)
                }
                .sorted { $0.name.common < $1.name.common }
        }
    }
    
    private let networkManager = NetworkManager.shared
    private let storageManager = StorageManager.shared
    
    func fetchCountries(modelContext: ModelContext) async {
        isLoading = true
        do {
            // Сначала пробуем загрузить данные из SwiftData
            let descriptor = FetchDescriptor<CountryItem>()
            countries = try modelContext.fetch(descriptor)
            
            // Если данных нет, загружаем их из сети
            if countries.isEmpty {
                let newCountries = try await networkManager.fetchCountries()
                try storageManager.saveCountries(newCountries, modelContext: modelContext)
                countries = try modelContext.fetch(descriptor)
            }
        } catch {
            print("Ошибка при загрузке стран: \(error)")
        }
        isLoading = false
    }
    
    @MainActor
    func removeFromFavorites(_ country: CountryItem, modelContext: ModelContext) {
        do {
            try storageManager.toggleFavorite(country, modelContext: modelContext)
            if let index = countries.firstIndex(where: { $0.id == country.id }) {
                countries[index].isFavorite = false
            }
        } catch {
            print("Ошибка при удалении из избранного: \(error)")
        }
    }
}
