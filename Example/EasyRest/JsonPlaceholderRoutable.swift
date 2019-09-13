//
//  JsonPlaceholderAPI.swift
//  EasyRest_Example
//
//  Created by Ráfagan Abreu on 11/09/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import EasyRest

// Maps API calls and infos, like method and query params
enum JsonPlaceholderRoutable: Routable {
    // Each API interaction is a case
    case posts
    // Using query params
    case postsFilter(userId: Int)
    // Example with path
    case post(id: Int)
    case deletePost(id: Int)
    // Example with body
    case makePost(body: PostModel)
    // Example with path, body and header
    case editPost(id: Int, body: PostModel)
    case editTitle(id: Int, body: PostModel)
    
    // Now test every possibility in a fashion Swift syntax
    var rule: Rule {
        switch(self) {
        case .posts:
            return Rule(
                method: .get, // HTTP verb
                path: "/posts/", // Endpoint
                isAuthenticable: false, // Uses EasyRest Authenticated Service?
                parameters: [:]) // query/path/header params? Header Body? Multipart form data? Put here!
        case let .postsFilter(userId):
            return Rule(
                method: .get,
                path: "/posts/",
                isAuthenticable: false,
                parameters: [.query: ["userId": "\(userId)"]])
        case let .post(id):
            return Rule(
                method: .get,
                path: "/posts/{id}/",
                isAuthenticable: false,
                parameters: [.path: ["id": id]])
        case let .deletePost(id):
            return Rule(
                method: .delete,
                path: "/posts/{id}/",
                isAuthenticable: false,
                parameters: [.path: ["id": id]])
        case let .makePost(body):
            return Rule(
                method: .post,
                path: "/posts/",
                isAuthenticable: false,
                parameters: [.body: body])
        case let .editPost(id, body):
            return Rule(
                method: .put,
                path: "/posts/{id}",
                isAuthenticable: false,
                parameters: [
                    .path: ["id": id],
                    .body: body,
                    .header: ["Content-type": "application/json; charset=UTF-8"]])
        case let .editTitle(id, body):
            return Rule(
                method: .patch,
                path: "/posts/{id}",
                isAuthenticable: false,
                parameters: [
                    .path: ["id": id],
                    .body: body,
                    .header: ["Content-type": "application/json; charset=UTF-8"]])
        }
    }
}
