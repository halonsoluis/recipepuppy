//
//  APIService.swift
//  Recipes
//
//  Created by Hugo Alonso on 28/11/2019.
//  Copyright © 2019 halonso. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class RecipeAPIService {

    private var fetching: Bool = false
    private let session: URLSession
    private lazy var components: URLComponents = setupComponents()

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    private func setupComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "recipepuppy.com"
        components.path = "/api"
        return components
    }
}

extension RecipeAPIService: APIServiceInterface {

    private func allowedToRequest() -> Bool {
        guard !fetching else { return false }
        fetching = true
        return true
    }

    private func prepareRequest(_ ingredients: String, _ page: String) -> URLRequest? {
        components.queryItems = [
            URLQueryItem(name: "i", value: ingredients),
            URLQueryItem(name: "p", value: page)
        ]

        guard let url = components.url else { return nil }

        let request = NSMutableURLRequest(
            url: url,
            cachePolicy: .returnCacheDataElseLoad,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"

        return request as URLRequest
    }

    // TODO: Handle errors
    func fetchRecipes(ingredients: String, page: String, completionHandler: @escaping APIResponse) {
        guard allowedToRequest(), let request = prepareRequest(ingredients, page) else {
            return
        }

        let dataTask = session
            .dataTask(with: request, completionHandler: { [weak self] (data, response, error) -> Void in

                defer {
                    self?.fetching = false
                }

                if let error = error {
                    completionHandler(Result.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("---    Fetching attempt for page \(page) has failed")
                    completionHandler(Result.failure(NSError()))
                    return
                }

                switch httpResponse.statusCode {
                case 200:
                    if let data = data,
                        let jsonString = String(data: data, encoding: .utf8),
                        let jsonData = jsonString.data(using: .utf8),
                        let response = try? JSONDecoder().decode(RecipeEnvelope.self, from: jsonData) {
                        completionHandler(Result.success(response.results))
                    } else {
                        print("---    Parsing failed, page \(page) content ignored")
                        completionHandler(Result.success([]))
                    }
                default:
                    // This can be related to the issues seen in the API and reproducible with
                    // http://www.recipepuppy.com/api/?i=onions,garlic&p=2
                    // so, a page that fails will be ignored (set as Empty) as following pages request may work
                    print("---    Fetching attempt for page \(page) has failed")
                    completionHandler(Result.success([]))
                }
            })
        dataTask.resume()
    }
}
