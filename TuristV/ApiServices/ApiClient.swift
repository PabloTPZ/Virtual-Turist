//
//  ApiClient.swift
//  TuristV
//
//  Created by Pablo Perez Zeballos on 10/20/20.
//

import Foundation

class ApiClient {
  
  enum EndPointClient {
    case findString(Double, Double, Int, Int)
    
    var obtainURL: String {
      switch self {
      case .findString(let latitude, let longitude, let perPage, let pageNum):
        return StructUrl.urlScheme +
          StructUrl.apiHost +
          StructUrl.endPoint +
          ParameterUrlKey.Method + ParameterValue.flickrPhotosSearch +
          ParameterUrlKey.Api_key + ParameterValue.APIKey +
          ParameterUrlKey.Latitude + "\(latitude)" +
          ParameterUrlKey.Longitude + "\(longitude)" +
          ParameterUrlKey.Radius + "\(20)" +
          ParameterUrlKey.Per_page + "\(perPage)" +
          ParameterUrlKey.Page + "\(pageNum)" +
          ParameterUrlKey.Format + ParameterValue.Format +
          ParameterUrlKey.Nojsoncallback + ParameterValue.Nojsoncallback +
          ParameterUrlKey.Extras + ParameterValue.Extras
      }
    }
    
    var url: URL {
      return URL(string: obtainURL)!
    }
  }
  
  class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type,
                                                        completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data else {
          completion(nil, error)
        
        
        return
      }
      
      let decoder = JSONDecoder()
      do {
        let responseObject = try decoder.decode(ResponseType.self, from: data)
 
          completion(responseObject, nil)
        
        
      } catch {
        print(error)
        
          completion(nil, error)
        
        
      }
    }
    
    task.resume()
    
    return task
  }
  
  class func getRandomPageNumber(totalPicsAvailable: Int, maxNumPicsdisplayed: Int) -> Int {
    let flickrLimit = 4000
    let numberPages = min(totalPicsAvailable, flickrLimit) / maxNumPicsdisplayed
    let randomPageNum = Int.random(in: 0...numberPages)
    return randomPageNum
  }
  
  class func getFlickrURL(latitude: Double, longitude: Double, totalPageAmount: Int = 0, picsPerPage: Int = 15) -> URL {
    
    let perPage = picsPerPage
    let pageNum = getRandomPageNumber(totalPicsAvailable: totalPageAmount, maxNumPicsdisplayed: picsPerPage)
    let searchURL = EndPointClient.findString(latitude, longitude, perPage, pageNum).url
    
    return searchURL
    
  }
  
  class func getPhotos(latitude: Double, longitude: Double, totalPageAmount:  Int = 0, completion: @escaping ([PhotoRequest], Int, Error?) -> Void) -> Void {
    let url = getFlickrURL(latitude: latitude, longitude: longitude, totalPageAmount: totalPageAmount)
    let _ = taskForGETRequest(url: url, responseType: PhotoResponse.self) { response, error in
      if let response = response {
        completion(response.photos.photo, response.photos.pages, nil)
      } else {
        completion([], 0, error)
      }
    }
  }
  
  class func downloadImage(img: String, completion: @escaping (Data?, Error?) -> Void) {
      let url = URL(string: img)
      
      guard let imageURL = url else {
               completion(nil, nil)
           
           return
       }
       
       let request = URLRequest(url: imageURL)
       let task = URLSession.shared.dataTask(with: request) { data, response, error in
               completion(data, nil)
          
       }
       task.resume()
  }
  
}
