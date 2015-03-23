//
//  donwloaderProvider.swift
//  imageSearch
//
//  Created by Sergey Alexeev on 19/03/15.
//  Copyright (c) 2015 test. All rights reserved.
//

import UIKit

/* Extra layer to switch data source  */
class imageSourceProvider: NSObject {
    let imageDataSource: flickrImageDownloader = flickrImageDownloader()
}
