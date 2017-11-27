//
//  Meal.swift
//  FoodTracker
//
//  Created by Paul on 2017-10-08.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import os.log

class Meal {
    
    //MARK: Properties
    var name: String?
//    var photo: UIImage?
    var photoURL: URL?
//    var rating: Int
    var photo:UIImage?
    var info: Dictionary<String,Any>?
    var mealDescription: String?
    var calories: Int?
    var mealID: Int?
    
    //MARK: initialize with json data
    
    init(info: Dictionary<String, Any>) {

        self.info = info

        if let name = info["title"] as? String {
            self.name = name
        }

        if let photoURL = info["imagePath"] as? String{

            self.photoURL = URL(string: photoURL)
        }

        if let description = info["description"] as? String {
            self.mealDescription = description
        }

        if let calories = info["calories"] as? Int {
            self.calories = calories
        }
        
        if let mealID = info["id"] as? Int {
            self.mealID = mealID
        }

    }
    
}
    
//    init(info: Dictionary<String, Any>){
//        self.name = info["title"] as! String
//        if let imagePath = info["imagePath"] as? String {
//            self.photoURL = URL(string: imagePath)
//        }
//        self.mealDescription = info["description"] as! String
//        self.calories = info["calories"] as! Int
//    }


