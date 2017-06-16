//
//  MasterTableViewCell.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 26.04.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit

class MasterTableViewCell: UITableViewCell {

    @IBOutlet var DVDImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var actorsLabel: UILabel!
    @IBOutlet var typLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
