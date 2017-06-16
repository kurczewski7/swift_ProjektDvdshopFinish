//
//  PrzelewViewController.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 04.05.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit

class PrzelewViewController: UIViewController {

    @IBOutlet var PrzelewWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlStr = kantor.giveUrlBank(nrBanku: kantor.giveCurrentBank())
        let myUrl = URL(string: urlStr)
        let urlRequest=URLRequest(url: myUrl!)
        PrzelewWebView.loadRequest(urlRequest )

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

}
