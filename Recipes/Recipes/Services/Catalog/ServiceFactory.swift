//
//  ServiceFactory.swift
//  Recipes
//
//  Created by Hugo Alonso on 28/11/2019.
//  Copyright © 2019 halonso. All rights reserved.
//

import Foundation

final class ServiceFactory: ServicesCatalog {
    var api: APIServiceInterface { RecipeAPIService(session: URLSession.shared) }
    var persistence: PersitenceServiceInterface { LocalPersistenceService() }
}
