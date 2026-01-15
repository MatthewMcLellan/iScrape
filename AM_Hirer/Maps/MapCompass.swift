//
//  MapCompass.swift
//  AM_Hirer
//
//  Created by Matthew McLellan on 1/15/26.
//

import CoreLocation
internal import Foundation
import SwiftUI
import _MapKit_SwiftUI

@MainActor @preconcurrency
struct MapCompass: View {
    let scope: Namespace.ID

    init(scope: Namespace.ID) {
        self.scope = scope
    }

    var body: some View {
        // Placeholder compass UI; replace with real map compass integration as needed
        Image(systemName: "location.north.fill")
            .imageScale(.large)
            .rotationEffect(.degrees(0))
            //.padding(8)
            .background(.thinMaterial, in: Circle())
            .accessibilityLabel("Compass")
    }
}

struct CompassButtonTestView: View {
    @Namespace var mapScope
    var body: some View {
        VStack {
            Map(scope: mapScope)
            MapCompass(scope: mapScope)
            }
        .mapScope(mapScope)
    }
}

#Preview {
    
    CompassButtonTestView()
    
}
