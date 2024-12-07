//
//  MapView.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import SwiftUI
import MapKit

/// Представление для отображения карты с маркером страны
struct MapView: View {
    /// Название страны для отображения на маркере
    let countryName: String
    /// Географические координаты центра страны
    let coordinate: CLLocationCoordinate2D
    
    /// Позиция камеры на карте, управляет отображаемой областью
    @State private var position: MapCameraPosition
    
    /// Инициализатор представления карты
    /// - Parameters:
    ///   - countryName: Название страны
    ///   - coordinate: Координаты центра страны
    init(countryName: String, coordinate: CLLocationCoordinate2D) {
        self.countryName = countryName
        self.coordinate = coordinate
        // Устанавливаем начальную позицию камеры с масштабом 15 градусов
        _position = State(initialValue: .region(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
        )))
    }

    /// Тело представления
    var body: some View {
        // Отображаем карту с привязанной позицией камеры
        Map(position: $position) {
            // Добавляем маркер с названием страны в указанных координатах
            Marker(countryName, coordinate: coordinate)
        }
    }
}

/// Предварительный просмотр представления с тестовыми данными
#Preview {
    MapView(
        countryName: "Canada",
        coordinate: CLLocationCoordinate2D(latitude: 50.7749, longitude: -122.4194)
    )
}
