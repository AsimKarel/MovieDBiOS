//
//  MovieCollectionViewCell.swift
//  MoviewDBTask
//
//  Created by Asim Karel on 04/02/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import UIKit
import Alamofire
class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterUIImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    public func setMovie(movie:Movie){
        
        nameLabel.text = movie.title;
        if movie.posterPath == nil{
            self.posterUIImage?.image = UIImage(named: "no_image.png")
        }
        else{
            if(MyFileManager.sharedInstance().fileExistsAtLocalDocumentDirectory(path: movie.posterPath!)){
                self.posterUIImage.image = UIImage(contentsOfFile: MyFileManager.sharedInstance().getFilePathAtLocalDocumentDirectory(path: movie.posterPath!))
            }
            else{
                self.downloadImages(name: movie.posterPath!) {
                    path in
                    self.posterUIImage?.image = UIImage(contentsOfFile: path)
                }
            }
        }
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
