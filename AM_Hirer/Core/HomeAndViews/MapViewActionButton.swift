//
//  MapViewActionButton.swift
//  AM_Hirer
//
//  Created by Matthew McLellan on 1/17/26.
//


import SwiftUI

struct MapViewActionButton: View {
    var body: some View {
        Image(systemName: "line.3.horizontal")
            .font(.title2)
            .foregroundStyle(.black)
            .padding()
            .background(.white)
            .clipShape(Circle())
            .shadow(color: .gray, radius: 10)
    }
}

#Preview {
    MapViewActionButton()
}