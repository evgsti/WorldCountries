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
    
    var filteredCountries: [CountryItem] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter { $0.name.common.localizedCaseInsensitiveContains(searchText) }
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
}
