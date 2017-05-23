//
//  MovieModel.swift
//  SearchPro
//
//  Created by Abhi on 5/15/17.
//  Copyright © 2017 Abhi. All rights reserved.
//

import UIKit

class MovieModel: NSObject {
    
    var adult : Bool = Bool()
    var backdrop_path : NSString = ""
    var genre_ids : NSArray = NSArray()
    var id : Int = Int()
    var original_language  : String = String()
    var original_title  : String = String()
    var overview  : String = String()
    var popularity : Double = Double()
    var poster_path : String = String()
    var release_date  : String = String()
    var title  : String = String()
    var video :  Bool = Bool()
    var vote_average : Double = Double()
    var vote_count : Int = Int()
}
