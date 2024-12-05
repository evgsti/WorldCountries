//
//  Country.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import Foundation

struct Country: Decodable {
    let name: String
    let imageUrl: String
}

extension Country {
    static func getCountry() -> Country {
        Country(
            name: "Страна",
            imageUrl: "https://flagcdn.com/w320/gs.png"
        )
    }
}
