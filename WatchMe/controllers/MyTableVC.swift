//
//  MyTableVC.swift
//  WatchMe
//
//  Created by ashraf on 4/4/19.
//  Copyright © 2019 nesma. All rights reserved.
//

import UIKit
import Alamofire
class MyTableVC: UITableViewController {

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
                        self.tableView.reloadData()
                        
                    } catch {
                        print("Error: ", error)
                    }
                    
                }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return movieList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = movieList[indexPath.row].title

        // Configure the cell...

        return cell
    }
    
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
