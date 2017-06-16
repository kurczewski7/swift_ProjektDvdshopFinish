//
//  FavoriteCollectionViewCell.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 28.04.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit

protocol FavoriteCollectionViewCellDelegate {
        func didLikeButtonPressed(cell: FavoriteCollectionViewCell)
    }

class FavoriteCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    

    var isLiked: Bool = false {
        didSet {
                if isLiked {   likeButton.setImage(UIImage(named: "heartfull"), for: .normal)        }
                else       {    likeButton.setImage(UIImage(named: "heart"), for: .normal)           }
            }
        }
    
    var delegate: FavoriteCollectionViewCellDelegate?
    
    @IBAction func likeButtonTapped(sender: AnyObject){
        delegate?.didLikeButtonPressed(cell: self)
    
    }
}
