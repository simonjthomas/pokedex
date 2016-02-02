//
//  Pokemon.swift
//  pokedex
//
//  Created by Simon Thomas on 31/01/2016.
//  Copyright © 2016 Simon Thomas. All rights reserved.
//

import Foundation

class Pokemon {
    // Define Attributes
    // Can use "!" to guarantee there's always a value as it's required in the initialiser
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    
    // Getters
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    // Initializer
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
}