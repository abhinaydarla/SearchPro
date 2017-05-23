//
//  ViewController.swift
//  SearchPro
//
//  Created by Abhi on 5/15/17.
//  Copyright © 2017 Abhi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var txtVIEWSearch: UITextField!
    @IBOutlet var movieTable: UITableView!
    var total_page = 0
    var page = 0
    let movieArray : NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie Search"
        movieTable.delegate = self
       
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTVCell") as! MovieTVCell
    
        let model = self.movieArray[indexPath.row] as! MovieModel
        cell.title.text = model.title
        return cell
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nav = storyboard?.instantiateViewController(withIdentifier: "MovieDetailsVC") as! MovieDetailsVC
        let model = self.movieArray[indexPath.row] as! MovieModel
        nav.model_obg = model
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == self.movieArray.count - 1){
            if(page < total_page) {
                self.apiCall()
            }
        }
    }
   
    @IBAction func btn_submit(_ sender: UIButton) {
       
        txtVIEWSearch.resignFirstResponder()
        if(txtVIEWSearch.text == ""){
            let alert = UIAlertController(title: "Alert", message: "Must be fill..!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
        movieArray.removeAllObjects()
        let param = ["api_key" : "8cd0ee3043eb3a403c9bb01ed3f494ad",
                     "language" : "en-US",
                     "page":"1",
                     "include_adult" : "false",
                     "query" : txtVIEWSearch.text
                ] as [String : Any]
        let isNetworkAvailables = APIClient.isNetworkAvailable()
        
        if isNetworkAvailables {
            APIClient.sharedInstance.showProgress(inView: self.view)
            APIClient.sharedInstance.MakeAPICallWithEndURl(BASE_URL.appending(kMakeFilter) as NSString, parameters: param as NSDictionary!) { (response, error) in
                print(response)
                APIClient.sharedInstance.hideProgress()
                if (error == nil) {
                    let resutls = response! as NSDictionary
                    self.page = resutls.value(forKey: "page") as! Int
                    self.total_page = resutls.value(forKey: "total_pages") as! Int
                    let total_results = resutls.value(forKey: "total_results")
                    let result = resutls.value(forKey: "results") as! NSArray
                    for res in result{
                        let modelClass : MovieModel = MovieModel()
                        let subMovie = res as! NSDictionary
                        let adult = subMovie.value(forKey: "adult") as! Bool
                        let genre_ids = subMovie.value(forKey: "genre_ids") as! NSArray
                        let id = subMovie.value(forKey: "id") as! Int
                        let original_language = subMovie.value(forKey: "original_language") as! String
                        let original_title = subMovie.value(forKey: "original_title") as! String
                        let overview = subMovie.value(forKey: "overview") as! String
                        let popularity = subMovie.value(forKey: "popularity") as! Double
                       
                        var poster_path = ""
                        if (subMovie.value(forKey: "poster_path") as? String) != nil {
                               poster_path = subMovie.value(forKey: "poster_path") as! String
                        }
                        let release_date = subMovie.value(forKey: "release_date") as! String
                        let video = subMovie.value(forKey: "video") as! Bool
                        let title = subMovie.value(forKey: "title") as! String
                        let vote_average = subMovie.value(forKey: "vote_average") as! Double
                        let vote_count = subMovie.value(forKey: "vote_count") as! Int
                        
                        modelClass.adult = adult
                        modelClass.genre_ids  =  genre_ids
                        modelClass.id = id
                        modelClass.original_language = original_language
                        modelClass.original_title = original_title
                        modelClass.overview  =  overview
                        modelClass.popularity = popularity
                        modelClass.poster_path = poster_path
                        modelClass.video = video
                        modelClass.title  =  title
                        modelClass.vote_average = vote_average
                        modelClass.vote_count = vote_count
                        modelClass.release_date = release_date
                        
                        self.movieArray.add(modelClass)
                    }
                    self.movieTable.reloadData()
                }
                else{
                    print(error)
                    let alert = UIAlertController(title: "Error", message: error?.description, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
              }
            }
        }
    }

    func apiCall()
    {
        var page_number = 0
        
        if(page <= total_page){
        page_number = total_page
        let param = ["api_key" : "8cd0ee3043eb3a403c9bb01ed3f494ad",
                     "language" : "en-US",
                     "page":page_number,
                     "include_adult" : "false",
                     "query" : txtVIEWSearch.text
            ] as [String : Any]
        let isNetworkAvailables = APIClient.isNetworkAvailable()
        if isNetworkAvailables {
            APIClient.sharedInstance.showProgress(inView: self.view)
            APIClient.sharedInstance.MakeAPICallWithEndURl(BASE_URL.appending(kMakeFilter) as NSString, parameters: param as NSDictionary!) { (response, error) in
                
                APIClient.sharedInstance.hideProgress()
                if (error == nil) {
                    let resutls = response! as NSDictionary
                    self.page = resutls.value(forKey: "page") as! Int
                    self.total_page = resutls.value(forKey: "total_pages") as! Int
                    let total_results = resutls.value(forKey: "total_results")
                    let result = resutls.value(forKey: "results") as! NSArray
                    
                    for res in result{
                        let modelClass : MovieModel = MovieModel()
                        
                        let subMovie = res as! NSDictionary
                        let adult = subMovie.value(forKey: "adult") as! Bool
                        let genre_ids = subMovie.value(forKey: "genre_ids") as! NSArray
                        let id = subMovie.value(forKey: "id") as! Int
                        let original_language = subMovie.value(forKey: "original_language") as! String
                        let original_title = subMovie.value(forKey: "original_title") as! String
                        let overview = subMovie.value(forKey: "overview") as! String
                        let popularity = subMovie.value(forKey: "popularity") as! Double
                        
                        var poster_path = ""
                        if (subMovie.value(forKey: "poster_path") as? String) != nil {
                            poster_path = subMovie.value(forKey: "poster_path") as! String
                        }
                        let video = subMovie.value(forKey: "video") as! Bool
                        let title = subMovie.value(forKey: "title") as! String
                        let vote_average = subMovie.value(forKey: "vote_average") as! Double
                        let vote_count = subMovie.value(forKey: "vote_count") as! Int
                        
                        modelClass.adult = adult
                        modelClass.genre_ids  =  genre_ids
                        modelClass.id = id
                        modelClass.original_language = original_language
                        modelClass.original_title = original_title
                        modelClass.overview  =  overview
                        modelClass.popularity = popularity
                        modelClass.poster_path = poster_path
                        modelClass.video = video
                        modelClass.title  =  title
                        modelClass.vote_average = vote_average
                        modelClass.vote_count = vote_count
                        
                        self.movieArray.add(modelClass)
                        
                    }
                    self.movieTable.reloadData()
                }else
                {
                    let alert = UIAlertController(title: "Error", message: error?.description, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
      }
    }
}

