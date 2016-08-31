//
//  PokemonDetailVC.swift
//  Pokedex-devslopes
//
//  Created by Shane Mckenzie on 8/31/16.
//  Copyright © 2016 Shane Mckenzie. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
