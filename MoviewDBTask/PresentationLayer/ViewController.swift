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
    var selectedMovieId:Int64!;
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var sortTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var sortOrderSegmentControl: UISegmentedControl!
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovieId = movies[indexPath.row].id;
        self.performSegue(withIdentifier: "detailSegue", sender: self);
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"{
            if let destination = segue.destination as? DetailsViewController{
                destination.id = selectedMovieId;
            }
        }
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
    
    @IBAction func sortTypeSelected(_ sender: Any) {
        
    }
    
    @IBAction func sortOrderSelected(_ sender: Any) {
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
        params["sort_by"] = "vote_average.desc";
        func getListSuccess(response:[Movie]){
            movies.append(contentsOf: response);
            moviesCollectionView.reloadData();
        }
        func getListFailure(response:APIResponse){
            
        }
        MovieBL().getMovieList(route: "https://api.themoviedb.org/3/discover/movie", params: params, success_callback: getListSuccess, failure_callback: getListFailure)
        //NetworkService.sharedInstance().getAPI(route: "https://api.themoviedb.org/3/discover/movie", parameters: params, success_callback: getListSuccess, failure_callback: getListFailure)
    }
    
}

