//
//  RowView.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import SwiftUI

struct RowView: View {
    let viewModel: CountryDetailsViewModel
    
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
            if viewModel.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}

#Preview {
    RowView(
        viewModel: CountryDetailsViewModel(
            country: CountryItem.getCountry()
        )
    )
}
