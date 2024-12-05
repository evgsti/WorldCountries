//
//  RowView.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import SwiftUI

struct RowView: View {
    let viewModel: WorldCountriesDetailsViewModel
    
    var body: some View {
        HStack {
            FlagImage(
                imageData: viewModel.countryFlagImage,
                imageSize: CGSize(width: 100, height: 100)
            )
            VStack (alignment: .leading) {
                Text(viewModel.countryName)
                    .font(.largeTitle)
                Text(viewModel.countryRegion)
                    .font(.subheadline)
            }
            Spacer()
        }
    }
}

#Preview {
    RowView(
        viewModel: WorldCountriesDetailsViewModel(
            country: Country.getCountry()
        )
    )
}
