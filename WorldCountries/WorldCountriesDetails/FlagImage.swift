//
//  FlagImage.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import SwiftUI

struct FlagImage: View {
    let imageData: Data
    let imageSize: CGSize
    
    var body: some View {
        getImage(from: imageData)
            // Делаем изображение масштабируемым
            .resizable()
            // Устанавливаем размеры из переданных параметров
            .frame(width: imageSize.width, height: imageSize.height)
    }
    
    // Преобразует данные в изображение
    private func getImage(from data: Data) -> Image {
        // Пытаемся создать UIImage из данных
        guard let image = UIImage(data: data) else {
            // Если не получилось, возвращаем системную иконку флага
            return Image(systemName: "flag")
        }
        // Преобразуем UIImage в SwiftUI Image
        return Image(uiImage: image)
    }
}

#Preview {
    FlagImage(
        // Создаем пустые данные для превью
        imageData: Data(),
        // Задаем размер флага 100x100 пикселей
        imageSize: CGSize(width: 100, height: 100)
    )
}
