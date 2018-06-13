//
//  ImageMethods.swift
//  Fonzy
//
//  Created by Jhonny Bill Mena on 3/15/18.
//  Copyright © 2018 Biocore. All rights reserved.
//

import Foundation

class ImageMethods {
    
    
    static func saveHairdresser(image: UIImage, withToken userToken: String, completion: (() -> ())?) {
        
        let link = Config.fonzyUrl + "users/hairdressers/pictures"
        let url = URLComponents(string: link)!
        
        guard let encodedImage = UIImageJPEGRepresentation(image, 1)?.base64EncodedString() else {return}
        
        let parameters = ["picture": encodedImage]
        guard let body = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "POST"
        request.addValue(userToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            print("saveHairdresser response: ", response)
            print("saveHairdresser data: ", data)
            
            guard let data = data else {return}
            
            do {
                
                completion?()
                let image = try JSONDecoder().decode(Image.self, from: data)
                print("Image saved with ID: ", image.id)
                
            } catch let err {
                print("Error while parsing image data: ", err)
            }
            
        }.resume()
        
    }
    
    static func saveHairdresser2(image: UIImage, withToken userToken: String, completion: (() -> ())?) {
        let link = Config.fonzyUrl + "users/hairdressers/pictures"
        let url = URLComponents(string: link)!
        
        guard let encodedImage = UIImageJPEGRepresentation(image, 1)?.base64EncodedString() else {return}
        
        let parameters = ["picture": encodedImage]
        guard let body = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "POST"
        request.addValue(userToken, forHTTPHeaderField: "Authorization")
        request.httpBody = self.createRequestBodyWith(parameters: parameters as [String : NSObject], image: image, imageNamePath: "userImage", boundary: self.generateBoundaryString()) as Data//createRequestBodyWith(parameters, image, "picture", self.generateBoundaryString())
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            print("saveHairdresser response: ", response)
            print("saveHairdresser data: ", data)
            
            guard let data = data else {return}
            
            do {
                
                completion?()
                let image = try JSONDecoder().decode(Image.self, from: data)
                print("Image saved with ID: ", image.id)
                
            } catch let err {
                print("Error while parsing image data: ", err)
            }
            
            }.resume()
        
    }
    
    
    
    static func saveUserProfilePicture(image: UIImage, withToken userToken: String, completion: (() -> ())?) {
        
        let link = Config.fonzyUrl + "users/images"
        let url = URLComponents(string: link)!
        
        guard let encodedImage = UIImageJPEGRepresentation(image, 1)?.base64EncodedString() else {return}
        
        let parameters = ["picture": encodedImage]
        guard let body = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "POST"
        request.addValue(userToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            print("saveHairdresser response: ", response)
            print("saveHairdresser data: ", data)
            
            guard let data = data else {return}
            
            do {
                
                completion?()
                let user = try JSONDecoder().decode(UserAuth.self, from: data)
                print("User profile picture saved with ID: ", user.id)
                
            } catch let err {
                print("Error while parsing image data: ", err)
            }
            
            }.resume()
        
    }
    
    static private func createRequestBodyWith(parameters:[String:NSObject], image: UIImage, imageNamePath:String, boundary:String) -> NSData{
        
        let body = NSMutableData()
        
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        body.appendString(string: "--\(boundary)\r\n")
        
        let mimetype = "image/jpg"
        
        let defFileName = "yourImageName.jpg"
        
        let imageData = UIImageJPEGRepresentation(image, 1)
        
        body.appendString(string: "Content-Disposition: form-data; name=\"\(imageNamePath)\"; filename=\"\(defFileName)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageData!)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }

    
    static private func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
}



extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}




class BookmarkMethods {
    
    
    /*
     Function to get all the bookmark from an user.
     */
    static func getAllBookmarksFrom(user authKey: String, completion: (([JSONBookmark]) -> ())?){
        
        let link = Config.fonzyUrl + "users/bookmark"
        let url = URLComponents(string: link)!
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "GET"
        request.addValue(authKey, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            print("Repsonse from GET/Bookmarks: ", response)
            print("Data from GET/Bookmarks: ", data)
            
            guard let data = data else {return}
            do {
                
                let bookmarks = try JSONDecoder().decode([JSONBookmark].self, from: data)
                print("Sucessfully inserted bookmarks: ", bookmarks.count)
                completion?(bookmarks)
                
            } catch let err {
                print("Error while parsing bookmarks: ", err)
            }
            
        }.resume()
    }
    
    
    
    /*
     Function to get all the bookmark from an user.
     */
    static func removeBookmark(withId id: Int, authToken: String, completion: (() -> ())? ) {
        // /users/bookmark?id_bookmark=6
        let link = Config.fonzyUrl + "users/bookmark"
        var url = URLComponents(string: link)!
        url.queryItems =
        [
            URLQueryItem(name: "id_bookmark", value: "\(id)")
        ]
        
        var request = URLRequest(url: url.url!)
        request.httpMethod = "DELETE"
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            print("Repsonse from GET/Bookmarks: ", response)
            print("Data from GET/Bookmarks: ", data)
            
            guard let data = data else {return}
            
            print("Successfully deleted bookmark withID: ", id)
            completion?()
            
        }.resume()
        
    }
    
}




