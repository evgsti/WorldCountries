//
//  WorldCountriesDetailsViewModel.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import Foundation
import CoreLocation

class CountryDetailsViewModel: ObservableObject, Identifiable {
    let id = UUID()
    let locale = Locale.current.language.languageCode?.identifier ?? "en"
    
    var countryFlagUrl: String {
        country.flags
    }
    
    var countryNameCommon: String {
        switch locale {
        case "ru":
            return country.translations["rus"]?.common ?? country.name.common
        case "es":
            return country.translations["spa"]?.common ?? country.name.common
        default:
            return country.name.official
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
        country.currency.name
    }
    
    var countryCapital: String {
        country.capital
    }
    
    var countryRegion: String {
        country.region
    }
    
    var countryLanguages: String {
        country.languages
    }
    
    var countryArea: String {
        String(format: "%.2f km²", country.area)
    }
    
    var countryPopulation: String {
        "\(country.population)"
    }
    
    var countryTimezones: String {
        country.timezone
    }
    
    var countryLatitude: Double {
        country.latitude
    }
    
    var countryLongitude: Double {
        country.longitude
    }
    
    var coordinates: CLLocationCoordinate2D? {
        CLLocationCoordinate2D(latitude: countryLatitude, longitude: countryLongitude)
    }
    
    private let networkManager = NetworkManager.shared
    private let country: CountryItem
    
    init(country: CountryItem) {
        self.country = country
    }
}
