//
//  ViewController.swift
//  MoviewDBTask
//
//  Created by Asim Karel on 04/02/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    var movies:[Movie]!
    var page:Int!;
    var params:Parameters!;
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movies = [Movie]();
        params = Parameters();
        page = 1;
        getMovies();
        // Do any additional setup after loading the view, typically from a nib.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        let movie:Movie = movies[indexPath.row];
        collectionCell.setMovie(movie: movie);
        if indexPath.row == movies.count-1 {
            page = page + 1;
            getMovies();
        }
        
        
        return collectionCell;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            let padding: CGFloat =  30
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize/5, height: collectionViewSize/5)
        }
        else{
            let padding: CGFloat =  10
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
        }
        
    }
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true;
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false;
        searchBar.text = "";
        searchBar.endEditing(true);
    }
    
    
    public func getMovies(){
        params["page"] = page!;
        func getListSuccess(response:APIResponse){
            for movieDict in ((response.data as! NSDictionary)["results"] as! NSArray){
                let newMovie = Movie(dictionary: movieDict as! NSDictionary);
                movies.append(newMovie);
            }
            moviesCollectionView.reloadData();
        }
        func getListFailure(response:APIResponse){
            
        }
        NetworkService.sharedInstance().getAPI(route: "", parameters: params, success_callback: getListSuccess, failure_callback: getListFailure)
    }
    
}

