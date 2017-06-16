//
//  VideoViewController.swift
//  DVDShop
//
//  Created by Slawek Kurczewski on 05.05.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {
    var dvdImageTmp = ""
    var titleLabelTmp = ""
    var actorsLabelTmp = ""
    var typeLabelTmp = ""
    var descriptionLabelTmp = ""
    var priceLabelTmp = ""
    var youtubeUrlTmp = ""

    @IBOutlet var descriptionsTextView: UITextView! {
        didSet {
            descriptionsTextView.text=descriptionLabelTmp
        }
    }
    @IBOutlet var videoView: UIWebView! {
        didSet {
            let filmUrl=youtubeUrlTmp
            let youtubeUrl="<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/\(filmUrl)?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe>"
            videoView.loadHTMLString(youtubeUrl, baseURL: nil)
 
        }
    }
    
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

}
