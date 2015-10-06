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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initialize spinner
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0, 16, 16))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        self.fetchArrivals()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refetchArrivals(sender: AnyObject) {
        self.fetchArrivals()
    }

    func fetchArrivals() -> Void {
        activityIndicator.startAnimating()
        let fetchStatusTask = FetchStatusTask()
        fetchStatusTask.getStationArrivals("940GZZLUHCL", onTaskDone: onStatusLoadSuccess, onTaskError: onStatusLoadError) // hardcode station id for now
    }
    
    func onStatusLoadSuccess(var arrivals: [Status]) -> Void {
        activityIndicator.stopAnimating()
        
        // TODO: the following lines are obviously temporary.
        // Helper methods will be added to the Status class
        // as well as a list of arrivals. Status will represent
        // the status of a station rather than each of the
        // expected arrivals, as it is now.
        
        textView.text = "Hendon Central Station\n\n"
        
        // Reorder the arrivals by time to station.
        arrivals = arrivals.sort({$0.timeToStation < $1.timeToStation})
        
        // Render inbound
        for arrival in arrivals {
            if arrival.direction == "inbound" {
                textView.text = "\(textView.text)\(arrival.getSummary())\n"
            }
        }
        
        textView.text = "\(textView.text)\n=========\n\n"
        
        // Render outbound
        for arrival in arrivals {
            if arrival.direction == "outbound" {
                textView.text = "\(textView.text)\(arrival.getSummary())\n"
            }
        }
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

