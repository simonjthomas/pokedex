//
//  PokeCell.swift
//  pokedex
//
//  Created by Simon Thomas on 31/01/2016.
//  Copyright © 2016 Simon Thomas. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    // Define outlets
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: Pokemon) {
        // Have to use self keyword because names are the same
        self.pokemon = pokemon
        nameLbl.text = self.pokemon.name.capitalizedString
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }
}
