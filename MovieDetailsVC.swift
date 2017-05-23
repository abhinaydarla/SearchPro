//
//  MovieDetailsVC.swift
//  SearchPro
//
//  Created by Abhi on 5/15/17.
//  Copyright © 2017 Abhi. All rights reserved.
//

import UIKit

class MovieDetailsVC: UIViewController {

    var model_obg = MovieModel()
  
    @IBOutlet var txtoverView: UITextView!
    @IBOutlet var release_date: UILabel!
    
    @IBOutlet var vote_average: UILabel!
    @IBOutlet var popularity: UILabel!
    @IBOutlet var original_title: UILabel!
    @IBOutlet var txt_title: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie Details"
        txt_title.text = model_obg.title
        txtoverView.text = model_obg.overview
        original_title.text = model_obg.original_title
        popularity.text = String(model_obg.popularity)
        release_date.text = model_obg.release_date
        vote_average.text = String(model_obg.vote_average)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
