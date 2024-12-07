//
//  WorldCountriesDetailsView.swift
//  WorldCountries
//
//  Created by Евгений on 06.12.2024.
//

import SwiftUI
import CoreLocation

// Основное представление с детальной информацией о стране
struct CountryDetailsView: View {
    // ViewModel для управления данными и бизнес-логикой
    @StateObject var viewModel: CountryDetailsViewModel
    // Контекст для работы с CoreData
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List {
            // Секция с флагом страны
            Section("flag") {
                FlagImage(imageUrl: viewModel.countryFlagUrl)
                    .listRowInsets(EdgeInsets())
            }
            
            // Секция с основной информацией
            Section("mainInfo") {
                InfoRow(title: "commonName", value: viewModel.countryNameCommon)
                InfoRow(title: "officialName", value: viewModel.countryNameOfficial)
                InfoRow(title: "capital", value: viewModel.countryCapital)
                InfoRow(title: "region", value: viewModel.countryRegion)
            }
            
            // Отображение карты, если доступны координаты
            Section("map") {
                if let coordinates = viewModel.coordinates {
                    MapView(
                        countryName: viewModel.countryNameCommon,
                        coordinate: coordinates
                    )
                    .frame(height: 300)
                    .listRowInsets(EdgeInsets())
                }
            }
            
            // Секция с дополнительной информацией
            Section("additionalInfo") {
                InfoRow(title: "currencies", value: viewModel.countryCurrencies)
                InfoRow(title: "languages", value: viewModel.countryLanguages)
                InfoRow(title: "population", value: viewModel.countryPopulation)
                InfoRow(title: "area", value: viewModel.countryArea)
                InfoRow(title: "timeZones", value: viewModel.countryTimezones)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.countryNameCommon)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                // Кнопка для шеринга информации о стране
                ShareLink(
                    item: """
                        \(viewModel.countryNameCommon)
                        
                        \(NSLocalizedString("officialName", comment: "")): \(viewModel.countryNameOfficial)
                        \(NSLocalizedString("capital", comment: "")): \(viewModel.countryCapital)
                        \(NSLocalizedString("region", comment: "")): \(viewModel.countryRegion)
                        
                        \(NSLocalizedString("currencies", comment: "")): \(viewModel.countryCurrencies)
                        \(NSLocalizedString("languages", comment: "")): \(viewModel.countryLanguages)
                        \(NSLocalizedString("population", comment: "")): \(viewModel.countryPopulation)
                        \(NSLocalizedString("area", comment: "")): \(viewModel.countryArea)
                        \(NSLocalizedString("timeZones", comment: "")): \(viewModel.countryTimezones)
                        """
                ) {
                    Image(systemName: "square.and.arrow.up")
                }
                
                // Кнопка для добавления/удаления из избранного
                Button {
                    viewModel.toggleFavorite(modelContext: modelContext)
                } label: {
                    Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                        .foregroundColor(viewModel.isFavorite ? .yellow : nil)
                }
            }
        }
        // Обработка и отображение ошибок
        .alertView(
            title: "error",
            message: viewModel.errorAlert?.message ?? "",
            isPresented: Binding(
                get: { viewModel.errorAlert != nil },
                set: { if !$0 { viewModel.errorAlert = nil } }
            ),
            onDismiss: {
                viewModel.errorAlert = nil
            }
        )
    }
}

// Переиспользуемый компонент для отображения строки информации
struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Локализованный заголовок
            Text(LocalizedStringKey(title))
                .foregroundStyle(.secondary)
                .font(.subheadline)
            // Значение
            Text(value)
                .font(.body)
        }
    }
}

#Preview {
    CountryDetailsView(viewModel: CountryDetailsViewModel(country: CountryItem.getCountry()))
}
