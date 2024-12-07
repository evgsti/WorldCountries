//
//  WorldCountriesListView.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import SwiftUI

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
        }
        .task {
            await viewModel.fetchCountries(modelContext: modelContext)
        }
    }
}

#Preview {
    CountryListView()
}
