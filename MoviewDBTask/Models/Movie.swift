//
//  Movie.swift
//  MoviewDBTask
//
//  Created by Asim Karel on 04/02/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import Foundation
import UIKit
class Movie: NSObject {
    var id:Int64!;
    var title:String!;
    var thumbnail:UIImage!;
    var posterPath:String!;
    var plotSynopsis:String!;
    var ratings:String!;
    var releaseDate:String!;
    
    override init() {
        super.init();
    }
    
    init(dictionary dict:NSDictionary) {
        if dict["id"] != nil {
            id = dict["id"] as? Int64;
        }
        if dict["title"] != nil {
            title = dict["title"] as? String;
        }
        if dict["poster_path"] != nil {
            posterPath = dict["poster_path"] as? String;
        }
        if dict["overview"] != nil {
            plotSynopsis = dict["overview"] as? String;
        }
        if dict["release_date"] != nil {
            releaseDate = dict["release_date"] as? String;
            if releaseDate == ""
            {
                releaseDate = "Not available";
            }
        }
        else
        {
            releaseDate = "Not available";
        }
        
        if dict["vote_average"] != nil {
            ratings = String(describing: dict["vote_average"] as! NSNumber);
        }
        else
        {
            ratings = "Not available";
        }
    }
    
}
