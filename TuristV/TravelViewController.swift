//
//  TravelViewController.swift
//  TuristV
//
//  Created by Pablo Perez Zeballos on 10/16/20.
//

import UIKit
import MapKit
import CoreData

class TravelViewController: UIViewController, MKMapViewDelegate {

  @IBOutlet weak var map: MKMapView!
  @IBOutlet weak var footerDeleteButton: UIView!
  
  var dataController:DataController!
  var fetchedResultsController:NSFetchedResultsController<Mark>!
  var marks: [Mark]?
  
  var markMapPoint: MKPointAnnotation?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dataController = DataController.shared
    dataController.load()
    initView()
    
    marks = dataController.fetchMark()
    loadMark()
  }
  
  func loadMark() {
    if let marks = marks {
      showMark(marks)
    }
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
    case .changed:
      markMapPoint!.coordinate = latlog
    case .ended:
      addMark()
    default:
      print("error")
    }
  }

  func markMap(mark: CLLocationCoordinate2D) {
    markMapPoint = MKPointAnnotation()
    markMapPoint!.coordinate = mark
    map.addAnnotation(markMapPoint!)
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
  
  func addMark() {
    let mark = Mark(context: dataController.viewContext)
    mark.latitude = String(markMapPoint!.coordinate.latitude)
    mark.logitude = String(markMapPoint!.coordinate.longitude)
    try? dataController.viewContext.save()
  }
  
  func showMark(_ marks: [Mark]) {
    marks.forEach { (mark) in
      let annotation = MKPointAnnotation()
      let lat = Double(mark.latitude!)!
      let lon = Double(mark.logitude!)!
      annotation.coordinate = CLLocationCoordinate2DMake(lat, lon)
      map.addAnnotation(annotation)
    }
    
    map.showAnnotations(map.annotations, animated: true)
  }
  
}

