//
//  ViewController.swift
//  WatchMe
//
//  Created by ashraf on 4/1/19.
//  Copyright © 2019 nesma. All rights reserved.
//

import UIKit
import Alamofire
import  SDWebImage
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var reuseIdentifier:String?

    let api_key="e60603fa13fa5960561302ed2bfb5039"
    var reviewsArray:Array<Review>=[]
    var movieTrailers :Array<String>=[]
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    var movie :Movie?
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==self.tableView {
       return reviewsArray.count
        }
        else
        {
        return movieTrailers.count
        }
    }
    
    @IBOutlet weak var reviewTavleView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView==self.tableView
        {
            reuseIdentifier="cellReview"
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier!, for: indexPath) as! ReviewTableViewCell
            
            cell.authorLbl.text=reviewsArray[indexPath.row].authorOfReview
            cell.contentTxt.text=reviewsArray[indexPath.row].contentOfReview
            return cell
        }
        else if tableView==self.reviewTavleView
        {
            reuseIdentifier="cellTrailer"
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier!, for: indexPath)
            cell.textLabel?.text="Trailer\(indexPath.row+1)"
            cell.detailTextLabel?.text=""
            
            return cell
        }
        return UITableViewCell()
        
        
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        titleLbl.text=movie?.title
        releaseYear.text=movie?.releaseDate
        rateLbl.text=String((movie?.vote)!)
        posterImage.sd_setImage(with: URL(string: (movie?.posterImg)!), placeholderImage: UIImage(named: "play@2x.png"))
        
        let url = URL(string: "https://www.youtube.com/watch?v=695PN9xaEhs")
 
//        wkTrailler.load(URLRequest(url: url!))
       
        getReviews(idOfMovie: (movie?.id)!,api_key: api_key)
        getTrailers(idOfMovie: (movie?.id)!,api_key: api_key)
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.reviewTavleView.delegate=self;
        self.reviewTavleView.dataSource=self;
    }
    
    func getReviews (idOfMovie :Int,api_key:String) {
        let id=String(idOfMovie)
       var url:String="https://api.themoviedb.org/3/movie/\(id)/reviews?api_key=\(api_key)"
       
        Alamofire.request(URL(string: url)!)
            .validate()
            .response { (response) in
                if let data = response.data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                        
                       
                        var results = json["results"] as! Array<Dictionary<String,Any>>
                        
                        for i in results{
//                            var = i["author"] as! String
//                           
//                            
                          let review = Review(authorOfReview: i["author"] as! String, contentOfReview: i["content"] as! String)
                           print(review.authorOfReview)
                           self.reviewsArray.append(review)
//                            
                            
                        }
                        
                        self.tableView.reloadData()
                        
                    } catch {
                        print("Error: ", error)
                    }
                    
                }
                
                
        }
        
        
    }
    
    func getTrailers(idOfMovie:Int,api_key:String){
        let id=String(idOfMovie)
        var url:String="https://api.themoviedb.org/3/movie/\(id)/videos?api_key=\(api_key)"
        
        Alamofire.request(URL(string: url)!)
            .validate()
            .response { (response) in
                if let data = response.data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                        
                        
                        var results = json["results"] as! Array<Dictionary<String,Any>>
                        
                        for i in results{
                          
                            let trailer = i["key"] as! String
                            self.movieTrailers.append("https://www.youtube.com/watch?v=\(trailer)")
                            print(self.movieTrailers.count)
                        }
                        
                        self.reviewTavleView.reloadData()
                        
                    } catch {
                        print("Error: ", error)
                    }
                    
                }
                
                
        }
        
        
    }
    
    @IBAction func addToFavoriteBtn(_ sender: UIButton) {
        
        
    }
    
    


}

