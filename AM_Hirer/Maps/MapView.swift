//
//  MapView.swift
//  AM_Hirer
//
//  Created by Matthew McLellan on 1/15/26.
//

import CoreLocation
import SwiftUI
import MapKit
import GeoToolbox
import OSLog
import Combine

struct DowntownSeattle {
    @available(iOS 26.0, *)
    private static let descriptors: [PlaceDescriptor] = [
        PlaceDescriptor(
            representations: [.coordinate(CLLocationCoordinate2D(latitude: 47.606101, longitude: -122.332918))],
            commonName: "Downtown Seattle"
        )
    ]

    static func downtownMapItems() async throws -> [MKMapItem] {
        var items: [MKMapItem] = []
        if #available(iOS 26.0, *) {
            for descriptor in descriptors {
                let request = MKMapItemRequest(placeDescriptor: descriptor)
                if let item = try? await request.mapItem {
                    items.append(item)
                }
            }
        } else {
            // Fallback on earlier versions: create a basic MKMapItem from coordinate
            let coordinate = CLLocationCoordinate2D(latitude: 47.606101, longitude: -122.332918)
            let placemark = MKPlacemark(coordinate: coordinate)
            let item = MKMapItem(placemark: placemark)
            item.name = "Downtown Seattle"
            items = [item]
        }
        return items
    }
}

final class LocationObserver: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let last = locations.last {
            DispatchQueue.main.async { self.location = last }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Ignore errors for now
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
}


struct MapView: View {
    private struct CoordKey: Equatable {
        let lat: Double
        let lon: Double
    }

    @State private var downtown: [MKMapItem] = []
    @State private var selectedItem: MKMapItem?
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var mapRoute: MKRoute?
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var isFollowingUser: Bool = true
    
    @Binding var externalShowRecenter: Bool
    @Binding var externalRecenterRequest: Bool
    @Binding var externalTargetCoordinate: CLLocationCoordinate2D?

    init(
        externalShowRecenter: Binding<Bool> = .constant(false),
        externalRecenterRequest: Binding<Bool> = .constant(false),
        externalTargetCoordinate: Binding<CLLocationCoordinate2D?> = .constant(nil)
    ) {
        self._externalShowRecenter = externalShowRecenter
        self._externalRecenterRequest = externalRecenterRequest
        self._externalTargetCoordinate = externalTargetCoordinate
    }
    
    @State private var userCoordinate: CLLocationCoordinate2D?
    @State private var showRecenterButton: Bool = false
    @StateObject private var locationObserver = LocationObserver()
    //
    private let locationManager = CLLocationManager()
    
    var body: some View {
        Map(position: $cameraPosition, selection: $selectedItem) {
            UserAnnotation()
            ForEach(downtown, id: \.self) { item in
                Marker(item: item)
                    .mapItemDetailSelectionAccessory(.callout)
            }
            if let mapRoute {
                MapPolyline(mapRoute)
                    .stroke(Color.blue, lineWidth: 5)
            }
        }
        .contentMargins(20)
        .onMapCameraChange(frequency: .continuous) { context in
            guard let user = userCoordinate else {
                showRecenterButton = false
                return
            }
            let center = context.region.center
            let userPoint = MKMapPoint(user)
            let centerPoint = MKMapPoint(center)
            let distance = userPoint.distance(to: centerPoint) // in meters
            // Show button if panned away more than 150 meters
            showRecenterButton = distance > 150
            externalShowRecenter = showRecenterButton
            if distance > 150 {
                isFollowingUser = false
            }
        }
        .overlay(alignment: .bottomLeading) {
            if lookAroundScene != nil {
                LookAroundPreview(scene: $lookAroundScene)
                    .frame(width: 230, height: 140)
                    .cornerRadius(10)
                    .padding(8)
            }
        }
        .onChange(of: selectedItem) {
            if let selectedItem {
                Task {
                    let request = MKLookAroundSceneRequest(mapItem: selectedItem)
                    lookAroundScene = try? await request.scene
                }
                
                // Get cycling directions to the fountain.
                let request = MKDirections.Request()
                request.source = MKMapItem.forCurrentLocation()
                request.destination = selectedItem
                request.transportType = .cycling
                let directions = MKDirections(request: request)
                directions.calculate { response, error in
                    guard let response else {
                        let logger = Logger()
                        logger.error("Error calculating directions: \(error!)")
                        return
                    }
                    if let route = response.routes.first {
                        mapRoute = route
                    }
                }
            } else {
                lookAroundScene = nil
                mapRoute = nil
            }
        }
        .onAppear {
            locationManager.delegate = locationObserver
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            Task {
                do {
                    let items = try await DowntownSeattle.downtownMapItems()
                    downtown = items
                } catch {
                    // Ignore errors for now
                }
            }
        }
        .onReceive(locationObserver.$location) { newLocation in
            if let loc = newLocation?.coordinate {
                userCoordinate = loc
                if isFollowingUser {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        cameraPosition = .region(MKCoordinateRegion(
                            center: loc,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        ))
                        showRecenterButton = false
                        externalShowRecenter = false
                    }
                }
            }
        }
        .onChange(of: externalRecenterRequest) { newValue in
            if newValue {
                recenterToUser()
                // Reset the trigger so it can be used again
                externalRecenterRequest = false
            }
        }
        .onChange(of: externalTargetCoordinate.map { CoordKey(lat: $0.latitude, lon: $0.longitude) }) { _ in
            if let coord = externalTargetCoordinate {
                // Stop following user when jumping to a search target
                isFollowingUser = false
                withAnimation(.easeInOut(duration: 0.3)) {
                    cameraPosition = .region(MKCoordinateRegion(
                        center: coord,
                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                    ))
                }
                // Clear the target to avoid repeated jumps
                externalTargetCoordinate = nil
                // Indicate that the map is away from the user
                externalShowRecenter = true
            }
        }
    }
    
    private func recenterToUser() {
        guard let coord = userCoordinate else { return }
        isFollowingUser = true
        withAnimation(.easeInOut(duration: 0.25)) {
            cameraPosition = .region(MKCoordinateRegion(
                center: coord,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
            showRecenterButton = false
            externalShowRecenter = false
        }
    }
}

#Preview {
    MapView()
}

