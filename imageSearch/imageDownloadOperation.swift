//
//  imageDownloadOperation.swift
//  exapmpleApp
//
//  Created by Sergey Alexeev on 01/12/14.
//  Copyright (c) 2014 testuser. All rights reserved.
//

import UIKit

typealias operationDownloadImageHandler = (image: UIImage?, error:NSError?) -> Void

class ImageDownloadOperation: NSObject {
    
    var handler:operationDownloadImageHandler?
    var request:NSURLRequest
    
    init(request:NSURLRequest, handler:operationDownloadImageHandler) {
        self.request = request
        self.handler = handler
    }
    
    func perform () {
        NSURLConnection.sendAsynchronousRequest(request,
            queue: NSOperationQueue.mainQueue(),
            completionHandler:{response, data, error in
                if (self.handler != nil) {
                    let image = data != nil ? UIImage(data: data) : nil
                    self.handler!(image: image, error: error)
                }
        })
    }
}
