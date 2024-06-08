//
//  FavoriteListController.swift
//  Clima
//
//  Created by 根岸智也 on 2024/06/08.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

class FavoriteListController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "お気に入り"
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(red: 200/255, green: 255/255, blue: 255/255, alpha: 1.0)
    
    navigationItem.standardAppearance = appearance
    navigationItem.scrollEdgeAppearance = appearance
    navigationItem.compactAppearance = appearance
    
  }
}
