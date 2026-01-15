import CoreLocation
import SwiftUI
import MapKit
import GeoToolbox
import OSLog

struct MainTabView: View {
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            GeocodeView()
                .tabItem {
                    Label("Geocode", systemImage: "globe")
                }
            
            ReverseGeocodeView()
                .tabItem {
                    Label("Reverse Geocode", systemImage: "globe.fill")
                }
        }
        .accentColor(.blue)
    }
}

// MARK: - Preview

#Preview {
    MainTabView()
}
