//
//  WorldCountriesListView.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import SwiftUI

struct WorldCountriesListView: View {
    @StateObject private var viewModel = WorldCountriesViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.filteredCountries) { WorldCountriesDetailsViewModel in
                        NavigationLink(destination: WorldCountriesDetailsView(viewModel: WorldCountriesDetailsViewModel)) {
                            RowView(viewModel: WorldCountriesDetailsViewModel)
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
            await viewModel.fetchCountries()
        }
    }
}

#Preview {
    WorldCountriesListView()
}
