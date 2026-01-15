import SwiftUI
import MapKit

struct MapSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var query: String = ""
    @State private var isSearching: Bool = false
    @State private var results: [MKMapItem] = []
    @State private var errorMessage: String?
    @State private var selectedItem: MKMapItem? = nil

    // Callback when a result is picked. Provide coordinate and the selected item.
    var onSelect: (CLLocationCoordinate2D, MKMapItem) -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                content
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
            .navigationDestination(item: $selectedItem) { item in
                LocationDetailView(item: item) { coordinate, item in
                    onSelect(coordinate, item)
                }
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search places", text: $query)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .submitLabel(.search)
                .onSubmit { Task { await performSearch() } }
            if !query.isEmpty {
                Button {
                    query = ""
                    results = []
                    errorMessage = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.thinMaterial, in: Capsule())
        .padding(.horizontal)
        .padding(.top)
    }

    @ViewBuilder
    private var content: some View {
        if isSearching {
            ProgressView("Searching…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let message = errorMessage {
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                Text(message)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if results.isEmpty {
            VStack(spacing: 8) {
                Image(systemName: "map")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                Text("Search for addresses, places, or landmarks.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List(results, id: \.self) { item in
                NavigationLink {
                    // Set selection and navigate via navigationDestination
                    selectedItem = item
                    return EmptyView()
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name ?? "Unnamed Place")
                            .font(.headline)
                        if let subtitle = subtitle(for: item) {
                            Text(subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }

    private func subtitle(for item: MKMapItem) -> String? {
        let placemark = item.placemark
        var parts: [String] = []
        if let subThoroughfare = placemark.subThoroughfare, let thoroughfare = placemark.thoroughfare {
            parts.append("\(subThoroughfare) \(thoroughfare)")
        } else if let thoroughfare = placemark.thoroughfare {
            parts.append(thoroughfare)
        }
        if let locality = placemark.locality { parts.append(locality) }
        if let administrativeArea = placemark.administrativeArea { parts.append(administrativeArea) }
        if let country = placemark.country { parts.append(country) }
        if parts.isEmpty, let title = placemark.title { return title }
        return parts.joined(separator: ", ")
    }

    @MainActor
    private func performSearch() async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            results = []
            errorMessage = nil
            return
        }
        isSearching = true
        errorMessage = nil
        do {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = trimmed
            // Optionally, bias to current region if available in future
            let search = MKLocalSearch(request: request)
            let response = try await search.start()
            await MainActor.run {
                self.results = response.mapItems
            }
        } catch {
            await MainActor.run {
                self.results = []
                self.errorMessage = "Couldn't complete the search. Please try again."
            }
        }
        isSearching = false
    }
}

#Preview {
    MapSearchView { coordinate, item in
        print("Selected: \(coordinate), name: \(item.name ?? "-")")
    }
}
