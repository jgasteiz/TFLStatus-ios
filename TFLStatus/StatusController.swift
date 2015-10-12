//
//  ViewController.swift
//  TFLStatus
//
//  Created by Javi Manzano on 06/10/2015.
//  Copyright © 2015 Javi Manzano. All rights reserved.
//

import UIKit
import CoreData

class StatusController: UITableViewController {
    
    private let reuseIdentifier = "StatusCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var statuses = [Status]()

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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses[section].arrivals.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Get the table cell
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)  as! StatusCell
        
        let status = statuses[indexPath.section]
        cell.status.text = status.getArrivals()[indexPath.row].getSummary()

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let status = statuses[section]
        return status.stationName
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return statuses.count
    }
    
    @IBAction func refetchArrivals(sender: AnyObject) {
        self.fetchArrivals()
    }
    
    @IBAction func deleteFavorites(sender: AnyObject) {
        // Delete existing entities
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "FavoriteStation")
        do {
            let fetchResults = try moc.executeFetchRequest(fetchRequest) as! [FavoriteStation]
            for entity in fetchResults {
                moc.deleteObject(entity)
            }
        } catch {
            print("Couldn't delete")
        }
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }

        statuses = [Status]()
        self.tableView.reloadData()
    }

    // Fetch arrivals for all the favourite stops.
    func fetchArrivals() -> Void {
        activityIndicator.startAnimating()
        statuses = [Status]()
        
        let fetchStatusTask = FetchStatusTask()

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let moc = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "FavoriteStation")
        
        do {
            let fetchResults = try moc.executeFetchRequest(fetchRequest) as! [FavoriteStation]
            
            if fetchResults.count > 0 {
                for entity in fetchResults {
                    fetchStatusTask.getStationArrivals(entity.id, stationName: entity.name, onTaskDone: onStatusLoadSuccess, onTaskError: onStatusLoadError)
                }
            } else {
                activityIndicator.stopAnimating()
            }
        } catch {
            print("Something happened")
        }
    }
    
    func onStatusLoadSuccess(status: Status) -> Void {
        activityIndicator.stopAnimating()
        
        if status.arrivals.count > 0 {
            self.statuses.append(status)
            self.tableView.reloadData()
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

