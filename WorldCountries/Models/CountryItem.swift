//
//  CountryItem.swift
//  WorldCountries
//
//  Created by Евгений on 07.12.2024.
//

import Foundation
import SwiftData

@Model
final class CountryItem: Identifiable {
    var id: UUID
    var flags: String
    var name: Names
    var currency: Currency
    var capital: String
    var region: String
    var languages: String
    var translations: [String: Translation]
    var latitude: Double
    var longitude: Double
    var area: Double
    var population: Int
    var timezones: String
    var isFavorite: Bool
    
    init(
        id: UUID,
        flags: String,
        name: Names,
        currency: Currency,
        capital: String,
        region: String,
        languages: String,
        translations: [String: Translation],
        latitude: Double,
        longitude: Double,
        area: Double,
        population: Int,
        timezone: String,
        isFavorite: Bool
    ) {
        self.id = id
        self.flags = flags
        self.name = name
        self.currency = currency
        self.capital = capital
        self.region = region
        self.languages = languages
        self.translations = translations
        self.latitude = latitude
        self.longitude = longitude
        self.area = area
        self.population = population
        self.timezones = timezone
        self.isFavorite = isFavorite
    }
}

@Model
final class Names {
    var common: String
    var official: String

    init(common: String, official: String) {
        self.common = common
        self.official = official
    }
}

@Model
final class Currency {
    var name: String

    init(name: String) {
        self.name = name
    }
}

@Model
final class Translations {
    var common: String
    var official: String
    
    init(common: String, official: String) {
        self.common = common
        self.official = official
    }
}

extension CountryItem {
    static func getCountry() -> CountryItem {
        CountryItem(
            id: UUID(),
            flags: "https://flagcdn.com/w320/ru.png",
            name: Names(
                common: "Россия",
                official: "Российская Федерация"
            ),
            currency: Currency(
                name: "Российский рубль (₽)"
            ),
            capital: "Москва",
            region: "Европа",
            languages: "Русский",
            translations: [
                "eng": Translation(
                    common: "Russia",
                    official: "Russian Federation"
                )
            ],
            latitude: 55.7558,
            longitude: 37.6173,
            area: 17098246,
            population: 144104080,
            timezone: "UTC+3",
            isFavorite: true
        )
    }
}
