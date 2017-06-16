//
//  FoundDetailViewController.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 09.05.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit

class FoundDetailViewController: UIViewController {
    var dvdImageTmp = ""
    var titleLabelTmp = ""
    var actorsLabelTmp = "brak"
    var typeLabelTmp = ""
    var descriptionLabelTmp = ""
    var priceLabelTmp = ""
    var youtubeUrlTmp = ""
    var rowTmp="1"
    var phisicalRowTmp = "0"

    
    @IBOutlet var dvdImage: UIImageView!
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.text=titleLabelTmp        }    }
    @IBOutlet var actorsLabel: UILabel! {
        didSet {
            actorsLabel.text=actorsLabelTmp        }    }
    @IBOutlet var typeLabel: UILabel! {
        didSet {
            typeLabel.text=typeLabelTmp        }    }
    @IBOutlet var priceLabel: UILabel! {
        didSet {
            priceLabel.text=priceLabelTmp        }    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        //let row=Int(rowTmp)
        let phisicalRow=Int(phisicalRowTmp)
        print("FoundDetailViewController, row=\(rowTmp), phisicalRow=\(phisicalRowTmp)")
        dvdImage.image=UIImage(data: database.getImageDataFromDb(phisicalRow: phisicalRow!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier=="showYoutube2" {
            
            let destinatonController = segue.destination as! VideoViewController
            
            destinatonController.titleLabelTmp = titleLabelTmp
            destinatonController.typeLabelTmp  = typeLabelTmp
            destinatonController.priceLabelTmp = priceLabelTmp
            destinatonController.youtubeUrlTmp = youtubeUrlTmp
            destinatonController.dvdImageTmp   = dvdImageTmp
            destinatonController.descriptionLabelTmp=descriptionLabelTmp
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
