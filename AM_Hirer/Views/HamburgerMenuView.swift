import CoreLocation
import SwiftUI
import MapKit
import GeoToolbox
import OSLog

struct HamburgerMenuView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                // Main Navigation
                Section(header: Text("Navigation")) {
                    MenuRow(
                        icon: "house.fill",
                        title: "Home",
                        color: .blue
                    ) {
                        dismiss()
                    }
                    
                    MenuRow(
                        icon: "camera.fill",
                        title: "Diagnose",
                        color: .blue
                    ) {
                        dismiss()
                    }
                    
                    MenuRow(
                        icon: "eye.fill",
                        title: "AR Detector",
                        color: .blue
                    ) {
                        dismiss()
                    }
                    
                    MenuRow(
                        icon: "clock.fill",
                        title: "History",
                        color: .cyan
                    ) {
                        dismiss()
                    }
                    
                    MenuRow(
                        icon: "bubble.left.and.bubble.right.fill",
                        title: "AI Chat",
                        color: .purple
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
                        icon: "network",
                        title: "Environment",
                        color: .blue
                    ) {
                        dismiss()
                    }
                    
                    MenuRow(
                        icon: "brain",
                        title: "Status",
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
