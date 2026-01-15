//
//  ContentView.swift
//  AM_Hirer
//
//  Created by Matthew McLellan on 12/17/25.
//

import SwiftUI
import MapKit
import _MapKit_SwiftUI
import UIKit

private enum OverlaySheet: Identifiable {
    case home, geocode, reverse
    var id: Int { hashValue }
}

struct PressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: configuration.isPressed)
    }
}

struct ContentView: View {
    @State private var showingMenu = false
    @State private var activeSheet: OverlaySheet?
    @State private var lastSelected: OverlaySheet?
    @State private var showControls = true
    @State private var showRecenter = false
    @State private var recenterRequest = false
    @State private var searchText = ""
    @State private var isSearchExpanded = false
    @State private var showingMapSearch = false
    @State private var searchTargetCoordinate: CLLocationCoordinate2D?
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        ZStack {
            // Always-displayed map background
            MapView(
                externalShowRecenter: $showRecenter,
                externalRecenterRequest: $recenterRequest,
                externalTargetCoordinate: $searchTargetCoordinate
            )
            .ignoresSafeArea()
            
            // Floating hamburger button (top-left)
            VStack {
                HStack {
                    Button {
                        tapHaptic()
                        showingMenu = true
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.primary)
                            .padding(10)
                            .background(.thinMaterial, in: Circle())
                    }
                    .accessibilityLabel("Menu")
                    .shadow(radius: 2, x: 0, y: 1)
                    .buttonStyle(PressableStyle())
                    
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 12)
            .padding(.leading, 12)
            .opacity(showControls ? 1 : 0)
            .zIndex(1)
            //.offset(y: showControls ? 0 : -10)
            
            // Floating recenter button (top-right, device-relative)
            VStack {
                HStack {
                    Spacer()
                    Button {
                        tapHaptic()
                        recenterRequest = true
                    } label: {
                        Image(systemName: "location.north.line.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                            .padding(10)
                            .background(.thinMaterial, in: Circle())
                    }
                    .accessibilityLabel("Recenter")
                    .shadow(radius: 2, x: 0, y: 1)
                    .buttonStyle(PressableStyle())
                    .opacity(showRecenter ? 1.0 : 0.45)
                }
                Spacer()
            }
            .padding(.top, 12)
            .padding(.trailing, 12)
            .opacity(showControls ? 1 : 0)
            .offset(y: showControls ? 0 : -10)
            .zIndex(1)
            
            // Tap-catcher to collapse search when expanded
            if isSearchExpanded {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { collapseSearch() }
                    .ignoresSafeArea()
                    .zIndex(1.5)
            }
            
            // Top-center expandable search bar
            VStack {
                HStack {
                    Spacer()
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.primary)
                        if isSearchExpanded {
                            TextField("Search", text: $searchText)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .submitLabel(.search)
                                .focused($isSearchFieldFocused)
                            if !searchText.isEmpty {
                                Button {
                                    searchText = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                                .buttonStyle(PressableStyle())
                            }
                        } else {
                            Text("Search")
                                .foregroundStyle(.secondary)
                                .font(.footnote)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(width: isSearchExpanded ? 280 : 140)
                    .background(.thinMaterial, in: Capsule())
                    .shadow(radius: 2, x: 0, y: 1)
                    .onTapGesture {
                        tapHaptic()
                        showingMapSearch = true
                    }
                    .onSubmit {
                        performSearch()
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding(.top, 12)
            .opacity(showControls ? 1 : 0)
            .zIndex(2)
            
            // Floating bottom toolbar
            VStack {
                Spacer()
                HStack(spacing: 24) {
                    Button {
                        tapHaptic()
                        lastSelected = .home
                        activeSheet = .home
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "house.fill")
                            Text("Home")
                                .font(.caption2)
                        }
                        .foregroundStyle(lastSelected == .home ? .blue : .primary)
                        .frame(minWidth: 60)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(PressableStyle())
                    
                    Button {
                        tapHaptic()
                        lastSelected = .geocode
                        activeSheet = .geocode
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "globe")
                            Text("Geocode")
                                .font(.caption2)
                        }
                        .foregroundStyle(lastSelected == .geocode ? .blue : .primary)
                        .frame(minWidth: 80)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(PressableStyle())
                    
                    Button {
                        tapHaptic()
                        lastSelected = .reverse
                        activeSheet = .reverse
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "globe.fill")
                            Text("Reverse")
                                .font(.caption2)
                        }
                        .foregroundStyle(lastSelected == .reverse ? .blue : .primary)
                        .frame(minWidth: 80)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(PressableStyle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial, in: Capsule())
                .shadow(radius: 3, x: 0, y: 2)
                .padding(.bottom, 8)
                .padding(.bottom, safeBottomInset)
            }
            .padding(.horizontal, 16)
            .opacity(showControls ? 1 : 0)
            .offset(y: showControls ? 0 : 10)
            .zIndex(1)
        }
        .onAppear { withAnimation(.easeInOut(duration: 0.3)) { showControls = true } }
        // Sheets for overlays so the map always remains behind
        .sheet(isPresented: $showingMenu) {
            HamburgerMenuView()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .home:
                NavigationStack { HomeView() }
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            case .geocode:
                NavigationStack { GeocodeView() }
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            case .reverse:
                NavigationStack { ReverseGeocodeView() }
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
        .sheet(isPresented: $showingMapSearch) {
            MapSearchView { coordinate, _ in
                // Route selection to the map via existing binding
                searchTargetCoordinate = coordinate
                tapHaptic()
                // Ensure any inline search UI collapses if it was open
                collapseSearch(clear: true)
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }
    
    private var safeBottomInset: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })?
            .safeAreaInsets.bottom ?? 0
    }
    
    private func tapHaptic() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    private func collapseSearch(clear: Bool = false) {
        if clear { searchText = "" }
        isSearchFieldFocused = false
        withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
            isSearchExpanded = false
        }
    }
    
    private func performSearch() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            collapseSearch()
            return
        }
        Task {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            let search = MKLocalSearch(request: request)
            do {
                let response = try await search.start()
                if let item = response.mapItems.first {
                    searchTargetCoordinate = item.placemark.coordinate
                    tapHaptic()
                    collapseSearch()
                }
            } catch {
                // Optionally show an error state here
            }
        }
    }
}

#Preview {
    ContentView()
}

