//
//  DetailsViewController.swift
//  MoviewDBTask
//
//  Created by Asim Karel on 04/02/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import UIKit
import Alamofire
class DetailsViewController: UIViewController {

    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    var id:Int64!;
    var movie:Movie!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieDetails();
        // Do any additional setup after loading the view.
    }
    
    func setValues() {
        dateLabel.text = movie.releaseDate;
        nameLabel.text = movie.title;
        ratingLabel.text = movie.ratings.description;
        detailsLabel.text = movie.plotSynopsis;
    }

    public func getMovieDetails(){
        var params:Parameters = Parameters();
        func getListSuccess(response:APIResponse){
            movie = Movie(dictionary: (response.data as! NSDictionary));
            setValues()
        }
        func getListFailure(response:APIResponse){
            
        }
        NetworkService.sharedInstance().getAPI(route: "https://api.themoviedb.org/3/movie/\(id!)", parameters: params, success_callback: getListSuccess, failure_callback: getListFailure)
    }

}
