//
//  FilmList.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 02.05.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit

class FilmList {

    var film: Film    
    var filmsName: [String]
    var titles: [String]
    var actorsList: [String]
    var typeList: [TypeOfFilm]
    var descriptions: [String]
    var priceList: [Double]
    var youtubeUrlList: [String]
    var likedList: [Bool]
    var defaultYoutubeUrls: [String] = ["7ynBUJPNEdM",  "zi8QIsuf7kU","WlYC8gDvutc","zi8QIsuf7kU"]
    
    init(filmsName: [String], titles: [String], actorsList: [String], typeList: [TypeOfFilm], descriptions: [String], priceList: [Double],  youtubeUrlList : [String], likedList: [Bool])
    {
        film=Film()
        
        self.filmsName=filmsName
        self.titles=titles
        self.actorsList=actorsList
        self.typeList=typeList
        self.descriptions=descriptions
        self.priceList=priceList
        self.likedList=likedList
        self.youtubeUrlList=youtubeUrlList
    }
    
    public func give(row: Int) ->  UserRekord {
        var r: (pictureName: String, titleName: String, price: Double, type: TypeOfFilm, filmDescription: String, actor: String, filmDirector: String, youtubeUrl: String, isLiked: Bool)
        
        r.pictureName     = (filmsName.count > row) ? filmsName[row]          : "gwiezdne-wojny-trylogia-4-6-w-iext37628222"
        r.titleName       = (titles.count > row) ? titles[row]                : "brak"
        r.price           = (priceList.count > row) ? priceList[row]          :   0.0
        r.type            = (typeList.count > row) ? typeList[row]            : .obyczajowy
        r.filmDescription = (descriptions.count > row) ? descriptions[row]    : "Aktorzy nieznani"
        r.actor           = (actorsList.count > row) ? actorsList[row]        : "Brak aktora"
        r.filmDirector    = "brak"
        r.youtubeUrl      =  giveYoutubeUrl(row: row)
        r.isLiked         = (likedList.count > row) ? likedList[row]          : false
        
        film.fill(pictureName: r.pictureName, titleName: r.titleName, price: r.price, type:  r.type, filmDescription: r.filmDescription, actor: r.actor, filmDirector: r.filmDirector, youtubeUrl: r.youtubeUrl, isLiked: r.isLiked)
        
        return film.giveCurrentData()
    }
    
    func giveIcon(row: Int) -> (name: String, title: String, price: Double, isFeatured: Bool) {
        return (name: filmsName[row], title: titles[row], price: priceList[row], isFeatured: true)
    }
    
    func setIsLike(row: Int, isLike: Bool){
      likedList[row] = isLike
    }
    
    func giveYoutubeUrl(row: Int) -> String{
        if row < youtubeUrlList.count {
            return youtubeUrlList[row]
        }
        else
        {
            let randomValue=Int(arc4random_uniform(UInt32(defaultYoutubeUrls.count)))
            return defaultYoutubeUrls[randomValue]
        }
    }
    func giveCurrentPictureName(row: Int) -> String {
        let lenghtPict=filmsName.count
        return filmsName[(row < lenghtPict) ? row : row % lenghtPict]
    }    
}

