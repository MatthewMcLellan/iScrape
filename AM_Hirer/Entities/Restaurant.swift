//
//  Restaurant.swift
//  AM_Hirer
//
//  Created by Matthew McLellan on 1/16/26.
//


internal import Foundation

struct Restaurant: Codable {
    var id: Int
    var name: String
    var logo: String?
    var banner: String?
    var categories: [Category]
}
