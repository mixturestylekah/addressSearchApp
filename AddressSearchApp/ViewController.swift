//
//  ViewController.swift
//  AddressSearchApp
//
//  Created by kentaro on 2016/06/18.
//  Copyright © 2016年 kentaro aoki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var prefLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapReturn() {
    }
    @IBAction func tapSearch() {
        guard let ziptext = zipTextField.text else {
            return
        }
        
        let urlStr = "http://api.zipaddress.net/?zipcode=\(ziptext)"
        
        if let url = NSURL(string: urlStr) {
           let urlSession = NSURLSession.sharedSession()
           let task = urlSession.dataTaskWithURL(url, completionHandler: onGetAddress)
            task.resume()
        }
    }
    
    func onGetAddress(data: NSData?, res: NSURLResponse?, error: NSError?) {
        do {
            let jsonDic = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
            if let code = jsonDic["code"] as? Int {
                if code != 200{
                    if let errmsg = jsonDic["message"] as? String {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.prefLabel.text = errmsg
                        }
                    }
                }
            }
            if let data = jsonDic["data"] as? NSDictionary {
                if let pref = data["pref"] as? String {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.prefLabel.text = pref
                    }
                }
                if let address = data["address"] as? String {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.addressLabel.text = address
                    }
                }
            }
        } catch {
            dispatch_async(dispatch_get_main_queue()) {
                self.addressLabel.text = "エラーです"
            }
        }
    }
}