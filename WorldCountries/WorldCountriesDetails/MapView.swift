//
//  MapView.swift
//  WorldCountries
//
//  Created by Евгений on 05.12.2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    let countryName: String
    let coordinate: CLLocationCoordinate2D
    
    @State private var position: MapCameraPosition
    
    init(countryName: String, coordinate: CLLocationCoordinate2D) {
        self.countryName = countryName
        self.coordinate = coordinate
        _position = State(initialValue: .region(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
        )))
    }

    var body: some View {
        Map(position: $position) {
            Marker(countryName, coordinate: coordinate)
        }
    }
}

#Preview {
    MapView(countryName: "Canada", coordinate: CLLocationCoordinate2D(latitude: 50.7749, longitude: -122.4194))
}
