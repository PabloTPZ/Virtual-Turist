//
//  ApiClient+Extension.swift
//  TuristV
//
//  Created by Pablo Perez Zeballos on 10/18/20.
//

import UIKit

extension ApiClient {
  struct StructUrl {
    static let urlScheme = "https://"
    static let apiHost = "www.flickr.com"
    static let endPoint = "/services/rest"
  }
  
  struct ParameterUrlKey {
    static let Method = "/?method="
    static let Api_key = "&api_key="
    static let Latitude = "&lat="
    static let Longitude = "&lon="
    static let Radius = "&radius="
    static let Per_page = "&per_page="
    static let Page = "&page="
    static let Format = "&format="
    static let Nojsoncallback = "&nojsoncallback="
    static let Extras = "&extras="
  }
  
  struct ParameterValue {
    static let flickrPhotosSearch = "flickr.photos.search"
    static let APIKey = "588416d0a3f9cf96dd15b0b4e0b962db"
    static let Per_page = 30
    static let Format = "json"
    static let Nojsoncallback = "1"
    static let Extras = "url_n"
  }
}
