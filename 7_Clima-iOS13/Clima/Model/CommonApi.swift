//
//  CommonApi.swift
//  Clima
//
//  Created by 根岸智也 on 2024/06/05.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

class CommonApi {
  static let commonApi = CommonApi()
  
  func getRequest<T: Codable>(url: URL, type: T.Type, completionHandler: @escaping (T) -> Void, failedWithError: @escaping (Error) -> Void) {
    
    let session = URLSession(configuration: .default)
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    let task = session.dataTask(with: request) { (data, response, error) in
      
      if error != nil {
        failedWithError(error!)
        return
      }
      
      if let safeData = data {
        do {
         let decodedData = try JSONDecoder().decode(T.self, from: safeData)
          completionHandler(decodedData)
        } catch {
          failedWithError(error)
          return
        }
            
      }
    }
    task.resume()
  }
}
