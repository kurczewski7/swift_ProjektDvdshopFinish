//
//  FavoritViewController.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 29.04.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit

class FavoritViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,FavoriteCollectionViewCellDelegate {
    
    var film: Film = Film()
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var totalPriceTextField: UITextField!
    //private
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        database.fillLikeList()
        collectionView.reloadData()
        database.refreshTotalPrice()
        totalPriceTextField.text=kantor.giveTotalPriceZlotyText()

        print("Refresh")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        database.fillLikeList()
        collectionView.reloadData()
        kantor.setTotalPriceTexeditAtrybute(totalPrice: totalPriceTextField)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: wypełnienie protokołu
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return database.listaUlubionych.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavoriteCollectionViewCell
        //let dane = filmList.give(row: listaUlubionych[indexPath.row])
        let dane=database.getFilm(row: database.listaUlubionych[indexPath.row])
        
        
        cell.titleLabel.text = dane.title
        cell.typeLabel.text = dane.type
        cell.priceLabel.text = kantor.doubleToString(dane.price)
        cell.imageView.image = database.getUIImageFromDb(cuurrentPhoto: dane.filmImage! as NSData)
        cell.isLiked=dane.isLiked
        cell.layer.cornerRadius=5.0
        cell.delegate = self
        
        return cell
    }
    
    
    // MARK: wypełnienie mojego zdefiniowanego protokółu
    func didLikeButtonPressed(cell: FavoriteCollectionViewCell) {
        if let indexPath=collectionView.indexPath(for: cell) {
            let newValue = filmList.give(row: indexPath.row).isLiked ? false : true
            cell.isLiked = newValue
            
            let phisicalRow = database.listaUlubionych[indexPath.row]
            database.setCheckRecord(phisicalRow: phisicalRow, value: newValue)
            database.saveDatabase()
            filmList.setIsLike(row: indexPath.row, isLike: newValue)
            database.refreshTotalPrice()
            totalPriceTextField.text=kantor.giveTotalPriceZlotyText()
            
            print("newValue=\(newValue)","\(phisicalRow)")
        }

    }
}
