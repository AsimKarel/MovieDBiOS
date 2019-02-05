//
//  MovieBL.swift
//  MoviewDBTask
//
//  Created by Asim Karel on 05/02/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import Foundation
import Alamofire
class MovieBL: NSObject {
    
    public func getMovieDetails(route:String, params:Parameters,success_callback success: ((Movie) -> Void)?, failure_callback failure: ((APIResponse) -> Void)?){
        func getListSuccess(response:APIResponse){
            success!(Movie(dictionary: (response.data as! NSDictionary)));
        }
        func getListFailure(response:APIResponse){
            failure!(response);
        }
        NetworkService.sharedInstance().getAPI(route: route, parameters: params, success_callback: getListSuccess, failure_callback: getListFailure)
    }
    
    public func getMovieList(route:String, params:Parameters,success_callback success: (([Movie]) -> Void)?, failure_callback failure: ((APIResponse) -> Void)?){
        func getListSuccess(response:APIResponse){
            var movies:[Movie] = [Movie]();
            for movieDict in ((response.data as! NSDictionary)["results"] as! NSArray){
                let newMovie = Movie(dictionary: movieDict as! NSDictionary);
                movies.append(newMovie);
            }
            success!(movies);
        }
        func getListFailure(response:APIResponse){
            failure!(response);
        }
        NetworkService.sharedInstance().getAPI(route: route, parameters: params, success_callback: getListSuccess, failure_callback: getListFailure)
    }

}
