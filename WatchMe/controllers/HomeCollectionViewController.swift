//
//  HomeCollectionViewController.swift
//  WatchMe
//
//  Created by nesma on 4/2/19.
//  Copyright © 2019 nesma. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
private let reuseIdentifier = "cell"

class HomeCollectionViewController: UICollectionViewController {
    let BASEURL_FOR_IMAGE="https://image.tmdb.org/t/p/w185"
    let BASEURL_FOR_ALAMOFIRE="https://api.themoviedb.org/3/discover/movie?sort_by=vote_average.desc"
    let api_key="e60603fa13fa5960561302ed2bfb5039"
    var movieList:Array<Movie> = [];
    var movieListForPopularity:Array<Movie>=[]
    var movieLsitForRate:Array<Movie>=[]
    
    @IBOutlet var segmentControl: UISegmentedControl?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl?.selectedSegmentIndex=0
        segmentControl?.addTarget(self, action: "chaneState:", for: .touchDown)
        if Reachability.isConnectedToNetwork() {
            print("connected to the network")
            UIApplication.shared.isNetworkActivityIndicatorVisible = true;
            
        Alamofire.request(URL(string: "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=\(api_key)")!)
            .validate()
            .response { (response) in
                if let data = response.data {
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                        
                        print(json["results"])
                             var results = json["results"] as! Array<Dictionary<String,Any>>

                            for i in results{
                                var imageName = i["poster_path"] as! String
                                var imageUrl = self.BASEURL_FOR_IMAGE+imageName
                                
                                let movie = Movie(id: i["id"] as! Int, title: i["title"] as! String, releaseDate: (i["release_date"] as! String), vote: (i["vote_average"] as! Double), posterImg: imageUrl, overview: i["overview"] as! String)
                                print(movie.id)
                                self.movieList.append(movie)
                                
                                
                        }
                        self.movieListForPopularity=self.movieList
                        self.sortMovies(list: self.movieList)
                        self.collectionView?.reloadData()
                    } catch {
                        print("Error: ", error)
                    }
                    
                }
                
        }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false;
            
        }
        else {
            print("can't connect to network")
        }
       
self.collectionView?.reloadData()
        // Do any additional setup after loading the view.
    }
    func sortMovies(list:Array<Movie>) {
        print("sort movies .........")
        movieLsitForRate=movieList
        movieLsitForRate.sort(by: {$0.vote > $1.vote})
        for i in movieLsitForRate{
            print(i.vote)
        }
    }
    @IBAction func chaneState(_ sender: UISegmentedControl) {
        print("enter")
        switch segmentControl?.selectedSegmentIndex
        {
        case 0?:
            print("case 0 .........")
            
            movieList = movieListForPopularity
            self.collectionView?.reloadData()
        case 1?:
            print("case 1 .........")
            
            movieList = movieLsitForRate
            self.collectionView?.reloadData()
            
            break
            
            
        default: break
        }
    
    
    
    }
 

  
    
    
    

   

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movieList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> MyCollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
       
        cell.movieImg.sd_setImage(with: URL(string: movieList[indexPath.item].posterImg), placeholderImage: UIImage(named: "play@2x.png"))
        cell.movieTitle.text=movieList[indexPath.item].title
        cell.movieRate.text = String( movieList[indexPath.item].vote)
        print(" " + movieList[indexPath.item].posterImg)
    
        return cell
    }
    
    
override
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "viewDetails") as! ViewController
    secondViewController.movie=movieList[indexPath.item]
    secondViewController.flag = 1
    self.navigationController?.pushViewController(secondViewController, animated: true)
    }
  



}
