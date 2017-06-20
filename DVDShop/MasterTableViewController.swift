//
//  MasterTableViewController.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 26.04.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//
import UIKit



// MARK: Wczytywanie danych zewnętrznych do obiektu

var filmList:FilmList = FilmList(filmsName: setup.obrazki, titles: setup.tytuly, actorsList: setup.aktorzy, typeList: setup.typyFilmow, descriptions: setup.opisyFilmow, priceList: setup.cenyFilmow, youtubeUrlList: setup.youtubeUrls, likedList: setup.polubienia)

//var database: Database
class MasterTableViewController: UITableViewController {
    
    @IBOutlet var totalPriceTextField: UITextField!
    
    var film: TypeOfFilm = .horror
    let  dvdFilm: (picture: String, title: String, actors: String, type: TypeOfFilm, price: String) = (picture: "obrazek",  title: "tytul",  actors: "Aktorzy", type: .horror, price: "Cena")
    var dvdFilms = [(picture: String, title: String, actors: String, type: TypeOfFilm, price: String)]()
    var myDvd = ("aaa", "bbb", "cccc", TypeOfFilm.komedia)
    
    @IBAction func refreshActionBarButton(_ sender: Any) {
       tableView.reloadData()
       self.title="Filmy: \(database.flimsbaseFull.count)"
       database.refreshTotalPrice()
       self.totalPriceTextField.text =  kantor.giveTotalPriceZlotyText()
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup.readSampleData()
        tableView.reloadData()
        self.title="Filmy : \(database.flimsbaseFull.count)"
        print("----- MasterTableViewController ------")
        
        // wywołanie leniwej inicjalizacji
        kantor.totalPriceInZloty=database.totalPrice
        kantor.setTotalPriceTexeditAtrybute(totalPrice: totalPriceTextField)
        
        // wywołanie leniwej inicjalizacji
        if server.dvds.count>0 {
            let tekst: String = server.dvds[0].title
            print("wywołanie leniwej inicjalizacji dla dvds -\(tekst)")
        }
        
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
        return database.flimsbaseFull.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MasterTableViewCell

        // Configure the cell...
                let film=database.getFilm(row: indexPath.row)
                if database.flimsbaseFull.count > indexPath.row {
                    cell.titleLabel.text=film.title
                    cell.actorsLabel.text=film.actors
                    cell.typLabel.text=film.type
                    cell.priceLabel.text=String.init(format: "%6.2f", film.price)
                    cell.DVDImage.image=UIImage(data: film.filmImage! as Data)
                    cell.accessoryType = film.isLiked ? .checkmark : .none
                    cell.backgroundColor = film.isLiked ? UIColor.green : UIColor.clear
                    // print("tytul = \(cell.titleLabel)")
                }
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha=0.2
        UIView.animate(withDuration: 1.0, animations:  { cell.alpha = 1})
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    @IBAction  func unwindBeck(segue: UIStoryboardSegue) {
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("-----   prepare  MasterTableViewController   ------")

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
            if segue.identifier=="showDvd" {
                if let indexPath=tableView.indexPathForSelectedRow {
                    let destinatonController = segue.destination as! DetailViewController
                    
                    let rek=database.getFilm(row: indexPath.row)
                    destinatonController.dvdImageTmp   = rek.pictureName!  //filmList.giveCurrentPictureName(row: indexPath.row)
                    destinatonController.titleLabelTmp =  rek.title!
                    destinatonController.actorsLabelTmp  =  rek.actors!
                    destinatonController.typeLabelTmp  =  rek.type!
                    destinatonController.priceLabelTmp = kantor.doubleToString(rek.price)  //rek.price
                    destinatonController.youtubeUrlTmp =  rek.youtubeUrl!
                    destinatonController.descriptionLabelTmp = filmList.give(row: indexPath.row).description
                    destinatonController.currentRowTmp = indexPath.row
                }
            }
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let  currCell = tableView.cellForRow(at: indexPath)
        let isChecked = currCell?.accessoryType == .checkmark
        let phisicalRow = database.getPhisicalRow(row: indexPath.row)
        
         //Social Sharing Button
         let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Share", handler: { (action, indexPath) -> Void in
                    let defaultText = "Polecany  \(setup.tytuly[indexPath.row])"
                    if let imageToShare = UIImage(named: setup.obrazki[indexPath.row]) {
                        let activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                        self.present(activityController, animated: true, completion: nil)
                    }
                })
        
        // Zaznacz button
        let checkAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Zaznacz",handler: { (action, indexPath) -> Void in
            currCell?.accessoryType = .checkmark
            currCell?.backgroundColor = UIColor.green
            database.setCheckRecord(phisicalRow: phisicalRow, value: true)
            database.saveDatabase()
            filmList.setIsLike(row: phisicalRow, isLike: true)
        })
        
        // Odznacz button
        let unCheckAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Odznacz",handler: { (action, indexPath) -> Void in
            currCell?.accessoryType = .none
            currCell?.backgroundColor = UIColor.clear
            database.setCheckRecord(phisicalRow: phisicalRow, value: false)
            database.saveDatabase()
            filmList.setIsLike(row: phisicalRow, isLike: false)
        })
        
        checkAction.backgroundColor = UIColor(red: 48.0/255.0, green: 173.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        unCheckAction.backgroundColor = UIColor.lightGray
        shareAction.backgroundColor = UIColor.blue
        return isChecked ? [shareAction, unCheckAction] : [shareAction, checkAction]
    }


    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Usuń"
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
}
