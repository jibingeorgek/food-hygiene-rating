//
//  ViewController.swift
//  application_MAD
//
//  Created by Jibin George on 12/03/2018
//  Copyright © 2018 Jibin Kaitholil George. All rights reserved.
//

import MapKit
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allrating.count
    }
    
    //raiting and business name
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = allrating[indexPath.row].BusinessName
        return cell
    }
    var allrating = [raiting]()
    let locationManager = CLLocationManager()
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myMapView: MKMapView!
    var Rating = [raiting]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myTableView.dataSource = self
        myTableView.delegate = self
        myMapView.delegate = self
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }}
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        let customAnnotation = annotation as! CustomAnnotation
        annotationView!.image = customAnnotation.image
        
        return annotationView
    }
    
    func locationManager(_ _manager:CLLocationManager,didUpdateLocations locations: [CLLocation]){
        let latitude = locations[0].coordinate.latitude
        let longitude = locations[0].coordinate.longitude
        let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&lat=\(latitude)&long=\(longitude)")
        //configuering URL section
        URLSession.shared.dataTask(with:url!) { (data, response, error) in
            guard let data = data else {print("error with data"); return }
            do{
                self.allrating = try JSONDecoder().decode([raiting].self, from: data);
                //updating the table
                DispatchQueue.main.async {
                    self.myTableView.reloadData();
                    let span:MKCoordinateSpan = MKCoordinateSpanMake(0.004, 0.004)
                    let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                    let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                    self.myMapView.setRegion(region, animated: true)
                        for Rating in self.allrating {
                        //annotation
                        let annotation = CustomAnnotation()
                            annotation.coordinate = CLLocationCoordinate2DMake(Double(Rating.Latitude)!, Double(Rating.Longitude)!)
                        annotation.title = Rating.BusinessName
                        annotation.subtitle = Rating.PostCode
                            annotation.image = UIImage(named: "1")!
                            
                            //all pictures that i created for raiting
                            switch(Rating.RatingValue){
                                
                            case "0":
                                annotation.image = UIImage(named: "0")
                                break
                            case "1":
                                annotation.image = UIImage(named: "1")
                                break
                            case "2":
                                annotation.image = UIImage(named: "2")
                                break
                            case "3":
                                annotation.image = UIImage(named: "3")
                                break
                            case "4":
                                annotation.image = UIImage(named: "4")
                                break
                            case "5":
                                annotation.image = UIImage(named: "5")
                                break
                            default:
                                annotation.image = UIImage(named: "na")
                            }
                        self.myMapView.addAnnotation(annotation)//self map annotation
                    }
                }
                //prinitng the objectives
                print(self.allrating.count)
                print(self.allrating[0].BusinessName)
                
            } catch let err {
                print("Error:", err)
            }
            }.resume()//start the network call
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let cell = sender as? UITableViewCell{
            let i = myTableView.indexPath(for: cell)!.row
            if segue.identifier == "details"{
                //gets all info from RaitingDetailsViewController class
                let dvc = segue.destination as! RaitingDetailsViewController
                dvc.therating = self.allrating[i]
            }
            
        }
    }
}
