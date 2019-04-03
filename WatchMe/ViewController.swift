//
//  ViewController.swift
//  WatchMe
//
//  Created by ashraf on 4/1/19.
//  Copyright © 2019 nesma. All rights reserved.
//

import UIKit
import Alamofire
import WebKit
class ViewController: UIViewController {
   
    @IBOutlet weak var movieImgView: UIImageView!
    @IBOutlet var wkTrailler: WKWebView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet var rating: UIScrollView!
    var movie :Movie?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text=movie?.title
        releaseYear.text=movie?.releaseDate
        let url = URL(string: "https://www.youtube.com/watch?v=695PN9xaEhs")
        wkTrailler.load(URLRequest(url: url!))
        
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

