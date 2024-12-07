//
//  WorldCountriesViewModel.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import Foundation
import SwiftData

@MainActor
final class CountryViewModel: ObservableObject {
    // MARK: - Public Properties
    /// Текст для поиска стран
    @Published var searchText = ""
    /// Индикатор загрузки данных
    @Published var isLoading = false
    /// Текущий фильтр для отображения стран
    @Published var currentFilter: CountryFilter = .all
    /// Алерт для отображения ошибок
    @Published var errorAlert: ErrorAlert?
    /// Флаг неудачной загрузки
    @Published var loadingFailed = false
    
    /// Проверяет наличие избранных стран
    var hasFavorites: Bool {
        countries.contains { $0.isFavorite }
    }
    
    /// Возвращает отфильтрованный и отсортированный список стран
    var filteredCountries: [CountryItem] {
        // Определяем текущую локализацию
        let locale = Locale.current.language.languageCode?.identifier ?? "en"
        
        // Выбираем ключ перевода в зависимости от локализации
        let translationKey = switch locale {
            case "ru": "rus"
            case "es": "spa"
            default: "eng"
        }
        
        // Фильтруем по избранному
        let filtered = if currentFilter == .favorites {
            countries.filter { $0.isFavorite }
        } else {
            countries
        }
        
        // Применяем поиск и сортировку
        if searchText.isEmpty {
            return filtered.sorted { $0.name.common < $1.name.common }
        } else {
            return filtered
                .filter { country in
                    let localizedName = country.translations[translationKey]?.common ?? country.name.common
                    return localizedName.localizedCaseInsensitiveContains(searchText)
                }
                .sorted { $0.name.common < $1.name.common }
        }
    }
    
    // MARK: - Private Properties
    /// Массив всех стран
    @Published private(set) var countries: [CountryItem] = []
    /// Менеджер для сетевых запросов
    private let networkManager = NetworkManager.shared
    /// Менеджер для работы с хранилищем данных
    private let storageManager = StorageManager.shared
    
    // MARK: - Public Types
    /// Структура для представления ошибок в UI
    struct ErrorAlert: Identifiable {
        let id = UUID()
        let title: String
        let message: String
    }
    
    // MARK: - Public Methods
    /// Загружает список стран из локального хранилища или сети
    func fetchCountries(modelContext: ModelContext) async {
        isLoading.toggle()
        do {
            let descriptor = FetchDescriptor<CountryItem>()
            countries = try modelContext.fetch(descriptor)
            
            if countries.isEmpty {
                let newCountries = try await networkManager.fetchCountries()
                try storageManager.saveCountries(newCountries, modelContext: modelContext)
                countries = try modelContext.fetch(descriptor)
            }
        } catch {
            errorAlert = ErrorAlert(
                title: "error",
                message: "noNetwork"
            )
            loadingFailed.toggle()
        }
        isLoading.toggle()
    }
    
    /// Удаляет страну из избранного
    @MainActor
    func removeFromFavorites(_ country: CountryItem, modelContext: ModelContext) {
        do {
            try storageManager.toggleFavorite(country, modelContext: modelContext)
            if let index = countries.firstIndex(where: { $0.id == country.id }) {
                countries[index].isFavorite.toggle()
            }
        } catch {
            errorAlert = ErrorAlert(
                title: "error",
                message: "favoriteDeleteError"
            )
        }
    }
}
