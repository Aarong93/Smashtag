//
//  File.swift
//  Smashtag
//
//  Created by Aaron Grau on 11/2/15.
//  Copyright (c) 2015 Aaron Grau. All rights reserved.
//

import UIKit

let Image = "Image"
let URL = "URL"
let Hashtag = "Hashtag"
let UserMention = "User"

enum MentionType{
    case Images([NSURL])
    case URLs([String])
    case Hashtags([String])
    case Users([String])
    
    func count() -> Int{
        switch self{
        case .Images(let imageArray):
            return imageArray.count
        case .URLs(let URLsArray):
            return URLsArray.count
        case .Hashtags(let hashtagsArray):
            return hashtagsArray.count
        case .Users(let usersArray):
            return usersArray.count
        }
    }
    
    func simpleDescription() -> String{
        switch self{
        case .Images(_):
            return Image
        case .URLs(_):
            return URL
        case .Hashtags(_):
            return Hashtag
        case .Users(_):
            return UserMention
        }
    }
    
    func array() -> [AnyObject] {
        switch self{
        case .Images(let imageArray):
            return imageArray
        case .URLs(let URLsArray):
            return URLsArray
        case .Hashtags(let hashtagsArray):
            return hashtagsArray
        case .Users(let usersArray):
            return usersArray
        }
    }
}