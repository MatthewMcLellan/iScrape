import SwiftUI
internal import MapKit

struct LocationDetailView: View {
    let item: MKMapItem
    var onUseLocation: ((CLLocationCoordinate2D, MKMapItem) -> Void)?

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.name ?? "Unnamed Place")
                        .font(.title2)
                        .fontWeight(.semibold)
                    if let address = formattedAddress(from: item.placemark) {
                        Text(address)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }

            Section("Location") {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundStyle(.secondary)
                    Text("Latitude: \(item.placemark.coordinate.latitude), Longitude: \(item.placemark.coordinate.longitude)")
                        .font(.footnote)
                }
            }

            Section("Actions") {
                if let onUseLocation {
                    Button {
                        onUseLocation(item.placemark.coordinate, item)
                    } label: {
                        Label("Use This Location", systemImage: "checkmark.circle.fill")
                    }
                }
                Button {
                    openInMaps(item: item)
                } label: {
                    Label("Open in Apple Maps", systemImage: "map.fill")
                }
                if let address = formattedAddress(from: item.placemark) {
                    Button {
                        UIPasteboard.general.string = address
                    } label: {
                        Label("Copy Address", systemImage: "doc.on.doc")
                    }
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formattedAddress(from placemark: MKPlacemark) -> String? {
        var parts: [String] = []
        if let subThoroughfare = placemark.subThoroughfare, let thoroughfare = placemark.thoroughfare {
            parts.append("\(subThoroughfare) \(thoroughfare)")
        } else if let thoroughfare = placemark.thoroughfare {
            parts.append(thoroughfare)
        }
        if let locality = placemark.locality { parts.append(locality) }
        if let administrativeArea = placemark.administrativeArea { parts.append(administrativeArea) }
        if let postalCode = placemark.postalCode { parts.append(postalCode) }
        if let country = placemark.country { parts.append(country) }
        if parts.isEmpty, let title = placemark.title { return title }
        return parts.joined(separator: ", ")
    }

    private func openInMaps(item: MKMapItem) {
        item.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}

#Preview {
    let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090))
    let item = MKMapItem(placemark: placemark)
    item.name = "Apple Park"
    return NavigationStack {
        LocationDetailView(item: item) { _, _ in }
    }
}
