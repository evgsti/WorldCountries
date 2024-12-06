//
//  Country.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import Foundation

struct Country: Decodable {
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

struct Flag: Decodable {
    let png: String
}

struct Name: Decodable {
    let common: String
    let official: String
}

struct Currencies: Decodable {
    let name: String
    let symbol: String
}

struct Translation: Decodable {
    let common: String
    let official: String
}

extension Country {
    static func getCountry() -> Country {
        Country(
            flags: Flag(png: "https://flagcdn.com/w320/gs.png"),
            name: Name(
                common: "South Georgia",
                official: "South Georgia and the South Sandwich Islands"
            ),
            currencies: ["SHP" : Currencies(
                name: "Saint Helena Pound",
                symbol: "£"
            )],
            capital: ["King Edward Point"],
            region: "Antarctic",
            languages: ["eng" : "English"],
            translations: ["rus": Translation(
                common: "Южная Георгия и Южные Сандвичевы острова",
                official: "Южная Георгия и Южные Сандвичевы острова"
            )],
            latlng: [-54.5, -37],
            area: 3903,
            population: 30,
            timezones: ["UTC-02:00"]
        )
    }
}
