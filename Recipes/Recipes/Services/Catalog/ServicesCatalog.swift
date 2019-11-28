//
//  ServicesCatalog.swift
//  Recipes
//
//  Created by Hugo Alonso on 28/11/2019.
//  Copyright © 2019 halonso. All rights reserved.
//

import Foundation

protocol ServicesCatalog: class {
    var api: APIServiceInterface { get }
}
