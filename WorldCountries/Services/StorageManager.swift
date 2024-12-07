//
//  StorageManager.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import Foundation
import SwiftData

final class StorageManager {
    /// Синглтон для доступа к менеджеру хранилища
    static let shared = StorageManager()
    
    /// Приватный инициализатор для обеспечения синглтона
    private init() {}
    
    /// Сохраняет массив стран в базу данных SwiftData
    /// - Parameters:
    ///   - countries: Массив стран для сохранения
    ///   - modelContext: Контекст модели SwiftData
    /// - Throws: Ошибки при работе с базой данных
    func saveCountries(_ countries: [Country], modelContext: ModelContext) throws {
        // Очищаем старые данные перед сохранением новых
        try modelContext.delete(model: CountryItem.self)
        
        // Перебираем каждую страну и создаем объекты CountryItem
        for country in countries {
            // Создаем новый объект CountryItem с данными из country
            let countryItem = CountryItem(
                id: UUID(),                    // Уникальный идентификатор
                flags: country.flags.png,      // URL флага страны
                name: Names(                   // Названия страны
                    common: country.name.common,
                    official: country.name.official
                ),
                currency: Currency(            // Информация о валюте
                    name: country.currencies.map { "\($0.value.name) - \($0.value.symbol)" }
                        .joined(separator: ", ")
                ),
                capital: country.capital.first ?? "",  // Столица
                region: country.region,               // Регион
                languages: country.languages.values.joined(separator: ", "),  // Языки
                translations: country.translations,    // Переводы названия
                latitude: country.latlng[0],          // Широта
                longitude: country.latlng[1],         // Долгота
                area: country.area,                   // Площадь
                population: country.population,        // Население
                timezone: country.timezones.first ?? "",  // Часовой пояс
                isFavorite: false                     // Флаг избранного
            )
            // Добавляем созданный объект в контекст
            modelContext.insert(countryItem)
        }
        
        // Сохраняем все изменения в базе данных
        try modelContext.save()
    }
    
    /// Переключает состояние избранного для страны
    /// - Parameters:
    ///   - country: Страна для изменения
    ///   - modelContext: Контекст модели SwiftData
    /// - Throws: Ошибки при сохранении изменений
    func toggleFavorite(_ country: CountryItem, modelContext: ModelContext) throws {
        country.isFavorite.toggle()  // Инвертируем значение флага избранного
        try modelContext.save()      // Сохраняем изменения
    }
}

