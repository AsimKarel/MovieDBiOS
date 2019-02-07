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
    
    var selectedMovieId:Int64!;
    var selectedSortType:String!;
    var selectedSortOrder:String!;
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var sortTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var sortOrderSegmentControl: UISegmentedControl!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movies = [Movie]();
        loader.stopAnimating();
//        params = Parameters();
        page = 1;
        selectedSortType = "popularity";
        selectedSortOrder = "asc";
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
    
    @IBAction func sortTypeSelected(_ sender: UISegmentedControl) {
        movies = [Movie]();
        switch sender.selectedSegmentIndex {
        case 0:
            selectedSortType = "popularity";
            print(0);
        case 1:
            selectedSortType = "vote_average";
            print(1);
        default:
            print()
        }
        getMovies();
    }
    
    @IBAction func sortOrderSelected(_ sender: UISegmentedControl) {
        movies = [Movie]();
        switch sender.selectedSegmentIndex {
        case 0:
            selectedSortOrder = "asc"
            print(0);
        case 1:
            selectedSortOrder = "desc"
            print(1);
        default:
            print()
        }
        getMovies();
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true);
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            movies = [Movie]();
            getSearchedMovies(query: searchBar.text!);
            hideFilters(hide: true)
        }
        else if searchText.count == 0{
            movies = [Movie]();
            getMovies();
            hideFilters(hide: false)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false;
        searchBar.text = "";
        searchBar.endEditing(true);
        hideFilters(hide: false)
        movies = [Movie]();
        getMovies();
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideFilters(hide: true)
        self.view.endEditing(true);
        movies = [Movie]();
        getSearchedMovies(query: searchBar.text!);
    }
    
    func hideFilters(hide:Bool){
        sortTypeSegmentControl.isHidden = hide;
        sortOrderSegmentControl.isHidden = hide;
    }
    
    
    public func getMovies(){
        loader.startAnimating();
        var params:Parameters = Parameters();
        params["page"] = page!;
        params["sort_by"] = "\(selectedSortType!).\(selectedSortOrder!)";
        func getListSuccess(response:[Movie]){
            loader.stopAnimating();
            movies.append(contentsOf: response);
            moviesCollectionView.reloadData();
        }
        func getListFailure(response:APIResponse){
            loader.stopAnimating();
        }
        MovieBL().getMovieList(route: APIConstants.MOVIE_LIST_API, params: params, success_callback: getListSuccess, failure_callback: getListFailure)
    }
    
    public func getSearchedMovies(query:String){
        loader.startAnimating();
        var params:Parameters = Parameters();
        params["query"] = query.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil);
        func getListSuccess(response:[Movie]){
            movies.append(contentsOf: response);
            moviesCollectionView.reloadData();
            loader.stopAnimating();
        }
        func getListFailure(response:APIResponse){
            loader.stopAnimating();
        }
        MovieBL().getMovieList(route: APIConstants.MOVIE_SEARCH_API, params: params, success_callback: getListSuccess, failure_callback: getListFailure)
    }
    
}

