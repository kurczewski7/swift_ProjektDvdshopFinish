//
//  Film.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 29.04.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit
struct Film {
    var filmId = ""
    var title = ""
    var actors = ""
    var filmDirector = ""
    var type : TypeOfFilm = .sensacja
    var type_str=""
    var description = ""
    var price: Double = 0.0
    var price_str = ""
    var filmImage:UIImage?
    var pictureName=""
    var youtubeUrl = ""
    var isLiked = false
    
    init(){
        
    }
    
    init(filmId: String, title: String, actors: String, filmDirector: String ,type: TypeOfFilm, description: String, price: Double, filmImage: UIImage!,youtubeUrl: String, isLiked: Bool){
        self.filmId=filmId
        self.title=title
        self.actors=actors
        self.filmDirector=filmDirector
        self.type=type
        self.description=description
        self.price=price
        self.price_str = String(format: "%6.2f",  price)
        self.filmImage=filmImage
        self.youtubeUrl=youtubeUrl
        self.isLiked=isLiked
    }
    
    init(pictureName: String, titleName: String, price: Double){
        
        self.title=titleName
        self.actors = "Ronald Regan"
        self.type = .obyczajowy
        self.description = "Ciekawy film"
        self.price = price
        self.price_str = String(format: "%6.2f",  price)
        self.filmImage = UIImage(named: pictureName)
        self.pictureName=pictureName
        self.isLiked = true
        
        let index=(pictureName.index(pictureName.endIndex, offsetBy: -8))
        self.filmId = pictureName.substring(from: index)
        }
    
    public mutating func fill(pictureName: String, titleName: String, price: Double, type: TypeOfFilm, filmDescription: String, actor: String,filmDirector: String,youtubeUrl: String, isLiked: Bool ){
        
        self.title = titleName
        self.actors = actor
        self.filmDirector = filmDirector 
        self.type = type
        self.description = filmDescription
        self.price = price
        self.price_str = String(format: "%6.2f",  price)
        self.filmImage =  UIImage(named: pictureName)
        self.pictureName=pictureName
        self.youtubeUrl=youtubeUrl
        self.isLiked = isLiked
        
        let index=(pictureName.index(pictureName.endIndex, offsetBy: -8))
        self.filmId = pictureName.substring(from: index)
    }
    
    
    mutating func giveCurrentData() -> UserRekord {        
        var rek: UserRekord
        type_str=type.rawValue
        
        rek.filmId=filmId
        rek.title=title
        rek.actors=actors
        rek.filmDirector=filmDirector
        rek.type=type.rawValue
        rek.description=description
        rek.price=price_str
        rek.filmImage=filmImage!
        rek.youtubeUrl=youtubeUrl
        rek.isLiked=isLiked
        
    return rek
    }
    
}
