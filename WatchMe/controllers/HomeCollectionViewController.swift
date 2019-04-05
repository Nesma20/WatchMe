//
//  HomeCollectionViewController.swift
//  WatchMe
//
//  Created by ashraf on 4/2/19.
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
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(URL(string: "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=\(api_key)")!)
            .validate()
            .response { (response) in
                if let data = response.data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                        
                        print(json["results"])
                             var results = json["results"] as! Array<Dictionary<String,Any>>

                            for i in results{
                                var imageName = i["backdrop_path"] as! String
                                var imageUrl = self.BASEURL_FOR_IMAGE+imageName
                                
                                let movie = Movie(id: i["id"] as! Int, title: i["title"] as! String, releaseDate: (i["release_date"] as! String), vote: (i["vote_average"] as! Double), posterImg: imageUrl)
                                print(movie.id)
                                self.movieList.append(movie)
                                
                                
                        }
                        self.collectionView?.reloadData()
                    } catch {
                        print("Error: ", error)
                    }
                    
                }
                
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       
self.collectionView?.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func loadPoster(posterPath:String) -> UIImageView
    {
        var imageview:UIImageView?
        imageview?.sd_setImage(with: URL(string: "\(posterPath)"), placeholderImage: UIImage(named: "play@2x.png"))
    
        self.collectionView?.reloadData()
        
        return imageview!
    
    
    }
    
/*
    func getImageUsingPosterPath(posterPath : String, completionHandler : @escaping (Data?, Error?) -> Void){
        let mURL = URL(string: "https://image.tmdb.org/t/p/w185\(posterPath)")!
        
        // Creating a session object with the default configuration.
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        _ = session.dataTask(with: mURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Do something with your image.
                        completionHandler(imageData, nil)
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
            }.resume()
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

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
        print(" " + movieList[indexPath.item].posterImg)
    
        return cell
    }
    
    
override
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "viewDetails") as! ViewController
    secondViewController.movie=movieList[indexPath.item]
    self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
