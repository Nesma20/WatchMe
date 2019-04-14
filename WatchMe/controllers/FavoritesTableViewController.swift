//
//  FavoritesTableViewController.swift
//  WatchMe
//
//  Created by ashraf on 4/2/19.
//  Copyright © 2019 nesma. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage
class FavoritesTableViewController: UITableViewController {
    var movies:Array<NSManagedObject> = []
    var moviesArray:Array<Movie> = []
    var coreDataObj = CoreDataModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies()
        //coreDataObj.deleteAllData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return moviesArray.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        cell.favoriteMovieImg.sd_setImage(with: URL(string: moviesArray[indexPath.row].posterImg), placeholderImage: UIImage(named: "play@2x.png"))
        cell.favoriteMovieTitle.text = moviesArray[indexPath.row].title
        cell.favoriteMovieRate.text = String(moviesArray[indexPath.row].vote)
       

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("select row ")
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "viewDetails") as! ViewController
        secondViewController.movie = moviesArray[indexPath.row]
        secondViewController.flag = 2
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
 

    func getMovies(){
        movies = coreDataObj.getMoviesData()
        for i in movies
        {
            var movie = Movie()
            movie.id = i.value(forKey: "id") as! Int
            movie.title = i.value(forKey: "title") as! String
            movie.vote = i.value(forKey: "rate") as! Double
            movie.releaseDate = i.value(forKey: "releaseDate") as! String
            
            movie.posterImg = i.value(forKey: "poster") as! String
            movie.overview = i.value(forKey: "overview") as! String
            print(movie.title)
            moviesArray.append(movie)
            
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
    

}
