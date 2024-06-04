//
//  JokeDataMAnager.swift
//  Clima
//
//  Created by 根岸智也 on 2024/06/04.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

protocol JokeManagerDelegate {
  func updateJoke(jokeModel: JokeModel)
  func failedWithError(error: Error)
}

struct JokeDataManager {
  
  var delegate: JokeManagerDelegate?
  
  func fetchJoke() {
    performRequest(url: "https://icanhazdadjoke.com/" )
  }
  
  func performRequest(url: String) {
    if let url = URL(string: url) {
      
      let session = URLSession(configuration: .default)
      
      var request = URLRequest(url: url)
      request.setValue("application/json", forHTTPHeaderField: "Accept")
      
      let task = session.dataTask(with: request) { (data, response, error) in
        
        if error != nil {
          self.delegate?.failedWithError(error: error!)
          return
        }
        
        if let safeData = data {
          if let joke = self.parseJSON(jokeData: safeData) {
            self.delegate?.updateJoke(jokeModel: joke)
          }
        }
      }
      
      task.resume()
    }
  }
  
    func parseJSON(jokeData: Data) -> JokeModel? {
      let decoder = JSONDecoder()
      do {
        let decodedData = try decoder.decode(JokeData.self, from: jokeData)
        print("decoded: \(decodedData)")
  
        return JokeModel(joke: decodedData.joke)
  
      } catch {
        self.delegate?.failedWithError(error: error)
        return nil
      }
    }
}
