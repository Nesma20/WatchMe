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
    var movieList:Array<Movie> = [];
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(URL(string: "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=e60603fa13fa5960561302ed2bfb5039")!)
            .validate()
            .response { (response) in
                if let data = response.data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                        
                        print(json["results"])
                             var results = json["results"] as! Array<Dictionary<String,Any>>

                            for i in results{
                                let movie = Movie(id: i["id"] as! Int, title: i["title"] as! String, releaseDate: (i["release_date"] as! String), vote: (i["vote_average"] as! Double), posterImg: i["backdrop_path"] as! String)
                                print(movie.id)
                                self.movieList.append(movie)
                                
                                
                        }
                    } catch {
                        print("Error: ", error)
                    }
                    
                }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
       

        // Do any additional setup after loading the view.
    }
    
    func loadPoster(posterPath:String) -> UIImageView
    {
        var imageview:UIImageView?
        imageview?.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w185/\(posterPath)"), placeholderImage: UIImage(named: "play@2x.png"))
    
        
        return imageview!
    
    
    }
    

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

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
       
        cell.movieImg = loadPoster(posterPath: movieList[indexPath.item].posterImg)

        
        // Configure the cell
    
        return cell
    }
    
override
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "viewDetails") as! ViewController
    secondViewController.movie=movieList[indexPath.row]
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
