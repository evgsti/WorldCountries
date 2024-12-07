//
//  RowView.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import SwiftUI

/// Представление для отображения строки списка стран
struct RowView: View {
    /// Модель представления, содержащая данные о стране
    let viewModel: CountryDetailsViewModel
    
    var body: some View {
        HStack {
            // Отображение флага страны
            FlagImage(
                imageUrl: viewModel.countryFlagUrl
            )
            .frame(maxWidth: 100)
            
            // Контейнер с информацией о стране
            VStack(alignment: .leading) {
                // Название страны
                Text(viewModel.countryNameCommon)
                    .font(.title3)
                // Регион страны
                Text(viewModel.countryRegion)
                    .font(.subheadline)
            }
            
            Spacer()
            
            // Отображение звездочки для избранных стран
            if viewModel.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(Color("tint"))
            }
        }
    }
}

// Предварительный просмотр компонента
#Preview {
    RowView(
        viewModel: CountryDetailsViewModel(
            country: CountryItem.getCountry()
        )
    )
}
