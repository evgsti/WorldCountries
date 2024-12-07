//
//  WorldCountriesDetailsViewModel.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import Foundation
import CoreLocation
import SwiftData

// ViewModel для отображения детальной информации о стране
class CountryDetailsViewModel: ObservableObject, Identifiable {
    // MARK: - Public Properties
    let id = UUID()
    
    // URL флага страны
    var countryFlagUrl: String {
        country.flags
    }
    
    // Общее название страны
    var countryNameCommon: String {
        getLocalizedName("common")
    }
    
    // Официальное название страны
    var countryNameOfficial: String {
        getLocalizedName("official")
    }
    
    // Валюты страны
    var countryCurrencies: String {
        country.currency.name
    }
    
    // Столица
    var countryCapital: String {
        country.capital
    }
    
    // Регион
    var countryRegion: String {
        country.region
    }
    
    // Языки
    var countryLanguages: String {
        country.languages
    }
    
    // Площадь с форматированием
    var countryArea: String {
        String(format: "%.2f km²", country.area)
    }
    
    // Население
    var countryPopulation: String {
        "\(country.population)"
    }
    
    // Часовые пояса
    var countryTimezones: String {
        country.timezone
    }
    
    // Широта
    var countryLatitude: Double {
        country.latitude
    }
    
    // Долгота
    var countryLongitude: Double {
        country.longitude
    }
    
    // Координаты для отображения на карте
    var coordinates: CLLocationCoordinate2D? {
        CLLocationCoordinate2D(latitude: countryLatitude, longitude: countryLongitude)
    }
    
    // Статус избранного
    @Published private(set) var isFavorite: Bool
    // Состояние ошибки для алерта
    @Published var errorAlert: ErrorAlert?
    
    // MARK: - Private Properties
    // Модель данных страны
    private let country: CountryItem
    private let storageManager = StorageManager.shared
    // Получаем текущую локализацию устройства
    let locale = Locale.current.language.languageCode?.identifier ?? "en"
    
    // MARK: - Initializers
    // Инициализация с моделью страны
    init(country: CountryItem) {
        self.country = country
        self.isFavorite = country.isFavorite
    }

    // MARK: - Public Methods
    // Переключение статуса избранного
    @MainActor
    func toggleFavorite(modelContext: ModelContext) {
        do {
            try storageManager.toggleFavorite(country, modelContext: modelContext)
            isFavorite = country.isFavorite
        } catch {
            errorAlert = ErrorAlert(
                title: "error",
                message: "favoriteUpdateError: \(error.localizedDescription)"
            )
        }
    }
    
    // MARK: - Private Methods
    // Получение локализованного названия страны
    private func getLocalizedName(_ nameType: String) -> String {
        // Маппинг кодов языков для API
        let languageMapping: [String: String] = [
            "ru": "rus",
            "es": "spa"
            // Добавление новых языков:
            // "fr": "fra",
            // "de": "deu"
        ]
        
        // Пытаемся получить перевод для текущей локализации
        if let languageCode = languageMapping[locale],
           let translation = country.translations[languageCode] {
            return nameType == "common" ? translation.common : translation.official
        }
        // Если перевод не найден, возвращаем стандартное название
        return nameType == "common" ? country.name.common : country.name.official
    }
    
    // Структура для отображения ошибок
    struct ErrorAlert: Identifiable {
        let id = UUID()
        let title: String
        let message: String
    }
}
