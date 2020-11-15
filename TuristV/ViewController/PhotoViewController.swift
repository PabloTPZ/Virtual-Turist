//
//  PhotoViewController.swift
//  TuristV
//
//  Created by Pablo Perez Zeballos on 10/17/20.
//

import UIKit
import MapKit
import CoreData

class PhotoViewController: UIViewController, MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate{
  
  @IBOutlet weak var map: MKMapView!
  @IBOutlet weak var collectionViewPhoto: UICollectionView!
  @IBOutlet weak var indicator: UIActivityIndicatorView!
  @IBOutlet weak var labelTextIndicator: UILabel!
  @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
  
  var mark: Mark!
  var dataController: DataController!
  var dataCore: NSFetchedResultsController<Photo>!
  
  
  var insertedIndexPaths: [IndexPath]!
  var deletedIndexPaths: [IndexPath]!
  var updatedIndexPaths: [IndexPath]!
  
  let identifierCell = "ItemControllerViewCell"
  
  let numberOfCellsPerRow: CGFloat = 3
  
  override func viewDidLoad() {
    super.viewDidLoad()
    labelTextIndicator.text = "Loading..."
    labelTextIndicator.isHidden = false
    collectionViewPhoto.dataSource = self
    collectionViewPhoto.delegate = self
    collectionViewPhoto.allowsMultipleSelection = true
    configureFlowLayout(view.frame.size)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
    dataCore = nil
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    showMark()
    setupFetchedResultControllerWith()
    downloadPhotos()
    
  }
  
  func registerCell() {
    collectionViewPhoto.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: identifierCell)
  }
  
  
  func showMark() {
    map.delegate = self
    let annotation = MKPointAnnotation()
    let lat = Double(mark!.latitude!)!
    let lon = Double(mark!.logitude!)!
    annotation.coordinate = CLLocationCoordinate2DMake(lat, lon)
    map.addAnnotation(annotation)
    
    map.showAnnotations(map.annotations, animated: true)
  }
  
  private func downloadPhotos() {
    indicator.isHidden = false
    indicator.startAnimating()
    
    guard (dataCore?.fetchedObjects?.isEmpty)! else {
      indicator.isHidden = true
      indicator.stopAnimating()
        print("image metadata is already present. no need to re download")
        return
    }
    let pagesCount = 30
    ApiClient.getPhotos(latitude: Double(mark!.latitude!)!, longitude: Double(mark!.logitude!)!, totalPageAmount: pagesCount) { (photos, pages, error) in
      if let error = error {
        self.showSimpleAlert(error: error.localizedDescription)
      }
      
      if photos.count > 0 {
        
        DispatchQueue.main.async {
        self.indicator.isHidden = true
        self.indicator.stopAnimating()
        
        self.labelTextIndicator.isHidden = true
        
          for photo in photos {
            let newPhoto = Photo(context: self.dataController.viewContext)
            newPhoto.url = URL(string: photo.url_m ?? "")
            newPhoto.img = nil
            newPhoto.title = ""
            newPhoto.mark = self.mark
            
            do {
              try self.dataController.viewContext.save()
            } catch {
              print("Unable to save the photo")
            }
          }
        }
          
      } else {
        
        self.indicator.isHidden = true
        self.indicator.stopAnimating()
        
        self.labelTextIndicator.isHidden = true
      }
    }
  }
  
  func setupFetchedResultControllerWith() {
    
    let fr:NSFetchRequest<Photo> = Photo.fetchRequest()
    fr.sortDescriptors = []
    fr.predicate = NSPredicate(format: "mark == %@", argumentArray: [mark as Any])
    dataCore = NSFetchedResultsController(fetchRequest: fr,
                                          managedObjectContext: dataController.viewContext,
                                          sectionNameKeyPath: nil, cacheName:  nil)
    dataCore!.delegate = self
    
    do {
      try dataCore!.performFetch()
    } catch {
      fatalError("The fetch could not be performed: \(error.localizedDescription)")
    }
  }
  
  func showSimpleAlert(error: String) {
    let alert = UIAlertController(title: "Error",
                                  message: error,
                                  preferredStyle: UIAlertController.Style.alert)
    
    alert.addAction(UIAlertAction(title: "Dissmis",
                                  style: UIAlertAction.Style.default,
                                  handler: { _ in
                                    //Cancel Action
                                  }))
    self.present(alert, animated: true, completion: nil)
  }
  
  //MARK : - CollectionView
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataCore?.sections?[section].numberOfObjects ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierCell, for: indexPath as IndexPath) as! ItemCollectionViewCell
    cell.indicator.startAnimating()
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let photoViewCell = cell as! ItemCollectionViewCell
    
    let url = self.dataCore.object(at: indexPath).url
    let data = try? Data(contentsOf: url!)
    photoViewCell.showImage(img: UIImage(data: data!)!, sizeFit: false)
  }
  
  func configureFlowLayout(_ withSize: CGSize) {
    
        if let flowLayout = collectionViewPhoto.collectionViewLayout as? UICollectionViewFlowLayout {
         let space:CGFloat = 3.0
         let dimension = (view.frame.size.width - (2 * space)) / 3.0
         flowLayout.minimumInteritemSpacing = space
         flowLayout.minimumLineSpacing = space
         flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        }
    
  }
  
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                  at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath:  IndexPath?)
  {
    switch type {
    case .insert:
      self.collectionViewPhoto.insertItems(at: [newIndexPath!])
      break
    case .delete:
      self.collectionViewPhoto.deleteItems(at: [indexPath!])
      break
    case .update:
      self.collectionViewPhoto.reloadItems(at: [indexPath!])
      break
    case .move:
      print("Move an item. We don't expect to see this in this app.")
      break
    @unknown default:
        print("Move an item. We don't expect to see this in this app.")
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    
    collectionViewPhoto.performBatchUpdates({() -> Void in
      
      for indexPath in self.insertedIndexPaths {
        self.collectionViewPhoto.insertItems(at: [indexPath])
      }
      
      for indexPath in self.deletedIndexPaths {
        self.collectionViewPhoto.deleteItems(at: [indexPath])
      }
      
      for indexPath in self.updatedIndexPaths {
        self.collectionViewPhoto.reloadItems(at: [indexPath])
      }
      
    }, completion: nil)
  }

  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    insertedIndexPaths = [IndexPath]()
    deletedIndexPaths = [IndexPath]()
    updatedIndexPaths = [IndexPath]()
  }
}
