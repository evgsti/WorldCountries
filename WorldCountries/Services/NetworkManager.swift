//
//  NetworkManager.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import Foundation

enum NetworkError: Error {
    case noData
    case invalidURL
    case decodingError
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchCountries() async throws -> [Country] {
        guard let url = URL(string: API) else {
            throw NetworkError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        guard let countries = try? decoder.decode([Country].self, from: data) else {
            throw NetworkError.decodingError
        }
        print(countries)
        return countries
    }
}

var API: String {
    //Bundle.main.object(forInfoDictionaryKey: "API_URL") as! String
    "https://restcountries.com/v3.1/all?fields=name,capital,population,area,currencies,languages,timezones,latlng,flags,region,translations"
}
