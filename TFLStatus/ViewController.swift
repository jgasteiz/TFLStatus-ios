//
//  ViewController.swift
//  TFLStatus
//
//  Created by Javi Manzano on 06/10/2015.
//  Copyright © 2015 Javi Manzano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var stationName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initialize spinner
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 16, 16))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        self.fetchArrivals()
    }

    @IBAction func refetchArrivals(sender: AnyObject) {
        self.fetchArrivals()
    }

    func fetchArrivals() -> Void {
        activityIndicator.startAnimating()
        let fetchStatusTask = FetchStatusTask()
        
        var stationId: String? = NSUserDefaults.standardUserDefaults().stringForKey("station_id")
        if stationId == nil {
            stationId = "940GZZLUHCL"
        }
        
        fetchStatusTask.getStationArrivals(stationId!, onTaskDone: onStatusLoadSuccess, onTaskError: onStatusLoadError) // hardcode station id for now
    }
    
    func onStatusLoadSuccess(status: Status) -> Void {
        activityIndicator.stopAnimating()
        
        self.stationName.text = "\(status.stationName)\n\n"
        
        self.textView.text = status.getSummary()
    }
    
    func onStatusLoadError() -> Void {
        activityIndicator.stopAnimating()
        
        // Show error message
        let alertController = UIAlertController(title: "Ooops", message:
            "There was an error fetching the top stories. Please, try again later.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

