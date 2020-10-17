//
//  TravelViewController.swift
//  TuristV
//
//  Created by Pablo Perez Zeballos on 10/16/20.
//

import UIKit
import MapKit

class TravelViewController: UIViewController, MKMapViewDelegate {

  @IBOutlet weak var map: MKMapView!
  @IBOutlet weak var footerDeleteButton: UIView!
  
  var markMap: MKPointAnnotation?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
  }

  func initView() {
    map.delegate = self
    navigationItem.rightBarButtonItem = editButtonItem
    footerDeleteButton.isHidden = true
  }
  
  @IBAction func gestureRecognizers(_ sender: UILongPressGestureRecognizer) {
    let location = sender.location(in: map)
    let latlog = map.convert(location, toCoordinateFrom: map)
    
    switch sender.state {
    case .began:
      markMap(mark: latlog)
    case .changed: break
//      pinWrite!.coordinate = coord
    case .ended: break
//      savePin()
    default:
      print("error")
    }
  }

  func markMap(mark: CLLocationCoordinate2D) {
    markMap = MKPointAnnotation()
    markMap!.coordinate = mark
    map.addAnnotation(markMap!)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is PhotoViewController {
      print("--------")
    }
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let annotation = view.annotation else {
      return
    }
    
    mapView.deselectAnnotation(annotation, animated: true)
    let lat = String(annotation.coordinate.latitude)
    let lon = String(annotation.coordinate.longitude)
 
    performSegue(withIdentifier: "showPhotos", sender: nil)
  }
  
}

