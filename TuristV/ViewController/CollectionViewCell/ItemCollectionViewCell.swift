//
//  ItemCollectionViewCell.swift
//  TuristV
//
//  Created by Pablo Perez Zeballos on 10/26/20.
//

import Foundation
import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var indicator: UIActivityIndicatorView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.imageView.backgroundColor = .red
  }
  
  func showImage(img: UIImage, sizeFit: Bool) {
    imageView.image = img
    indicator.stopAnimating()
    indicator.isHidden = true
    if sizeFit == true {
      imageView.sizeToFit()
    }
  }
  
}
