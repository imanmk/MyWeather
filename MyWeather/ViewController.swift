//
//  ViewController.swift
//  MyWeather
//
//  Created by Iman Mk R on 1/14/15.
//  Copyright (c) 2015 Iman Mk. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    @IBAction func refresh() {
        
        getCurrentweatherData()
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
            }
    
    
    private let apiKey = "4e10b0cc8253acae716302520125325b"
    var locationManager = CLLocationManager()
    var reverseGeocode = CLGeocoder()
    var latitude : Double!
    var longitude :Double!
    var locationReceived : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshButton.hidden = false
        refreshActivityIndicator.hidden = true
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
       

    }
     func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locationCoordinate : CLLocationCoordinate2D = manager.location.coordinate
        latitude = locationCoordinate.latitude
        longitude = locationCoordinate.longitude
        locationManager.stopUpdatingLocation()
        getCurrentweatherData()
        locationReceived = true
       
    }
    //*************
    // TODO: Update current location based on Geocode
    //*************
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationReceived = false
        
    }
    
    func stopRefreshAnimation() -> Void {
        self.refreshActivityIndicator.stopAnimating()
        self.refreshActivityIndicator.hidden = true
        self.refreshButton.hidden = false

    }
    
    func getCurrentweatherData() -> Void {
        if locationReceived == true {
            println(latitude)
            println(longitude)
        
            let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
            let forecastURL = NSURL(string: "\(latitude),\(longitude)", relativeToURL: baseURL)
            let sharedSession = NSURLSession.sharedSession()
            let downloadTask : NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL!, response:         NSURLResponse!, error: NSError!) -> Void in
                if error == nil {
                    let dataObject = NSData(contentsOfURL: location)
                    let weatherDictData : NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                    let currentWeather = CurrentTempInfo(weatherDictionary: weatherDictData)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.iconImage.image = currentWeather.icon!
                        self.timeLabel.text = "At \(currentWeather.currentTime!) it is"
                        self.temperatureLabel.text = "\(currentWeather.temperature)"
                        self.humidityLabel.text = "\(currentWeather.humidity)"
                        self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                        self.summaryLabel.text = currentWeather.summary
                  
                        self.stopRefreshAnimation()
                    
                    })
                } else {
                        let networkErrorController = UIAlertController(title: "Oops!", message: "Unable to retrieve data. Connection error!", preferredStyle: .Alert)
                        let tryAgainButton = UIAlertAction(title: "Try Again", style: .Default, handler: { void in
                        self.refresh()
                    })
                    networkErrorController.addAction(tryAgainButton)
                    let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                    networkErrorController.addAction(cancelButton)
                    self.presentViewController(networkErrorController, animated: true, completion: nil)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.stopRefreshAnimation()
                    })
                }
            })
                downloadTask.resume()

            } else {
                let locationError = UIAlertController(title: "Oops!", message: "Cannot retreive current location", preferredStyle: .Alert)
                let tryAgainButton = UIAlertAction(title: "Try Again", style: .Default, handler: { void in
                    self.refresh()
                })
                locationError.addAction(tryAgainButton)
                let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                locationError.addAction(cancelButton)
                self.presentViewController(locationError, animated: true, completion: nil)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.stopRefreshAnimation()
                })
            }
        

        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

