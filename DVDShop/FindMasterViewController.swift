//
//  FindMasterViewController.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 08.05.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit

class FindMasterViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return obrazki.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MasterTableViewCell
        
        // Configure the cell...
        
        let dane = filmList.give(row: indexPath.row)
        cell.DVDImage.image = dane.filmImage
        cell.titleLabel.text = dane.title
        cell.actorsLabel.text = dane.actors
        cell.typLabel.text = dane.type
        cell.priceLabel.text = dane.price
        
        if dane.isLiked==true {
            cell.backgroundColor=UIColor.green
        }
        else
        {
            cell.backgroundColor=UIColor.clear
            //cell.seec
        }
        
        return cell
    }


}
