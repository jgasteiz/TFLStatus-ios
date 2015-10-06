import Foundation

class FetchStatusTask {
    
    init() {
    }
    
    ////////////////////////////
    // Fetch station status
    ////////////////////////////
    
    func getFetchStationArrivalsURL(stationId: String) -> NSURL {
        return NSURL(string: "https://api.tfl.gov.uk/StopPoint/\(stationId)/arrivals")!
    }
    
    // Get arrivals for a given station
    func getStationArrivals(stationId: String, onTaskDone: ([Status]) -> Void, onTaskError: () -> Void) {
        let fetchStatusURL = self.getFetchStationArrivalsURL(stationId)
        self.fetchStationArrivals(fetchStatusURL, onTaskDone: onTaskDone, onTaskError: onTaskError)
    }
    
    // Fetch a single story
    func fetchStationArrivals(fetchStatusURL: NSURL, onTaskDone: (status: [Status]) -> Void, onTaskError: () -> Void) -> Void {
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(fetchStatusURL, completionHandler: { (location: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if error == nil {
                // Get the url content as NSData
                let dataObject = NSData(contentsOfURL: location!)
                
                let arrivalsArray: NSArray = (try! NSJSONSerialization.JSONObjectWithData(dataObject!, options: [])) as! NSArray
                
                var arrivals: [Status] = []
                
                for arrivalDict in arrivalsArray {
                    arrivals.append(Status(
                        stationName: arrivalDict["stationName"] as! String,
                        lineName: arrivalDict["lineName"] as! String,
                        platformName: arrivalDict["platformName"] as! String,
                        timeToStation: arrivalDict["timeToStation"] as! Int,
                        direction: arrivalDict["direction"] as! String,
                        currentLocation: arrivalDict["currentLocation"] as! String,
                        towards: arrivalDict["towards"] as! String
                    ))
                }
                
                // Send the list back.
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onTaskDone(status: arrivals)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onTaskError()
                })
            }
        })
        downloadTask.resume()
    }
    
}