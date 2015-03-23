//
//  imageSearchViewController.swift
//  imageSearch
//
//  Created by Sergey Alexeev on 18/03/15.
//  Copyright (c) 2015 test. All rights reserved.
//

import UIKit

protocol imageSearchDataSource: class {
    func imageForQuery(query: String, handler:operationDownloadImageHandler?) -> Void
}

class imageSearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var queryTextField: UITextField!
    @IBOutlet weak var resultImageView: UIImageView!
    let dataSourceProvider = imageSourceProvider()
    weak var dataSource: imageSearchDataSource!
    let indicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = dataSourceProvider.imageDataSource;
        resultImageView.contentMode = .ScaleAspectFit
        queryTextField.delegate = self
        queryTextField.becomeFirstResponder()
        
        indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        indicator.center = self.resultImageView.center;
        indicator.hidden = true
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {   //delegate method
        textField.resignFirstResponder()
        showImage()
        return true
    }
    
    func showImage() {
        resultImageView.hidden = true
        resultImageView.image = nil;
        if dataSource != nil {
            indicator.hidden = false
            indicator.startAnimating()
            let handler:operationDownloadImageHandler = { (image: UIImage?, error:NSError?) -> Void in
                if image == nil {
                    self.resultImageView.image = UIImage(named: "error")
                } else {
                    self.resultImageView.image = image
                }
                self.indicator.stopAnimating()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.resultImageView.hidden = false
            }
            
            dataSource.imageForQuery(queryTextField.text, handler)
        }
    }
}
