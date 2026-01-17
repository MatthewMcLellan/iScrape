//
//  Product.swift
//  AM_Hirer
//
//  Created by Matthew McLellan on 1/16/26.
//


internal import Foundation

struct Product: Codable, Identifiable {
    var id: Int
    var name: String
    var image: String
    var price: String
    var description: String
}
