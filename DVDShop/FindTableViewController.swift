//
//  FindTableViewController.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 08.05.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit

class FindTableViewController: UITableViewController {
    var database=Database()
    var fieldNameTmp  = ""
    var seekValueTmp = ""
    var fieldTypeTmp: TypeFilterFields = .tytul
    
    @IBOutlet var totalPriceTextField: UITextField!
    
    @IBAction func refreshActonBarButton(_ sender: UIBarButtonItem) {
        tableView.reloadData()
    }
    
    
    @IBAction func presetCellLongPresureRecognizer(_ sender: UILongPressGestureRecognizer) {
        print("******","Naciśnięto długo")
    }
    @IBAction func makeScreenEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {

            print("******","Przeciągnięto")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database.filmsbaseFilter=database.fillFilterData(field: fieldTypeTmp, seekValue: seekValueTmp)
        self.title="Znalezione: \(database.filmCount)"
        kantor.setTotalPriceTexeditAtrybute(totalPrice: totalPriceTextField)
        
        // Uncomment the following line to preserve selection between presentations
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  database.filmCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FindTableViewCell
        
        print("row TV =\(indexPath.row), filmCount=\(database.filmCount), flimsbaseFull.count=\(database.flimsbaseFull.count), filmsbaseFilter.count=\(database.filmsbaseFilter.count)")
        print("filtr:\(database.isFilterOn)")
        // Configure the cell...
        
        let row = database.getPhisicalRow(row: indexPath.row, onFilter: database.isFilterOn )
        
        let film=database.getFilm(row: row)
        if database.filmCount > indexPath.row {
            cell.titleLabel.text=film.title
            cell.actorsLabel.text=film.actors
            cell.typLabel.text=film.type
            cell.priceLabel.text=String.init(format: "%6.2f", film.price)
            cell.DVDImage.image=UIImage(data: film.filmImage! as Data)
            cell.accessoryType = film.isLiked ? .checkmark : .none
            cell.backgroundColor = film.isLiked ? UIColor.green : UIColor.clear
            print("tytul=\(cell.titleLabel)")
        }
        

        return cell
    }
    @IBAction  func unwindBeck(segue: UIStoryboardSegue) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier=="showFound" {
            if let indexPath=tableView.indexPathForSelectedRow {
                let destinatonController = segue.destination as! FoundDetailViewController
                
                let cuurRow = database.isFilterOn ? database.filmsbaseFilter[indexPath.row] : indexPath.row
                let rek=database.getFilm(row: cuurRow)
                destinatonController.dvdImageTmp   =  filmList.giveCurrentPictureName(row: indexPath.row)
                destinatonController.titleLabelTmp =  rek.title!
                destinatonController.actorsLabelTmp  =  rek.actors!
                destinatonController.typeLabelTmp  =  rek.type!
                destinatonController.priceLabelTmp =  kantor.doubleToString(rek.price)
                destinatonController.youtubeUrlTmp =  rek.youtubeUrl!
                destinatonController.descriptionLabelTmp =  rek.filmDescription!
                destinatonController.rowTmp=kantor.intToString(indexPath.row)
                destinatonController.phisicalRowTmp = kantor.intToString(database.getPhisicalRow(row: indexPath.row, onFilter: database.isFilterOn))
                
                print("segue showFound, row=\(indexPath.row)")
            }
        }
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Social Sharing Button
        let  currCell = tableView.cellForRow(at: indexPath)
        let isChecked = currCell?.accessoryType == .checkmark
        let phisicalRow = database.getPhisicalRow(row: indexPath.row, onFilter: database.isFilterOn)
        
        // Delete button
        // Delete the row from the data source
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete",handler: { (action, indexPath) -> Void in
                        self.database.filmsbaseFilter.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        self.title="Filmy znalezione: \(self.database.filmsbaseFilter.count)"
        })
        
        // Zaznacz button
        let checkAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Zaznacz",handler: { (action, indexPath) -> Void in
            currCell?.accessoryType = .checkmark
            currCell?.backgroundColor = UIColor.green
            self.database.setCheckRecord(phisicalRow: phisicalRow, value: true)
            self.database.saveDatabase()
            filmList.setIsLike(row: phisicalRow, isLike: true)
        })
        
        // Odznacz button
        let unCheckAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Odznacz",handler: { (action, indexPath) -> Void in
            currCell?.accessoryType = .none
            currCell?.backgroundColor = UIColor.clear
            self.database.setCheckRecord(phisicalRow: phisicalRow, value: false)
            self.database.saveDatabase()
            filmList.setIsLike(row: phisicalRow, isLike: false)
        })
        
        checkAction.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        unCheckAction.backgroundColor = UIColor.lightGray
        deleteAction.backgroundColor = UIColor.red
        
        return isChecked ? [deleteAction, unCheckAction] : [deleteAction, checkAction]
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
        cell.layer.transform=rotationTransform
        UIView.animate(withDuration: 0.6) {            cell.layer.transform = CATransform3DIdentity        }
    }
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        database.refreshTotalPrice()
        self.totalPriceTextField.text =  kantor.giveTotalPriceZlotyText()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
 
    // Override to support editing the table view.

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
