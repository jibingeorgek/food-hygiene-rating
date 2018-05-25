//
//  RaitingDetailsViewController.swift
//  application_MAD
//
//  Created by Jibin George on 12/03/2018.
//  Copyright © 2018 Jibin Kaitholil George. All rights reserved.
//

import UIKit
import MapKit
class RaitingDetailsViewController: UIViewController, MKMapViewDelegate{
    @IBOutlet weak var BusinessName: UILabel!
    @IBOutlet weak var AddressLine1: UILabel!
    @IBOutlet weak var PostCode: UILabel!
    @IBOutlet weak var RatingDate: UILabel!
    @IBOutlet weak var DistanceKM: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var myMapView: MKMapView!
    var therating: raiting!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        BusinessName.text = therating?.BusinessName
        AddressLine1.text = therating?.AddressLine1
        PostCode.text = therating?.PostCode
        RatingDate.text = therating?.RatingDate
        
        if therating?.DistanceKM != nil {
            DistanceKM.text = locationDistance(distanceKM: (therating?.DistanceKM)!)
        } else {
            DistanceKM.text = ""
        }
        
        let rating = therating?.RatingValue
        
        switch(rating){
            
        case "-1"?:
            img.image = UIImage.init(imageLiteralResourceName: "fhis_exempt")
            break
        case "1"?:
            img.image = UIImage.init(imageLiteralResourceName: "fhrs_1_en-gb")
            break
        case "2"?:
            img.image = UIImage.init(imageLiteralResourceName: "fhrs_2_en-gb")
            break
        case "3"?:
            img.image = UIImage.init(imageLiteralResourceName: "fhrs_3_en-gb")
            break
        case "4"?:
            img.image = UIImage.init(imageLiteralResourceName: "fhrs_4_en-gb")
            break
        case "5"?:
            img.image = UIImage.init(imageLiteralResourceName: "fhrs_5_en-gb")
            break
        default:
            img.image = UIImage.init(imageLiteralResourceName: "fhrs_0_en-gb")
            break
        }
        
        

        
        myMapView.delegate = self
        let latitude = (therating?.Latitude as! NSString).doubleValue
        let longitude = (therating?.Longitude as! NSString).doubleValue
        let span :MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region : MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        
        let annotation = CustomAnnotation()
        annotation.title = "Your location"
        annotation.image = getRatingImage(ratingValue: (therating?.RatingValue)!)
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        myMapView.addAnnotation(annotation)
        
        myMapView.setRegion(region, animated: true)
        
    }
    
    func getRatingImage(ratingValue: String) -> UIImage {
        var img: UIImage
        
        switch(ratingValue){
            
        case "-1":
            img = UIImage.init(imageLiteralResourceName: "na")
            break
        case "1":
            img = UIImage.init(imageLiteralResourceName: "1")
            break
        case "2":
            img = UIImage.init(imageLiteralResourceName: "2")
            break
        case "3":
            img = UIImage.init(imageLiteralResourceName: "3")
            break
        case "4":
            img = UIImage.init(imageLiteralResourceName: "4")
            break
        case "5":
            img = UIImage.init(imageLiteralResourceName: "5")
            break
        default:
            img = UIImage.init(imageLiteralResourceName: "0")
            break
        }
        
        return img
    }
    
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


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationDistance(distanceKM: String) -> String {
        let convertedDistance = Double(distanceKM)
        var distance = Double(round(1000 * convertedDistance!))
        
        return "\(distance) meters from location"
    }
}
