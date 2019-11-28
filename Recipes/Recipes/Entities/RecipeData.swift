//
//  RecipeData.swift
//  Recipes
//
//  Created by Hugo Alonso on 25/11/2019.
//  Copyright © 2019 halonso. All rights reserved.
//

import Foundation

struct RecipeData: Codable {

    var title: String
    var href: String
    var ingredients: String
    var thumbnail: String
}
