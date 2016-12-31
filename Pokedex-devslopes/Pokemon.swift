//
//  Pokemon.swift
//  Pokedex-devslopes
//
//  Created by Shane Mckenzie on 8/21/16.
//  Copyright © 2016 Shane Mckenzie. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    fileprivate var _description: String!
    fileprivate var _type: String!
    fileprivate var _defense: String!
    fileprivate var _height: String!
    fileprivate var _weight: String!
    fileprivate var _attack: String!
    fileprivate var _nextEvoTxt: String!
    fileprivate var _nextEvoId: String!
    fileprivate var _nextEvoLvl: String!
    fileprivate var _pokemonUrl: String!
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvoTxt: String {
        if _nextEvoTxt == nil {
            _nextEvoTxt = ""
        }
        return _nextEvoTxt
    }
    
    var nextEvoId: String {
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var nextEvoLvl: String {
        if _nextEvoLvl == nil {
            _nextEvoLvl = ""
        }
        return _nextEvoLvl
    }
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId

        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
        
    }
    
    func downloadPokemonDetails(_ completed: @escaping DownloadComplete) {
        
            let url = URL(string: _pokemonUrl)!
            
            Alamofire.request(url).responseJSON { response in
                let result = response.result
                
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    
                    if let weight = dict["weight"] as? String {
                        self._weight = weight
                    }
                    
                    if let height = dict["height"] as? String {
                        self._height = height
                    }
                    
                    if let attack = dict["attack"] as? Int {
                        self._attack = "\(attack)"
                    }
                    
                    if let defense = dict["defense"] as? Int {
                        self._defense = "\(defense)"
                    }
                   
                    if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {
                        if let name = types[0]["name"] {
                            self._type = name.capitalized
                        }
                        
                        if types.count > 1 {
                            for x in 1 ..< types.count {
                                if let name = types[x]["name"] {
                                    self._type! += "/\(name.capitalized)"
                                }
                            }
                        }
                    } else {
                        self._type = ""
                    }
                    print(self._type)
                    
                    if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
                        
                        if let url = descArr[0]["resource_uri"] {
                            
                            let nsurl = URL(string: "\(URL_BASE)\(url)")!
                            
                            Alamofire.request(nsurl).responseJSON { response in
                                
                                let desResult = response.result
                                if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                    
                                    if let description = descDict["description"] as? String {
                                        self._description = description
                                        print(self._description)
                                        
                                    }
                                }
                                
                                completed()
                        }
                        
                    } else {
                        self._description = ""
                    }
                    
                    if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] , evolutions.count > 0 {
                        
                        if let to = evolutions[0]["to"] as? String {
                            
                            //exclude mega pokemon
                            if to.range(of: "mega") == nil {
                                if let uri = evolutions[0]["resource_uri"] as? String {
                                    
                                    let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                    
                                    let num = newStr.replacingOccurrences(of: "/", with: "")
                                    
                                    self._nextEvoId = num
                                    self._nextEvoTxt = to
                                    
                                    if let lvl = evolutions[0]["level"] as? Int {
                                        self._nextEvoLvl = "\(lvl)"
                                    }
                                    
                                    print(self._nextEvoId)
                                    print(self._nextEvoTxt)
                                    print(self._nextEvoLvl)
                                    
                                }
                            }
                        }
                            
                    }
                }
            }
        }
    }
    
}
