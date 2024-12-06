//
//  WorldCountriesDetailsView.swift
//  WorldCountries
//
//  Created by Евгений on 06.12.2024.
//

import SwiftUI
import CoreLocation

struct WorldCountriesDetailsView: View {
    @StateObject var viewModel: WorldCountriesDetailsViewModel
    
    var body: some View {
        List {
            Section("flag") {
                FlagImage(imageUrl: viewModel.countryFlagUrl)
                    .listRowInsets(EdgeInsets())
                    .clipped()
            }
            
            Section("mainInfo") {
                InfoRow(title: "commonName", value: viewModel.countryNameCommon)
                InfoRow(title: "officialName", value: viewModel.countryNameOfficial)
                InfoRow(title: "capital", value: viewModel.countryCapital)
                InfoRow(title: "region", value: viewModel.countryRegion)
            }
            
            Section("additionalInfo") {
                InfoRow(title: "currencies", value: viewModel.countryCurrencies)
                InfoRow(title: "languages", value: viewModel.countryLanguages)
                InfoRow(title: "population", value: viewModel.countryPopulation)
                InfoRow(title: "area", value: viewModel.countryArea)
                InfoRow(title: "timeZones", value: viewModel.countryTimezones)
                
                if let coordinates = viewModel.coordinates {
                    MapView(
                        countryName: viewModel.countryNameCommon,
                        coordinate: coordinates
                    )
                    .frame(height: 300)
                    .listRowInsets(EdgeInsets())
                }
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.countryNameCommon)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(LocalizedStringKey(title))
                .foregroundStyle(.secondary)
                .font(.subheadline)
            Text(value)
                .font(.body)
        }
    }
}

#Preview {
    WorldCountriesDetailsView(viewModel: WorldCountriesDetailsViewModel(country: Country.getCountry()))
}
