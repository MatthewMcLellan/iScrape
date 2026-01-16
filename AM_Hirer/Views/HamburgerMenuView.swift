import CoreLocation
import SwiftUI
import MapKit
import GeoToolbox
import OSLog

struct HamburgerMenuView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showHireRDiscussion = false
    
    var body: some View {
        NavigationView {
            List {
                // Main Navigation
                Section(header: Text("Navigation")) {
                    MenuRow(
                        icon: "house.fill",
                        title: "Home",
                        color: .gray
                    ) {
                        dismiss()
                    }
                    
                    Button {
                        showHireRDiscussion = true
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: "clipboard")
                                .font(.title3)
                                .foregroundColor(.cyan)
                                .frame(width: 32)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Hire-r")
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    MenuRow(
                        icon: "clipboard",
                        title: "Hire-d",
                        color: .green
                    ) {
                        dismiss()
                    }
                }
                
                // Tools & Settings
                Section(header: Text("Tools & Settings")) {
                    MenuRow(
                        icon: "gearshape.fill",
                        title: "Settings",
                        color: .gray
                    ) {
                        dismiss()
                    }
                    
                    MenuRow(
                        icon: "pin",
                        title: "Nearby Technicians",
                        color: .red
                    ) {
                        dismiss()
                    }
                    
                    MenuRow(
                        icon: "stairs",
                        title: "Hire-r Stats",
                        color: .blue
                    ) {
                        dismiss()
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showHireRDiscussion) {
            NavigationView {
                DiscussionThreadView()
            }
        }
    }
}

// MARK: - Menu Row

struct MenuRow: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .foregroundColor(.primary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    HamburgerMenuView()
}
