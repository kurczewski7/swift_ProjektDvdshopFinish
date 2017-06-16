//
//  AdminViewController.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 17.05.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {
    var tekst: String = ""
    var tx: [String] = ["","","","","","","","","","",""]
    
    @IBOutlet var obrazekImageView: UIImageView!
    @IBOutlet var textView: UITextView!
    @IBAction func getSqlButton(_ sender: UIButton) {
        textView.text = server.makeSqlTxt(database: database)
        let data = server.getPictureWeb(pictureName: server.dvds[19].filmImageName)
        obrazekImageView.image=UIImage(data: data!)
        print("Obrazek="+server.dvds[19].filmImageName)
    }
    @IBAction func downloadButton(_ sender: UIButton) {
        server.getLatestDvds()
        print("Załadowano \(server.dvds.count) rekordów z sieci")
    }
    @IBAction func sentButton(_ sender: Any) {
        textView.text = server.makeJsonTxt(database: database)
    }
    @IBAction func readJsonFromWebActionButton(_ sender: Any) {
        tekst="count=\(server.dvds.count)\n"
        if server.dvds.count>0 {
        tekst+=server.dvds[0].title+"\n"
        for i in 0..<server.dvds.count {
            tekst+=server.dvds[i].title+"\n"
            tekst+=server.dvds[i].filmDescription+"\n"
            tekst+=server.dvds[i].filmImageName+"\n"
            tekst+=server.dvds[i].type+"\n"
            tekst+=server.dvds[i].price+"\n"
            tekst+=server.dvds[i].youtubeUrl+"\n"
            tekst+="--------\n"
            }
        }
        textView.text=tekst
    }
    
    @IBAction func dBClearActionButton(_ sender: UIButton) {
        database.deleteTableBase()
        database.saveDatabase()
        print("Czyszccenie bazy- rekordów:\(database.flimsbaseFull.count)")
    }
    
    @IBAction func dbWebActonButton(_ sender: UIButton) {
        database.addDataToBaseFromWeb(dvds: server.dvds)
        database.saveDatabase()
       print("Wypełnienie bazy z web- rekordów:\(database.flimsbaseFull.count)")
    }
    
    @IBAction func readDatabaseBarButton(_ sender: Any) {
        var txt=""
        for i in 0..<database.flimsbaseFull.count{
            txt+=database.flimsbaseFull[i].title!+"\n"
            txt+=database.flimsbaseFull[i].youtubeUrl!+"\n"
            txt+=database.flimsbaseFull[i].pictureName!+"\n"
            txt+="----------------\n"
        }
        textView.text=(database.flimsbaseFull.count==0) ? "Pusta baza": txt
    }
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction  func unwindBeck(segue: UIStoryboardSegue) {
        
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
