//
//  WorldCountriesListView.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import SwiftUI

// Перечисление для фильтрации списка стран
enum CountryFilter {
    case all        // Показать все страны
    case favorites  // Показать только избранные
}

struct CountryListView: View {
    // StateObject для хранения и управления данными стран
    @StateObject var viewModel = CountryViewModel()
    // Доступ к контексту модели для работы с CoreData
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    // Отображение списка стран с возможностью навигации
                    ForEach(viewModel.filteredCountries) { country in
                        let countryDetailsViewModel = CountryDetailsViewModel(
                            country: country
                        )
                        NavigationLink(
                            destination: CountryDetailsView(
                                viewModel: countryDetailsViewModel
                            )
                        ) {
                            RowView(viewModel: countryDetailsViewModel)
                        }
                        // Добавление действия свайпа для удаления из избранного
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            if viewModel.currentFilter == .favorites {
                                Button() {
                                    viewModel.removeFromFavorites(
                                        country,
                                        modelContext: modelContext
                                    )
                                } label: {
                                    Image(systemName: "star.slash.fill")
                                }
                            }
                        }
                    }
                }
                // Настройка навигационной панели и поиска
                .navigationTitle("worldCountries")
                .searchable(
                    text: $viewModel.searchText  // Привязка текста поиска
                )
                .disabled(viewModel.countries.isEmpty)
                // Кнопка для повторной загрузки списка стран
                .toolbar {
                    if viewModel.loadingFailed {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                Task {
                                    await viewModel.fetchCountries(
                                        modelContext: modelContext
                                    )
                                }
                            } label: {
                                Image(systemName: "arrow.clockwise")
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                            Picker("", selection: $viewModel.currentFilter) {
                                Text(LocalizedStringKey("allCountries"))
                                    .tag(CountryFilter.all)
                                Text(LocalizedStringKey("favorites"))
                                    .tag(CountryFilter.favorites)
                            }
                            .pickerStyle(.segmented)
                    }
                }
                // Индикатор загрузки
                if viewModel.isLoading {
                    ProgressView()
                        .controlSize(.large)
                }
            }
        }
        .tint(Color("tint"))
        // Загрузка данных при появлении представления
        .task {
            await viewModel.fetchCountries(modelContext: modelContext)
        }
        // Отображение алерта с ошибкой
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

#Preview {
    CountryListView()
}
