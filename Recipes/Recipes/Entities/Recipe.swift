//
//  Recipe.swift
//  Recipes
//
//  Created by Hugo Alonso on 25/11/2019.
//  Copyright © 2019 halonso. All rights reserved.
//

import Foundation

struct ModelRecipe: Codable {

    var title: String
    var href: String
    var ingredients: String
    var thumbnail: String

}

extension ModelRecipe: Equatable, Hashable {
    static func ==(lhs: ModelRecipe, rhs: ModelRecipe) -> Bool {
        return lhs.href == rhs.href
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(href)
    }

}

extension ModelRecipe {
    var hasLactose: Bool {
       return ingredients.lowercased().contains("milk") || ingredients.lowercased().contains("cheese")
    }

    var image: URL? {
        return URL(string: thumbnail)
    }

    var favorited: Bool {
        return false
    }
}
