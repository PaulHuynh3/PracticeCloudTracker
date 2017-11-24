//
//  NetworkManager.swift
//  FoodTracker
//
//  Created by Paul on 2017-11-23.
//  Copyright © 2017 Jaison Bhatti. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    class func createMeal(title:String,description:String,calories:Int, completionHandler: @escaping (Meal) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let spacelessTitle = title.replacingOccurrences(of:" ", with: "%20")
        let spaceslessDescription = description.replacingOccurrences(of:" ", with:"%20")
        guard let components = URLComponents(string: "https://cloud-tracker.herokuapp.com/users/me/meals?title=\(spacelessTitle)&description=\(spaceslessDescription)&calories=\(calories)") else {
            print("Something went wrong with url session")
            return
        }
        
        var request = URLRequest(url: components.url!)
        
        request.httpMethod = "POST"
        request.addValue("m7Ba2XzfmjabdcBCPxq9sQvo", forHTTPHeaderField: "token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let task = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
         
            if let error = error {
                print(#line,error.localizedDescription)
                return
            }
      
            guard(response as! HTTPURLResponse).statusCode < 300 else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do{
            
                guard let result = try JSONSerialization.jsonObject(with: data) as? Dictionary<String,Dictionary<String,Any>> else{
                 return
                }
             //create meal
             let createMeal = Meal(info: result["meal"]!)
                
            //save it to completion handler.
            completionHandler(createMeal)
                
            }
            catch{
                print(#line,error.localizedDescription)
            }
                
        }
        task.resume()
        
    }
    
    class func postPhotoToImgur(image: UIImage, completionHandler: @escaping (URL) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        
        guard let url = URL(string: "https://api.imgur.com/3/image") else {
            return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.addValue("Client-ID 887c27b7d390539", forHTTPHeaderField: "Authorization")
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        //start a new task... Uploading the image to imgur... pictures uploading and downloading typically use Data
        guard let uploadImage = imageData else{
            return
        }
        
        let task = session.uploadTask(with: request, from: uploadImage) { (data:Data?, response:URLResponse?, error:Error?) in
            
            if let error = error {
                print(#line, error.localizedDescription)
                return
            }
            
            
            guard (response as! HTTPURLResponse).statusCode >= 300 else {
                print("Error with response %@",response)
                return
            }
            
            guard let data = data else {
                print(#line,"no data")
                return
            }
            //dictionary<string, any> to access the data first.
            guard let dict = try! JSONSerialization.jsonObject(with: data) as? Dictionary<String,Any> else {
                return
            }
            

            
           guard
            let dataDict = dict["data"] as? Dictionary<String,Any>,
            //access the "link" string in data
            let linkString = dataDict["link"] as? String,
            let link = URL(string:linkString)
            else{
                print(#line, "no link from response")
                return
            }
            completionHandler(link)
 
            
        }
        task.resume()
    }
    

}
