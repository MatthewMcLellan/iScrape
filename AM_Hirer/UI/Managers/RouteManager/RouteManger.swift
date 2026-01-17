//
//  RouteManger.swift
//  AM_Hirer
//
//  Created by Matthew McLellan on 1/17/26.
//


internal import Foundation
import SwiftUI
import Combine


class RouteManger : ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    
    @Published var path = NavigationPath()
    
    init() {}
    
    func popToRoot(){
        path = NavigationPath()
    }
    
    func to(route : Route){
        path.append(route)
    }
    
    func pop(){
        path.removeLast()
    }
    
    func popNViews(N: Int){
        path.removeLast(N)
    }
}


struct GetView: View {
    var route: Route
    var body: some View {
        switch route {
        case .homeView:
            HomeView()
        case .locationSearchView:
            LocationSearchView()
        default:
            ContentUnavailableView("404", systemImage: "globe", description: Text("Invalid route! :(").font(.footnote))
        }
    }
}

