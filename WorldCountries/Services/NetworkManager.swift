//
//  NetworkManager.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import Foundation

/// Менеджер для работы с сетевыми запросами
final class NetworkManager {
    // Синглтон для доступа к менеджеру из любой части приложения
    static let shared = NetworkManager()
    // URLSession для выполнения сетевых запросов
    private let session: URLSession
    // Декодер для преобразования JSON в модели
    private let decoder: JSONDecoder
    // Максимальное количество попыток повторного запроса при ошибке
    private let retryLimit = 3
    // Время ожидания ответа от сервера в секундах
    private let timeout: TimeInterval = 30
    
    // Основные настройки сетевого менеджера
    private init() {
        let configuration = URLSessionConfiguration.default
        // Устанавливаем таймаут для запросов
        configuration.timeoutIntervalForRequest = timeout
        // Используем кэширование для оптимизации загрузки
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: configuration)
        self.decoder = JSONDecoder()
    }
    
    /// Получает список стран с API
    /// - Returns: Массив стран
    /// - Throws: NetworkError в случае ошибки
    // Метод для получения данных с повторными попытками при ошибке
    func fetchCountries() async throws -> [Country] {
        // Проверяем валидность URL перед выполнением запроса
        guard let url = URL(string: API) else {
            throw NetworkError.invalidURL
        }
        
        // Счетчик попыток выполнения запроса
        var attemptCount = 0
        
        // Цикл повторных попыток при возникновении ошибки
        while attemptCount < retryLimit {
            do {
                // Выполняем асинхронный запрос к серверу
                let (data, response) = try await session.data(from: url)
                
                // Проверяем, что ответ соответствует протоколу HTTP
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                // Обрабатываем различные коды состояния HTTP
                switch httpResponse.statusCode {
                case 200...299: // Успешный ответ
                    return try decoder.decode([Country].self, from: data)
                case 400...499: // Ошибки клиента (например, 404 Not Found)
                    throw NetworkError.clientError(httpResponse.statusCode)
                case 500...599: // Ошибки сервера
                    throw NetworkError.serverError(httpResponse.statusCode)
                default: // Неожиданные коды состояния
                    throw NetworkError.unexpectedStatusCode(httpResponse.statusCode)
                }
            } catch {
                attemptCount += 1
                if attemptCount == retryLimit {
                    throw error
                }
                // Экспоненциальная задержка перед повторной попыткой (1с, 2с, 3с)
                try await Task.sleep(nanoseconds: UInt64(1_000_000_000 * attemptCount))
            }
        }
        
        throw NetworkError.maxRetryLimitExceeded
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case clientError(Int)
    case serverError(Int)
    case unexpectedStatusCode(Int)
    case maxRetryLimitExceeded
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL"
        case .invalidResponse:
            return "Некорректный ответ сервера"
        case .decodingError:
            return "Ошибка декодирования данных"
        case .clientError(let code):
            return "Ошибка клиента: \(code)"
        case .serverError(let code):
            return "Ошибка сервера: \(code)"
        case .unexpectedStatusCode(let code):
            return "Неожиданный код ответа: \(code)"
        case .maxRetryLimitExceeded:
            return "Превышено количество попыток запроса"
        }
    }
}

var API: String {
    Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String ?? ""
}
