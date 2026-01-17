//
//  CategoriesViewModel.swift
//  AM_Hirer
//
//  Created by Matthew McLellan on 1/16/26.
//


internal import Foundation

class CategoriesViewModel: Identifiable {
    
    let id = UUID()
    
    let category: Category
    
    init(category: Category) {
        self.category = category
    }
    
    var name: String {
        return self.category.name
    }
    
    var products: [Product] {
        return self.category.products
    }
    
}
