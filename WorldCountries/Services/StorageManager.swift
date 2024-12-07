//
//  StorageManager.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import Foundation
import SwiftData

final class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    func saveCountries(_ countries: [Country], modelContext: ModelContext) throws {
        // Удаляем старые данные
        try modelContext.delete(model: CountryItem.self)
        
        // Сохраняем каждую страну в SwiftData
        for country in countries {
            let countryItem = CountryItem(
                id: UUID(),
                flags: country.flags.png,
                name: Names(
                    common: country.name.common,
                    official: country.name.official
                ),
                currency: Currency(
                    name: country.currencies.map { "\($0.value.name) (\($0.value.symbol))" }
                        .joined(separator: ", ")
                ),
                capital: country.capital.first ?? "",
                region: country.region,
                languages: country.languages.values.joined(separator: ", "),
                translations: country.translations,
                latitude: country.latlng[0],
                longitude: country.latlng[1],
                area: country.area,
                population: country.population,
                timezone: country.timezones.first ?? ""
            )
            modelContext.insert(countryItem)
        }
        
        // Сохраняем изменения
        try modelContext.save()
    }
    
    func deleteAllCountries(modelContext: ModelContext) throws {
        try modelContext.delete(model: CountryItem.self)
        try modelContext.save()
    }
}

