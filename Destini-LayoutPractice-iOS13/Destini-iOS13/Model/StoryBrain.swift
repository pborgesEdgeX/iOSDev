//
//  StoryBrain.swift
//  Destini-iOS13
//
//  Created by Angela Yu on 08/08/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
import UIKit

struct StoryBrain {
    var storyNumber = 0
    let stories = [
        Story(
        title: "One day, Shannen decided to move to the Bay Area to be with her perfect boyfriend, as she is moving and driving over to the Bay, Shannen goes:",
        choice1: "Babe! I am hungry!", choice1Destination: 1,
        choice2: "I love being in the car", choice2Destination: 5,
        img: UIImage()
    ),
    Story(
        title: "Of course, in an attempt to make her girl happy, her amazing boy pulled over and asks: 'Babe, what would you like?'",
        choice1: "Mexican?", choice1Destination: 2,
        choice2: "Pasta?", choice2Destination: 3,
        img: UIImage()
    ),
    Story(
        title: "Ohhhh yas! Fucking up that Del Taco. Her boy then goes: ",
        choice1: "You can't have more. It's all mine now.", choice1Destination: 5,
        choice2: "Let's go partying Bucko!", choice2Destination: 4,
        img: UIImage(named: "image-placeholder-title")!
    ),
    Story(
        title: "Pastalicious. ",
        choice1: "You can't have more. It's all mine now.", choice1Destination: 5,
        choice2: "Let's go partying Bucko!", choice2Destination: 4,
        img: UIImage(named: "pasta")!
    ),
    Story(
        title: "Yassss. What happened next? Was Shannen happily lived with Paulo forever?",
        choice1: "Oh... Fuck Yeah!", choice1Destination: 6,
        choice2: "No... She loved the ponies more.", choice2Destination: 7,
        img: UIImage(named: "IMG_0525" )!
    ),
    Story(
        title: "Oh no... Bratty Queen...",
        choice1: "The", choice1Destination: 0,
        choice2: "End", choice2Destination: 0,
        img: UIImage(named: "IMG_0581")!
    ),
    Story(
        title: "",
        choice1: "The", choice1Destination: 0,
        choice2: "End", choice2Destination: 0,
        img: UIImage(named: "yas" )!
    ),
    Story(
        title: "",
        choice1: "The", choice1Destination: 0,
        choice2: "End", choice2Destination: 0,
        img: UIImage(named: "IMG_1129" )!
    ),
    

    ]
    
    mutating func nextStory(userChoice: String){
        switch userChoice {
        case stories[storyNumber].choice1:
            storyNumber = stories[storyNumber].choice1Destination
        case stories[storyNumber].choice2:
            storyNumber = stories[storyNumber].choice2Destination
        default:
            print("No stories")
        }
    }
}
