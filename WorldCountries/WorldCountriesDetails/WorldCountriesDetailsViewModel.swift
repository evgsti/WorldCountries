//
//  WorldCountriesDetailsViewModel.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import Foundation

class WorldCountriesDetailsViewModel: ObservableObject {
    
    var countryName: String {
        //country.name
        "Страна"
    }
    
    var countryRegion: String {
        //country.name
        "Регион"
    }
    
    var countryFlagImage: Data {
        var imageData = Data()
        
//        do {
//            imageData = try networkManager.fetchImageData(from: counrty.flagImageUrl)
//        } catch {
//            print(error)
//        }
        
        return imageData
    }
    
//    private let networkManager = NetworkManager.shared
//    private let dataManager = DataManager.shared
    private let country: Country
    
    init(country: Country) {
        self.country = country
    }
}
