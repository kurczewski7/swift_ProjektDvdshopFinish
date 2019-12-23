//
//  PaymentCollectionViewController.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 02.05.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit
//  € $

private let reuseIdentifier = "Cell"

class PaymentCollectionViewController: UICollectionViewController {
    private var trashEnabled=false
    private var selectedIcons: [Icon]=[]
    
    @IBOutlet var trashButton: UIBarButtonItem!
    
    // MARK: Action metod
    @IBAction func refreshActionBarButton(_ sender: UIBarButtonItem) {
        trashEnabled=false
        selectedIcons.removeAll(keepingCapacity: false)        
        database.zestawIcon.removeAll(keepingCapacity: false)
        database.fillIkonList()
        
        for i in 0..<database.zestawIcon.count {            database.zestawIcon[i].isFeatured = true        }
        collectionView?.reloadData()
    }
    @IBAction func trashButtonTapped(sender: AnyObject) {
        print("trashEnabled=\(trashEnabled)")
        printIcon()
        if trashEnabled {
            if selectedIcons.count  > 0
            {
            print("selectedIcons.count=\(selectedIcons.count)" )
            // Deselect all selected items
            if let indexPaths=collectionView?.indexPathsForSelectedItems {
                for indexPath in indexPaths {
                    collectionView?.deselectItem(at: indexPath, animated: false)
                    
                    // Remowe all items for selectedIcons array
                    selectedIcons.removeAll(keepingCapacity: true)
                        
                    // change the trash mode to NO
                    trashEnabled=false
                    collectionView?.allowsMultipleSelection=false
                    trashButton.title = "Odznacz"
                    trashButton.style=UIBarButtonItem.Style.plain
            
                    }
                }
                collectionView?.reloadData()
            }
        }
        else
        {
            trashEnabled=true
            collectionView?.allowsMultipleSelection=true
            trashButton.title="Usuń"
            trashButton.style=UIBarButtonItem.Style.done
        }
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database.zestawIcon.removeAll(keepingCapacity: false)
        database.fillIkonList()
        kantor.setCurrencyRate(dolar: server.valuteExchange["USD"]!, euro: server.valuteExchange["EUR"]!)
        kantor.setDateOfRate(date: server.currentDay)

        }
    
        // Uncomment the following line to preserve selection between presentations
        // Register cell classes
        // Do any additional setup after loading the view.
    
     override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did Select ItemA=\(indexPath.row)")
        // Sprawdza czy tryb trash jest włączony inaczej kończy metodę
        guard trashEnabled else {
            return
        }
        // okrela wybraną metodę użyeaną w indexPath
        let selectedIcon=database.zestawIcon[indexPath.row]
        
        // dodaje ikonę do tablicy wybranych
        selectedIcons.append(selectedIcon)
        database.zestawIcon[indexPath.row].isFeatured=false
        
    }
    
     override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("did Deselect ItemAt=\(indexPath.row)")
        // sprawdza czy tryb kosza jest dostępny, jeli nie kończy metodę
        guard trashEnabled else {
            return
        }
        let deSelectedIcon=database.zestawIcon[indexPath.row]
        // szuka indeksu odznaczonej ikony
        if let index=selectedIcons.index(where: {$0.name == deSelectedIcon.name}){
            selectedIcons.remove(at: index)
            database.zestawIcon[indexPath.row].isFeatured=true
        }
    }

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return database.zestawIcon.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PaymentCollectionViewCell
    
        // Configure the cell
        
        //let dane = filmList.give(row: listaUlubionych[indexPath.row])
        
        let icon=database.zestawIcon[indexPath.row]
        let price_str = String(format: "%6.2f", icon.price)
        cell.filmImageView.image = UIImage(named: icon.name)
        cell.priceLabel.text = "\(price_str) zł"
        
        // cell.backgroundView=(icon.isFeatured) ? UIImageView(image: UIImage(named: "feature-bg")) : nil
        if !icon.isFeatured {            cell.backgroundColor=UIColor.yellow        }
        else  { cell.backgroundColor = nil }
        
        cell.selectedBackgroundView=UIImageView(image: UIImage(named: "icon-selected"))    
        return cell
    }
    
    func printIcon()
    {
   // print("Icon=\(zestawIcon[0].isFeatured),\(zestawIcon[1].isFeatured),\(zestawIcon[2].isFeatured),\(zestawIcon[3].isFeatured),\(zestawIcon[4].isFeatured),\(zestawIcon[5].isFeatured),\(zestawIcon[6].isFeatured),\(zestawIcon[7].isFeatured),\(zestawIcon[8].isFeatured)")
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    @IBAction  func unwindBeck(segue: UIStoryboardSegue) {
        
    }

}
