//
//  RecipeEnvelope.swift
//  Recipes
//
//  Created by Hugo Alonso on 25/11/2019.
//  Copyright © 2019 halonso. All rights reserved.
//

import Foundation

struct RecipeEnvelope: Codable {
    var title: String
    var version: Float
    var href: String
    var results: [ModelRecipe]
}
