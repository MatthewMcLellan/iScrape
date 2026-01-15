//
//  SearchSettingsView.swift
//  iScrape
//
//  Created by Matthew McLellan on 12/17/25.
//

import SwiftUI

struct SearchSettings {
    var quantity: Double = 12
    var format: String = "JPG"
    var quality: String = "High"
    var aspectRatio: String = "Portrait"
    
    static let formats = ["JPG", "PNG", "WEBP"]
    static let qualities = ["Low", "Medium", "High"]
    static let aspectRatios = ["Portrait", "Landscape", "Square"]
}

struct SearchSettingsView: View {
    @Binding var settings: SearchSettings
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Search Parameters")) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Quantity")
                            Spacer()
                            Text("\(Int(settings.quantity)) photos")
                                .foregroundColor(.secondary)
                        }
                        Slider(value: $settings.quantity, in: 1...50, step: 1)
                    }
                    .padding(.vertical, 4)
                    
                    Picker("Format", selection: $settings.format) {
                        ForEach(SearchSettings.formats, id: \.self) { format in
                            Text(format).tag(format)
                        }
                    }
                    
                    Picker("Quality", selection: $settings.quality) {
                        ForEach(SearchSettings.qualities, id: \.self) { quality in
                            Text(quality).tag(quality)
                        }
                    }
                    
                    Picker("Aspect Ratio", selection: $settings.aspectRatio) {
                        ForEach(SearchSettings.aspectRatios, id: \.self) { ratio in
                            Text(ratio).tag(ratio)
                        }
                    }
                }
                
                Section(footer: Text("Higher quality and quantity may result in slower scrape times.")) {
                    Button(action: {
                        // defaults
                        settings = SearchSettings()
                    }) {
                        Text("Reset to Defaults")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Refine Search")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.headline)
                }
            }
        }
    }
}
#Preview("SearchSettings - Defaults") {
    @Previewable @State var settings = SearchSettings()
    return SearchSettingsView(settings: $settings)
}

#Preview("SearchSettings - Custom") {
    @Previewable @State var settings = SearchSettings(quantity: 24, format: "PNG", quality: "Medium", aspectRatio: "Landscape")
    return SearchSettingsView(settings: $settings)
}

