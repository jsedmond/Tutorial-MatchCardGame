//
//  CardModel.swift
//  Match
//
//  Created by Jacob Edmond on 3/23/17.
//  Copyright © 2017 Jacob Edmond. All rights reserved.
//

import UIKit

class CardModel: NSObject {
    
    func getCards() -> [Card] {
        
        var cardArray = [Card]()
        
        for _  in 1...8 {
            
            let randomNumber = Int(arc4random_uniform(13))
            
            // Generate Card objects
            let cardOne = Card()
            cardOne.cardValue = randomNumber
            
            let cardTwo = Card()
            cardTwo.cardValue = randomNumber
            
            // TODO: Place card objects into cardArray
            cardArray += [cardOne, cardTwo]
            
        }
    
        
        // Randomize the cardArray
        for index in 0...cardArray.count - 1 {
            
            // Generate a random number
            let randomNumber = Int(arc4random_uniform(UInt32(cardArray.count)))
            
            let randomCard = cardArray[randomNumber]
            
            // Swap the objects
            cardArray[randomNumber] = cardArray[index]
            cardArray[index] = randomCard
            
        }
        
        return cardArray
        
    }

}
