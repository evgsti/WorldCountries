//
//  FlagImage.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import SwiftUI
import Kingfisher

struct FlagImage: View {
    @Environment(\.colorScheme) private var colorScheme

    let imageUrl: String
    let size = CGSize(width: 100, height: 100)
    
    var body: some View {
        KFImage(URL(string: imageUrl))
            .placeholder {
                ProgressView()
                    .controlSize(.extraLarge)
            }
            //.setProcessor(DownsamplingImageProcessor(size: size))
            .fade(duration: 1)
            .loadDiskFileSynchronously()
            .scaleFactor(UIScreen.main.scale)
            .cacheOriginalImage()
            .memoryCacheExpiration(.never)
            .diskCacheExpiration(.never)
            .onSuccess { result in
                print("Изображение успешно загружено: \(result.source.url?.absoluteString ?? "")")
            }
            .onFailure { error in
                print("Ошибка загрузки: \(error.localizedDescription)")
            }
            .resizable()
            .scaledToFit()
            .shadow(
                color: .gray.opacity(colorScheme == .light ? 0.5 : 0),
                radius: 5,
                x: 0,
                y: 2
            )
    }
}

#Preview {
    FlagImage(
        imageUrl: "https://flagcdn.com/w320/gs.png"
    )
}
