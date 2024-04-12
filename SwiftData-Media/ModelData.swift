//
//  ModelData.swift
//  SwiftData-Media
//
//  Created by 水原　樹 on 2024/04/11.
//

import Foundation
import SwiftData


//Lets create the data model for each entity!!

//users model
@Model
final class User {
    var avatar: Data?
    var name: String
    var date: Date
    
    @Relationship var post: [Post]
    init(avatar: Data? = nil, name: String, date: Date) {
        self.avatar = avatar
        self.name = name
        self.date = date
        self.post = []
    }
}

//Posts model
@Model
class Post {
    var imgPost: Data?
    var caption: String
    var descriptions: String
    var date: Date
    var isLiked: Bool
    
    @Relationship var comentary: [Comentary]
    
    init(imgPost: Data? = nil, caption: String, descriptions: String, date: Date, isLiked: Bool) {
        self.imgPost = imgPost
        self.caption = caption
        self.descriptions = descriptions
        self.date = date
        self.isLiked = isLiked
        self.comentary = []
        
    }
}


//Comentaries model
@Model
class Comentary {
    var comentary: String
    var date: Date
    var isMarked: Bool
    
    @Relationship var post: [Post]
    init(comentary: String, date: Date, isMarked: Bool) {
        self.comentary = comentary
        self.date = date
        self.isMarked = isMarked
        self.post = []
    }
}

//MARK: Now lets relate each one, to sharing data one another!!!


//MARK: We are done with the models
