//
//  ReverseGeocodeView.swift
//  AM_Hirer
//
//  Created by Matthew McLellan on 1/15/26.
//

import SwiftUI
internal import MapKit

struct ReverseGeocodeView: View {
    private let fountainCoordinates = [
        // PowderPigs Ski School, Snoqualmie, WA
        CLLocation(latitude: 47.402235, longitude: -121.410742),
        
        CLLocation(latitude: 47.653737, longitude: -122.304729),
        
        CLLocation(latitude: 47.630300, longitude: -122.391483)
    ]
    
    @State private var fountains: [MKMapItem] = []
    
    var body: some View {
        List {
            ForEach($fountains, id: \.name) { $fountain in
                VStack(alignment: .leading) {
                    Text(fountain.name ?? "Name")
                    if #available(iOS 26.0, *) {
                        Text(fountain.addressRepresentations?.cityWithContext ?? "City")
                            .font(.caption)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }
        .listStyle(.plain)
        .task {
            var fountainMapItems = [MKMapItem]()
            for coordinate in fountainCoordinates {
                if #available(iOS 26.0, *) {
                    if let request = MKReverseGeocodingRequest(location: coordinate) {
                        let mapitems = try? await request.mapItems
                        if let mapitem = mapitems?.first {
                            fountainMapItems.append(mapitem)
                        }
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
            fountains = fountainMapItems
        }
    }
}

#Preview {
    ReverseGeocodeView()
}
