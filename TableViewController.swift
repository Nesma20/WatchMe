//
//  TableViewController.swift
//  WatchMe
//
//  Created by ashraf on 4/6/19.
//  Copyright © 2019 nesma. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
class TableViewController: UITableViewController {
    let api_key="e60603fa13fa5960561302ed2bfb5039"
private let reuseIdentifier="cellReview"
    var MovieSelected:Movie!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var releaseYearLbl: UILabel!
    
    @IBOutlet weak var rateLbl: UILabel!
    
    
    @IBOutlet weak var reviewTableVIew: UITableView!
    var reviewsArray:Array<Review>=[]
    
    @IBAction func addToFavoriteBtn(_ sender: Any) {
    }
    
    @IBOutlet weak var trailerTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text=MovieSelected?.title;
        releaseYearLbl.text=MovieSelected?.releaseDate
        rateLbl.text=String((MovieSelected?.vote)!)
        posterImg.sd_setImage(with: URL(string: (MovieSelected?.posterImg)!), placeholderImage: UIImage(named: "play@2x.png"))
        

   
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ReviewTableViewCell
        cell.authorLbl.text=reviewsArray[indexPath.row].authorOfReview
        cell.contentTxt.text=reviewsArray[indexPath.row].contentOfReview
        return cell
    }
    

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
                        
                        self.reviewTableVIew.reloadData()
                        
                    } catch {
                        print("Error: ", error)
                    }
                    
                }
                
                
        }
}
}
