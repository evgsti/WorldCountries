//
//  WorldCountriesDetailsViewModel.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import Foundation
import CoreLocation

class WorldCountriesDetailsViewModel: ObservableObject, Identifiable {
    let id = UUID()
    let locale = Locale.current.language.languageCode?.identifier ?? "en"
    
    var countryFlagUrl: String {
        country.flags.png
    }
    
    var countryNameCommon: String {
        switch locale {
        case "ru":
            return country.translations["rus"]?.common ?? country.name.common
        case "es":
            return country.translations["spa"]?.common ?? country.name.common
        default:
            return country.name.common
        }
    }
    
    var countryNameOfficial: String {
        switch locale {
        case "ru":
            return country.translations["rus"]?.official ?? country.name.official
        case "es":
            return country.translations["spa"]?.official ?? country.name.official
        default:
            return country.name.official
        }
    }
    
    var countryCurrencies: String {
        let currenciesInfo = country.currencies.map { (key, value) in
            "\(value.name) (\(value.symbol))"
        }
        return currenciesInfo.joined(separator: ", ")
    }
    
    var countryCapital: String {
        country.capital.first ?? "N/A"
    }
    
    var countryRegion: String {
        country.region
    }
    
    var countryLanguages: String {
        country.languages.values.joined(separator: ", ")
    }
    
    var countryArea: String {
        String(format: "%.2f km²", country.area)
    }
    
    var countryPopulation: String {
        "\(country.population)"
    }
    
    var countryTimezones: String {
        country.timezones.joined(separator: ", ")
    }
    
    var countryLatitude: Double {
        guard country.latlng.count >= 2 else { return 0.0 }
        return country.latlng[0]
    }
    
    var countryLongitude: Double {
        guard country.latlng.count >= 2 else { return 0.0 }
        return country.latlng[1]
    }
    
    var coordinates: CLLocationCoordinate2D? {
        CLLocationCoordinate2D(latitude: countryLatitude, longitude: countryLongitude)
    }
    
    private let networkManager = NetworkManager.shared
    //    private let dataManager = DataManager.shared
    private let country: Country
    
    init(country: Country) {
        self.country = country
    }
}
