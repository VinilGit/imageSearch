//
//  flickrImageDownloader.swift
//  imageSearch
//
//  Created by Sergey Alexeev on 18/03/15.
//  Copyright (c) 2015 test. All rights reserved.
//

import UIKit

class flickrImageDownloader: NSObject, imageSearchDataSource {
    
    private let kApiToken = "4bb71a0db2b9649a430ed0f50b797da7"
    
    func imageForQuery(query: String, handler:operationDownloadImageHandler?) -> Void {
        let urlGetHandler: operationGetUrlHandler = { (url: NSURL?, error:NSError?) -> Void in
            if (url != nil) {
                let imageRequest: NSURLRequest = NSURLRequest(URL: url!)
                let completion:operationDownloadImageHandler = { (image: UIImage?, error:NSError?) -> Void in
                    if handler != nil {
                        handler!(image: image, error: error)
                    }
                }
                
                let operation = ImageDownloadOperation(request: imageRequest, completion)
                operation.perform()
            } else {
                if handler != nil {
                    handler!(image: nil, error: error)
                }
            }
        }
        
        self.getPhotoUrl(query, handler: urlGetHandler)
    }
    
    private func getPhotoUrl(query: String, handler:operationGetUrlHandler?) {
        let operation = getImageUrlOperation(query: query, token: kApiToken, handler: handler)
        operation.perform()
    }
}
