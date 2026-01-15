//
//  ContentView.swift
//  AM_Hirer
//
//  Created by Matthew McLellan on 12/17/25.
//

import SwiftUI

extension Bundle {
    var appVersion: String { infoDictionary?["CFBundleShortVersionString"] as? String ?? "" }
    var appBuild: String { infoDictionary?[kCFBundleVersionKey as String] as? String ?? "" }
}

struct ContentView: View {
    @StateObject private var viewModel = ImageScraperViewModel()
    @AppStorage("settings.quantity") private var storedQuantity: Double = 12
    @AppStorage("settings.format") private var storedFormat: String = "JPG"
    @AppStorage("settings.quality") private var storedQuality: String = "High"
    @AppStorage("settings.aspectRatio") private var storedAspectRatio: String = "Portrait"
    @State private var showSettings = false
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header Text
                        if viewModel.results.isEmpty && !viewModel.isSearching {
                            VStack(spacing: 16) {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray.opacity(0.3))
                                    .padding(.top, 60)
                                
                                Text("Online Search")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.primary)
                                
                                Text("Version \(Bundle.main.appVersion) (\(Bundle.main.appBuild))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .transition(.opacity)
                        }
                        
                        // Results Grid
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.results) { image in
                                NavigationLink(destination: ImageDetailView(image: image)) {
                                    ImageCell(url: image.url)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        
                        if viewModel.isSearching {
                            ProgressView()
                                .scaleEffect(1.5)
                                .padding(.top, 50)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("AM_Hirer")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search term")
            .onSubmit(of: .search) {
                viewModel.performSearch(quantity: Int(storedQuantity), aspectRatio: storedAspectRatio, format: storedFormat, quality: storedQuality)
            }
            .sheet(isPresented: $showSettings) {
                let binding = Binding<SearchSettings>(
                    get: { SearchSettings(quantity: storedQuantity, format: storedFormat, quality: storedQuality, aspectRatio: storedAspectRatio) },
                    set: { newValue in
                        storedQuantity = newValue.quantity
                        storedFormat = newValue.format
                        storedQuality = newValue.quality
                        storedAspectRatio = newValue.aspectRatio
                    }
                )
                SearchSettingsView(settings: binding)
            }
        }
    }
}

struct ImageCell: View {
    let url: URL
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .overlay(ProgressView())
            case .success(let img):
                img
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                Rectangle()
                    .fill(Color.red.opacity(0.1))
                    .overlay(Image(systemName: "exclamationmark.triangle"))
            @unknown default:
                EmptyView()
            }
        }
        .frame(height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}
#Preview {
    ContentView()
}

#Preview("ImageCell", traits: .sizeThatFitsLayout) {
    ImageCell(url: URL(string: "https://example.com/image.jpg")!)
        .padding()
}

