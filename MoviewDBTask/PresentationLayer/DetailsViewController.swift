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
        if movie.posterPath == nil{
            self.thumbnailImage?.image = UIImage(named: "no_image.png")
        }
        else{
            if(MyFileManager.sharedInstance().fileExistsAtLocalDocumentDirectory(path: movie.posterPath!)){
                self.thumbnailImage.image = UIImage(contentsOfFile: MyFileManager.sharedInstance().getFilePathAtLocalDocumentDirectory(path: movie.posterPath!))
            }
            else{
                self.downloadImages(name: movie.posterPath!) {
                    path in
                    self.thumbnailImage?.image = UIImage(contentsOfFile: path)
                }
            }
        }
    }

    @IBAction func doneButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    public func getMovieDetails(){
        var params:Parameters = Parameters();
        func getListSuccess(response:APIResponse){
            movie = Movie(dictionary: (response.data as! NSDictionary));
            setValues()
        }
        func getListFailure(response:APIResponse){
            
        }
        NetworkService.sharedInstance().getAPI(route: "\(APIConstants.MOVIE_DETAIL_API)\(id!)", parameters: params, success_callback: getListSuccess, failure_callback: getListFailure)
    }
    
    
    public func downloadImages(name:String, completionHandler: @escaping (String) -> Void){
        var param:Parameters = Parameters();
        //        param["path"] = route;
        func downloadImageBlobSuccess(response:APIResponse){
            completionHandler(response.imagePath!)
        }
        func downloadImageBlobFailure(response:APIResponse){
            print("Cannot download Image")
        }
        NetworkService.sharedInstance().downloadImage(name: name, success_callback: downloadImageBlobSuccess, failure_callback: downloadImageBlobFailure)
    }

}
