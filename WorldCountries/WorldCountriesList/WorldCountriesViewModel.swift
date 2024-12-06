//
//  WorldCountriesViewModel.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import Foundation

@MainActor
class WorldCountriesViewModel: ObservableObject {
    @Published var rows: [WorldCountriesDetailsViewModel] = []
    @Published var searchText = ""
    @Published var isLoading = false
    
    var filteredCountries: [WorldCountriesDetailsViewModel] {
        if searchText.isEmpty {
            return rows
        } else {
            return rows.filter { $0.countryNameCommon.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    private let networkManager = NetworkManager.shared
    
    func fetchCountries() async {
        isLoading = true
        do {
            let countries = try await networkManager.fetchCountries()
            rows = countries
                .sorted { $0.name.common < $1.name.common }
                .map { WorldCountriesDetailsViewModel(country: $0) }
        } catch {
            print(error)
        }
        isLoading = false
    }
}
