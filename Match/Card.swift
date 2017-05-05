//
//  Card.swift
//  Match
//
//  Created by Jacob Edmond on 3/23/17.
//  Copyright © 2017 Jacob Edmond. All rights reserved.
//

import UIKit

class Card: UIView {
    
    let backImageView = UIImageView()
    let frontImageView = UIImageView()
    
    var cardValue = 0
    let cardNames = ["card1", "card2", "card3", "card4", "card5", "card6", "card7", "card8", "card9", "card10", "card11", "card12", "card13"]

    var flippedUp = false
    var isDone = false {
        didSet {
            if isDone == true {
                // Remove the image from the cardImageView
                
                UIView.animate(withDuration: 1, delay: 2, options: .curveEaseOut, animations: {
                    
                    self.backImageView.alpha = 0
                    self.frontImageView.alpha = 0
                    
                }, completion: nil)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        // Add image view into view
        addSubview(backImageView)
        
        // Initialize the imageview with an image
        backImageView.translatesAutoresizingMaskIntoConstraints = false
        backImageView.image = UIImage(named: "back")
        applySizeContraints(imageView: backImageView)
        applePositionContraints(imageView: backImageView)
        
        // Add front iamge view into view
        addSubview(frontImageView)
        frontImageView.translatesAutoresizingMaskIntoConstraints = false
        applePositionContraints(imageView: frontImageView)
        applePositionContraints(imageView: frontImageView)
        
        
        


    }
    
    func applySizeContraints(imageView:UIImageView) {
        
        // Set contraints for the imageview
        
        let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 170)
        
        let widthConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
        
        imageView.addConstraints([widthConstraint, heightConstraint])
        
    }
    
    func applePositionContraints(imageView:UIImageView) {
    
    
    let topConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
    
    let leftConstraint = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
    
    addConstraints([topConstraint, leftConstraint])
    
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func flipUp() {
        
        // Set the front card image
        frontImageView.image = UIImage(named: cardNames[cardValue])
        
        // Run the transition animation
        UIView.transition(from: backImageView, to: frontImageView, duration: 1, options: .transitionFlipFromLeft, completion: nil)
        
        applePositionContraints(imageView: frontImageView)
        
        // Set the flag
        flippedUp = true
    }
    
    func flipDown() {
        
        // Run the transition animation
        UIView.transition(from: frontImageView, to: backImageView, duration: 1, options: .transitionFlipFromRight, completion: nil)

        applePositionContraints(imageView: backImageView)
        
        // Set the flag
        flippedUp = false
    }
}
