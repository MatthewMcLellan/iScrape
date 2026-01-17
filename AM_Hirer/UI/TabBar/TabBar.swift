//
//  TabBar.swift
//  AM_Hirer
//
//  Created by Matthew McLellan on 1/16/26.
//

import SwiftUI

struct TabBar: View {
    var body:  some View {
        TabView {
            MapView()
                
            .tabItem {
                Image(systemName: "map")
                Text("Nearby")
            }.tag(0)
           
            ProductsTableView()
                
            .tabItem {
                Image(systemName: "location")
                Text("HIRE-R")
            }.tag(1)
           
            MapView()
                
            .tabItem {
                Image(systemName: "mappin")
                Text("HIRE-D")
            }.tag(2)
            
            AccountView()
                
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }.tag(2)
        }.accentColor(.black)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

