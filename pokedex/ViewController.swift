//
//  ViewController.swift
//  pokedex
//
//  Created by Simon Thomas on 31/01/2016.
//  Copyright © 2016 Simon Thomas. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Outlet for collection view
    @IBOutlet weak var collection: UICollectionView!
    
    var pokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate for collection view so we can implement delegate methods
        collection.delegate = self
        collection.dataSource = self
        
        // Play Music
        initAudio()
        
        // Get list of pokemon from CSV
        parsePokemonCSV()
    }
    
    func initAudio() {
        let path = NSBundle.mainBundle().pathForResource("pokemusic", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            // Set to loop infinitely
            musicPlayer.numberOfLoops = -1
            // Play
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            // Call CSV parser
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            // Each row is a dictionary
            for row in rows {
                // Get ID from row and cast to an int
                let pokeId = Int(row["id"]!)!
                // Get name (from "Identifier" column in csv)
                let name = row["identifier"]!
                // Create new pokemon object
                let poke = Pokemon(name: name, pokedexId: pokeId)
                // Add pokemon to array of pokemon
                pokemon.append(poke)
                
            }
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }

    // Delegate methods required for collection view
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Dequeue for reusing cells to prevent having to create them all the time and using lots of memory
        // indexPath is the current cell number
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            // If able to grab a cell of the correct type, return it
            
            // indexPath.row is current cell number, not actual row in traditional sense
            // Create a new pokemon object for each entry.
            let poke = pokemon[indexPath.row]
            cell.configureCell(poke)
            
            return cell
        } else {
            // If can't retrieve an existing cell, make a new one and return that.
            return UICollectionViewCell()
        }
        
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Define number of items in the secion
        return 718
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Define size of cells
        // Can make this dynamic if need be
        return CGSizeMake(105,105)
    }
    
    @IBAction func musicBtnPressed(sender: UIButton!) {
        // If music is playing, stop it. If not, play it
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
}

