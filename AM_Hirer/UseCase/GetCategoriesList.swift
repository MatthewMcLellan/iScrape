//
//  GetCategoriesList.swift
//  AM_Hirer
//
//  Created by Matthew McLellan on 1/16/26.
//


internal import Foundation
import Combine

class GetCategoriesList: ObservableObject {
    
    let didChange = PassthroughSubject<GetCategoriesList,Never>()
    
    init() {
        getCategories()
    }
    
    @Published var categories = [CategoriesViewModel]() {
        didSet {
            didChange.send(self)
        }
    }
    
    private func getCategories() {
        guard let url = URL(string: "https://hire-r-test.com") else {
            return
        }
        
        Webservice().loadCategories(url: url) { categories in
            if let categories = categories {
                self.categories = categories.map(CategoriesViewModel.init)
            }
        }
    }
}
