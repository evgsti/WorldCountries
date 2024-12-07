//
//  Country.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

struct Country: Codable {
    let flags: Flag
    let name: Name
    let currencies: [String: Currencies]
    let capital: [String]
    let region: String
    let languages: [String: String]
    let translations: [String: Translation]
    let latlng: [Double]
    let area: Double
    let population: Int
    let timezones: [String]
}

struct Flag: Codable {
    let png: String
}

struct Name: Codable {
    let common: String
    let official: String
}

struct Currencies: Codable {
    let name: String
    let symbol: String
}

struct Translation: Codable {
    let common: String
    let official: String
}
