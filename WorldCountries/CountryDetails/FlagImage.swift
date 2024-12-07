//
//  FlagImage.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import SwiftUI
import Kingfisher

/// Кастомный компонент для загрузки и отображения флагов стран
struct FlagImage: View {
    // Получаем текущую цветовую схему системы (темная/светлая)
    @Environment(\.colorScheme) private var colorScheme
    // Состояния для управления отображением ошибок
    @State private var showError = false
    @State private var errorMessage = ""
    
    // URL изображения флага
    let imageUrl: String
    // Фиксированный размер для всех флагов
    let size = CGSize(width: 100, height: 100)
    
    var body: some View {
        // Используем Kingfisher для асинхронной загрузки изображений
        KFImage(URL(string: imageUrl))
            // Отображаем индикатор загрузки пока изображение загружается
            .placeholder {
                ProgressView()
                    .controlSize(.extraLarge)
            }
            // Настройки кэши��ования и отображения
            .fade(duration: 1)                    // Плавное появление изображения
            .loadDiskFileSynchronously()          // Синхронная загрузка с диска
            .scaleFactor(UIScreen.main.scale)     // Учитываем масштаб экрана
            .cacheOriginalImage()                 // Кэшируем оригинальное изображение
            .memoryCacheExpiration(.never)        // Храним в памяти бессрочно
            .diskCacheExpiration(.never)          // Храним на диске бессрочно
            // Обработка ошибок при загрузке
            .onFailure { error in
                errorMessage = NSLocalizedString("noNetwork", comment: "")
                showError = true
            }
            // Настройки отображения изображения
            .resizable()
            .scaledToFit()
            // Добавляем тень (только в светлой теме)
            .shadow(
                color: .gray.opacity(colorScheme == .light ? 0.5 : 0),
                radius: 5,
                x: 0,
                y: 2
            )
            // Алерт для отображения ��шибок
            .alert("error", isPresented: $showError) {
                Button("ok") {
                    showError = false
                }
            } message: {
                Text(errorMessage)
            }
    }
}

// Превью для отображения компонента в Canvas
#Preview {
    FlagImage(
        imageUrl: "https://flagcdn.com/w320/gs.png"
    )
}
