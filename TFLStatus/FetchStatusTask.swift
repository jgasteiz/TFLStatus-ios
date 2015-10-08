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
    func getStationArrivals(stationId: String, onTaskDone: (Status) -> Void, onTaskError: () -> Void) {
        let fetchStatusURL = self.getFetchStationArrivalsURL(stationId)
        self.fetchStationArrivals(fetchStatusURL, onTaskDone: onTaskDone, onTaskError: onTaskError)
    }
    
    // Fetch a single story
    func fetchStationArrivals(fetchStatusURL: NSURL, onTaskDone: (status: Status) -> Void, onTaskError: () -> Void) -> Void {
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(fetchStatusURL, completionHandler: { (location: NSURL?, response: NSURLResponse?, error: NSError?) -> Void in
            
            if error == nil {
                // Get the url content as NSData
                let dataObject = NSData(contentsOfURL: location!)
                
                let arrivalsArray: NSArray = (try! NSJSONSerialization.JSONObjectWithData(dataObject!, options: [])) as! NSArray
                
                var arrivals: [Arrival] = []
                for arrivalDict in arrivalsArray {
                    arrivals.append(Arrival(
                        platformName: arrivalDict["platformName"] as! String,
                        timeToStation: arrivalDict["timeToStation"] as! Int,
                        direction: arrivalDict["direction"] as! String,
                        currentLocation: arrivalDict["currentLocation"] as! String,
                        towards: arrivalDict["towards"] as! String
                    ))
                }
                
                let status = Status(
                    stationName: arrivalsArray[0]["stationName"] as! String,
                    lineName: arrivalsArray[0]["lineName"] as! String,
                    arrivals: arrivals
                )
                
                // Send the list back.
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onTaskDone(status: status)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    onTaskError()
                })
            }
        })
        downloadTask.resume()
    }
    
    func getStations() -> [Station] {
        var stations: [Station] = []
        if let path = NSBundle.mainBundle().pathForResource("all_stations", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let stationsArray: NSArray = (try! NSJSONSerialization.JSONObjectWithData(jsonData, options: [])) as! NSArray
                for stationDict in stationsArray {
                    stations.append(Station(
                        id: stationDict["id"] as! String,
                        name: stationDict["name"] as! String,
                        lat: stationDict["lat"] as! Double,
                        lon: stationDict["lon"] as! Double
                    ))
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        return stations
    }
    
}