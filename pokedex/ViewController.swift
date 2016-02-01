//
//  ViewController.swift
//  pokedex
//
//  Created by Simon Thomas on 31/01/2016.
//  Copyright © 2016 Simon Thomas. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    // Outlet for collection view
    @IBOutlet weak var collection: UICollectionView!
    // Outlet for search bar
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    
    // Set up variables for searching functionality
    // Second array to hold filtered results
    var inSearchMode = false
    var filteredPokemon = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate for collection view so we can implement delegate methods
        collection.delegate = self
        collection.dataSource = self
        
        // Set delegate for search bar
        searchBar.delegate = self
        
        // Change name of Search button on search keyboard to be more relevant (change to Done)
        searchBar.returnKeyType = UIReturnKeyType.Done
        
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
            // Check whether in search mode, and use appropriate array of pokemon
            
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            
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
        // If in search mode, return count of filtered array, else return count of full array
        if inSearchMode {
            return filteredPokemon.count
        }
        
        return pokemon.count
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
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // Handle search button being touched by removing keyboard
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // Use a second array to hold the filtered results, seperate from the main array
        // This method is called everytime the text changes
        // Check if the search bar is empty
        if searchBar.text == nil || searchBar.text == "" {
            // Searchbar empty
            inSearchMode = false
            //  Remove keyboard when the search field is empty
            view.endEditing(true)
            collection.reloadData()
        } else {
            // A letter has been typed / changed & search bar is not empty so enter search mode
            inSearchMode = true
            // Convert to lower case
            let lower = searchBar.text!.lowercaseString
            // There's a methid on arrays that allows filtering
            // $0 means grab element and give name of 0, is similar to looking up an element in array
            // This assigned a filtered version of the full array to the new array
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil})
            // Refresh collection view
            // Will need to make sure that the filtered list is returned if in search mode
            collection.reloadData()
        }
    }
}

