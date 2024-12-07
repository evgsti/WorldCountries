//
//  WorldCountriesListView.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import SwiftUI

enum CountryFilter {
    case all
    case favorites
}

struct CountryListView: View {
    @StateObject var viewModel = CountryViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.filteredCountries) { country in
                        let countryDetailsViewModel = CountryDetailsViewModel(country: country)
                        NavigationLink(destination: CountryDetailsView(viewModel: countryDetailsViewModel)) {
                            RowView(viewModel: countryDetailsViewModel)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            if viewModel.currentFilter == .favorites {
                                Button(role: .destructive) {
                                    viewModel.removeFromFavorites(country, modelContext: modelContext)
                                } label: {
                                    Image(systemName: "star.slash.fill")
                                }
                            }
                        }
                    }
                }
                .navigationTitle("worldCountries")
                .searchable(
                    text: $viewModel.searchText
                )
                .disabled(viewModel.isLoading)
                
                if viewModel.isLoading {
                    ProgressView()
                        .controlSize(.large)
                        .progressViewStyle(CircularProgressViewStyle())
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
        }
        .task {
            await viewModel.fetchCountries(modelContext: modelContext)
        }
    }
}

#Preview {
    CountryListView()
}
