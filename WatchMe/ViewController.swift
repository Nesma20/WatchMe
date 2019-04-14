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
import CoreData
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var reuseIdentifier:String?
    var flag:Int?
    let api_key="e60603fa13fa5960561302ed2bfb5039"
    var reviewsArray:Array<Review>=[]
    var movieTrailers :Array<String>=[]
    var coreDataObj = CoreDataModel()
    @IBOutlet weak var releaseYear: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var btnAddToFavorite: UIButton!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var rateLbl: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
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
    
    @IBOutlet weak var trailerTableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView==self.tableView
        {
            reuseIdentifier="cellReview"
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier!, for: indexPath) as! ReviewTableViewCell
            
            cell.authorLbl.text=reviewsArray[indexPath.row].authorOfReview
            cell.contentTxt.text=reviewsArray[indexPath.row].contentOfReview
            print(reviewsArray[indexPath.row].contentOfReview)
            return cell
        }
        else if tableView==self.trailerTableView
        {
            reuseIdentifier="cellTrailer"
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier!, for: indexPath)
            cell.textLabel?.text="Trailer \(indexPath.row+1)"
            cell.detailTextLabel?.text=""
            
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView==trailerTableView{
        let youtubeURL = NSURL(string:movieTrailers[indexPath.row])
        if(UIApplication.shared.canOpenURL(youtubeURL as! URL)){
            UIApplication.shared.openURL(youtubeURL as! URL)
        }else{
            print("Cannot open youtube")
        }
        }
        
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView==trailerTableView{
        return 50;
        }
        else {
        return 150;
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        titleTextView.text=movie?.title
        releaseYear.text=movie?.releaseDate
        rateLbl.text=String((movie?.vote)!)
        posterImage.sd_setImage(with: URL(string: (movie?.posterImg)!), placeholderImage: UIImage(named: "play@2x.png"))
        overviewTextView.text=movie?.overview
        
        if coreDataObj.isMovieExist(idOfMovie: (movie?.id)!){
            
            btnAddToFavorite.isEnabled = false
            btnAddToFavorite.isSelected = true
            
        }
        if flag == 1 {
        getReviewsFromURl(idOfMovie: (movie?.id)!,api_key: api_key)
        getTrailersFromURL(idOfMovie: (movie?.id)!,api_key: api_key)
    }
        else if flag == 2 {
            getReviewsFromCoreData()
            getTrailerFromCoreData()
            
        }
    
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.trailerTableView.delegate=self;
        self.trailerTableView.dataSource=self;
    }
    func getReviewsFromCoreData(){
        var reviewsFromCoreData = coreDataObj.getReviewsForSpecificMovie(idOfMovie: (movie?.id)!)
        for i in reviewsFromCoreData
        {
            var review = Review()
            
            review.authorOfReview = i.value(forKey: "author") as! String
           review.contentOfReview = i.value(forKey: "reviewTxt") as! String
           
           
            reviewsArray.append(review)
            
        }
        
    }
    func getTrailerFromCoreData(){
        var trailersFromCoreData = coreDataObj.getTrailersForSpecificMovie(idOfMovie: (movie?.id)!)
        for i in trailersFromCoreData
        {
            
            var trailer = i.value(forKey: "trailer") as! String
           
            
            
            movieTrailers.append(trailer)
            
        }
        
    }
    
    
    
    
    
    func getReviewsFromURl (idOfMovie :Int,api_key:String) {
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
                          
                          let review = Review(authorOfReview: i["author"] as! String, contentOfReview: i["content"] as! String)
                           print(review.authorOfReview)
                           self.reviewsArray.append(review)
                            
                        }
                        
                        self.tableView.reloadData()
                        
                    } catch {
                        print("Error: ", error)
                    }
                    
                }
                
                
        }
        
        
    }
    
    func getTrailersFromURL(idOfMovie:Int,api_key:String){
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
                        
                        self.trailerTableView.reloadData()
                        
                    } catch {
                        print("Error: ", error)
                    }
                    
                }
                
                
        }
        
        
    }
    
    @IBAction func addToFavoriteBtn(_ sender: UIButton) {
        
        SDWebImageManager.shared().saveImage(toCache: posterImage.image, for: URL(string: (movie?.posterImg)!))
        var coreDataObj = CoreDataModel()
        
        var addMovie = coreDataObj.addMovie(movieWillSaved: movie!)
        if reviewsArray.count > 0 && movieTrailers.count > 0{
        var addReview = coreDataObj.addReviewsForMovie(idOfMovie: movie!.id, reviews: reviewsArray)
            
        var addTrailer = coreDataObj.addTrailers(idOfMovie: movie!.id, trailers: movieTrailers)
        if addMovie && addReview && addTrailer {
            print("Data Saved")
        }
        }
        else
        {
            print("Movie Without reviews or trailers Saved")

        }
        
        btnAddToFavorite.isEnabled = false
        btnAddToFavorite.isSelected = true
        
    }
    

}
    
    
    




