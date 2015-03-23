//
//  getImageUrlOperation.swift
//  imageSearch
//
//  Created by Sergey Alexeev on 23/03/15.
//  Copyright (c) 2015 test. All rights reserved.
//

import UIKit

typealias operationGetUrlHandler = (url: NSURL?, error:NSError?) -> Void

class getImageUrlOperation: NSOperation {
    
    var handler:operationGetUrlHandler?
    var request:NSURLRequest?
    var searchUrl:NSURL?
    
    init(query:String?, token:String?, handler:operationGetUrlHandler?) {
        if query != nil && token != nil {
            let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=" + token! + "&text=" + query! + "&per_page=1&page=1&format=json&nojsoncallback=1"
            var escapedString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            if escapedString != nil {
                self.searchUrl = NSURL(string: escapedString!)
            }
        }
        self.request = self.searchUrl != nil ? NSURLRequest(URL: searchUrl!) : nil;
        self.handler = handler
    }
    
    func perform () {
        if request != nil {
            NSURLConnection.sendAsynchronousRequest(request!,
                queue: NSOperationQueue.mainQueue(),
                completionHandler:{response, data, error in
                    if data != nil {
                        var err: NSError?
                        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                        let json = JSON(object: jsonResult)
                        let farmId: String? = json["photos"]["photo"][0]["farm"].stringValue?
                        let serverId: String? = json["photos"]["photo"][0]["server"].stringValue?
                        let photoId: String? = json["photos"]["photo"][0]["id"].stringValue?
                        let secret: String? = json["photos"]["photo"][0]["secret"].stringValue?
                        var imageUrl: NSURL? = nil
                        if farmId != nil && serverId != nil && photoId != nil && secret != nil {
                            let imageUrlString = "https://farm" + farmId! + ".staticflickr.com/" + serverId! + "/" + photoId! + "_" + secret! + ".jpg"
                            imageUrl = NSURL(string: imageUrlString)
                        }
                        if (self.handler != nil) {
                            self.handler!(url: imageUrl, error: error)
                        }
                    } else {
                        self.handler!(url: nil, error: error)
                    }
            })
        }
    }

   
}
