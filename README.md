# WorldCountries

Мобильное приложение для iOS, отображающее информацию о странах мира с возможностью добавления в избранное.

## Технологии

- Swift 5.0
- SwiftUI
- SwiftData для локального хранения
- Kingfisher для загрузки изображений
- Async/await для асинхронных операций
- MVVM архитектура

## Основные возможности

- Получение данных о странах через REST API
- Отображение списка стран с поиском
- Детальная информация о каждой стране
- Локализация на русском и английском языках
- Поддержка светлой и темной темы
- Добавление стран в избранное
- Отображение местоположения страны на карте
- Кэширование данных
- Обработка ошибок и состояний загрузки

## Требования

- iOS 18.1+
- Xcode 16.1+
- Swift 5.0+

## Установка

1. Клонировать репозиторий: Xcode > Integrate > Clone > вставить ссылку на репозиторий > нажать Clone
2. Открыть WorldCountries.xcodeproj в Xcode
3. Выбрать целевое устройство
4. Нажать Run (⌘ + R)

## Архитектурные решения

- MVVM для разделения логики и представления
- Синглтоны для сетевого и локального менеджеров
- SwiftData для хранения данных
- Async/await для асинхронных операций
- Кэширование изображений с Kingfisher
- Локализация через String Catalog

## Особенности реализации

- Поддержка офлайн режима через локальное хранилище
- Обработка ошибок сети с повторными попытками
- Адаптивный интерфейс для разных устройств
- Оптимизированная загрузка изображений
- Кастомные модификаторы для переиспользования

## API

Приложение использует [REST Countries API](https://restcountries.com/) для получения данных о странах.
