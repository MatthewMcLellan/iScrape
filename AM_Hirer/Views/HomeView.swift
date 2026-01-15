import CoreLocation
import SwiftUI
import MapKit
import GeoToolbox
import OSLog

struct HomeView: View {
    private var mapView = MapView()
    @State private var showingMenu = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 0) {
                        //quickActionsSection
                        // statusSection
                        //adminToolsSection
                        Spacer(minLength: 40)
                    }
                }
                .contentMargins(.top, 12)

                // Floating hamburger button at top-left
                VStack {
                    HStack {
                        Button {
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

                        Spacer()
                    }
                    Spacer()
                }
                .padding(.top, 8)
                .padding(.leading, 8)
            }
            .navigationTitle("")
            .toolbarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingMenu) {
                HamburgerMenuView()
            }
        }
    }

    private var quickActionsSection: some View { // quick action
        VStack(spacing: 12) {
            Text("Quick Actions")
                .font(.title2)
                .bold(true)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack(spacing: 12) {
                QuickActionCard(
                    icon: "camera.fill",
                    title: "Diagnose",
                    color: .blue
                )
                
                QuickActionCard(
                    icon: "clock.fill",
                    title: "History",
                    color: .cyan
                )
            }
            
            HStack(spacing: 12) {
                QuickActionCard(
                    icon: "eye.fill",
                    title: "AR Detector",
                    color: .blue
                )
                
                QuickActionCard(
                    icon: "bubble.left.and.bubble.right.fill",
                    title: "AI Chat",
                    color: .purple
                )
                
                QuickActionCard(
                    icon: "gearshape.fill",
                    title: "Settings",
                    color: .gray
                )
            }
        }
        .padding()
        .scenePadding()

    }
}
        
struct QuickActionCard: View {
    let icon: String
    let title: String
    let color: Color
    var destination: AnyView? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        Group {
            if let destination = destination {
                NavigationLink(destination: destination) {
                    cardContent
                }
            } else {
                Button(action: { action?() }) {
                    cardContent
                }
            }
        }
    }
    
    private var cardContent: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}

