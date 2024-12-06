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
                imageUrl: viewModel.countryFlagUrl
            )
            .frame(maxWidth: 100)
            VStack(alignment: .leading) {
                Text(viewModel.countryNameCommon)
                    .font(.title3)
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
