//
//  iScrapeApp.swift
//  iScrape
//
//  Created by Matthew McLellan on 12/17/25.
//
internal import Foundation
import SwiftUI
import CoreData

struct AM_HirerApp: App {
    var body: some Scene {
        WindowGroup {
            TabBar()
            }
        }
    
    let persistenceController = PersistenceController.shared
}

#Preview {
    TabBar()
}
