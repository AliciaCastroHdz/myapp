//
//  RecipeModel.swift
//  myapp
//
//  Created by Alicia Monserrath Castro Hernandez on 13/01/21.
//

import Foundation
import ObjectMapper

public struct RecipeModel: Mappable {
    var id: String!
    var name: String!
    var category: String!
    var instructions: String?
    var picturePath: String?
    var ingredients: [String] = []

    public init?(map: Map) { }

    public mutating func mapping(map: Map) {
        self.id                     <-          map["idMeal"]
        self.name                   <-          map["strMeal"]
        self.category               <-          map["strCategory"]
        self.instructions           <-          map["strInstructions"]
        self.picturePath                <-          map["strMealThumb"]
    }
}
