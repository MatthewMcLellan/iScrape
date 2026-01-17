//
//  Category.swift
//  AM_Hirer
//
//  Created by Matthew McLellan on 1/16/26.
//


internal import Foundation

struct Category: Codable {
    var id: Int
    var name: String
    var products: [Product]
}
