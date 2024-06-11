//
//  FavoriteListController.swift
//  Clima
//
//  Created by 根岸智也 on 2024/06/08.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

class FavoriteCityTableController: UIViewController {
  
  var weatherManager = WeatherDataManager()
  let commonApi = CommonApi()
  
  @IBOutlet weak var cityTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "都市一覧"
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(red: 200/255, green: 255/255, blue: 255/255, alpha: 1.0)
    
    navigationItem.standardAppearance = appearance
    navigationItem.scrollEdgeAppearance = appearance
    navigationItem.compactAppearance = appearance
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title:  "戻る", style:  .plain, target: nil,action: nil)
    
    cityTableView.dataSource = self
    cityTableView.delegate = self
    
    cityTableView.register(FavoriteCityTableViewCell.nib(), forCellReuseIdentifier: FavoriteCityTableViewCell.identifier)
    cityTableView.sectionIndexBackgroundColor = .blue
    cityTableView.sectionIndexTrackingBackgroundColor = .red
    
    
  }
  
  private let headerArray: [String] = ["ヨーロッパ", "アジア", "オセアニア", "アフリカ"]
  private let europeArray: [String] = ["ベルリン", "アムステルダム", "ロンドン"]
  private let asiaArray: [String] = ["東京", "バンコク"]
  private let oceaniaArray: [String] = ["シドニー", "メルボルン"]
  private let africaArray: [String] = ["ケープタウン"]
  
  private lazy var favoriteCityArray = [
    city(isShown: true, region: self.headerArray[0], cityArray: self.europeArray),
    city(isShown: false, region: self.headerArray[1], cityArray: self.asiaArray),
    city(isShown: false, region: self.headerArray[2], cityArray: self.oceaniaArray),
    city(isShown: false, region: self.headerArray[3], cityArray: self.africaArray)
  ]
}

extension FavoriteCityTableController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favoriteCityArray[section].cityArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = cityTableView.dequeueReusableCell(withIdentifier: FavoriteCityTableViewCell.identifier)
    cell?.textLabel?.text = favoriteCityArray[indexPath.section].cityArray[indexPath.row]
    
    return cell!
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return favoriteCityArray.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return favoriteCityArray[section].region
  }
}

extension FavoriteCityTableController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.tintColor = .lightGray
    header.textLabel?.textColor = .black
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectCity = favoriteCityArray[indexPath.section].cityArray[indexPath.row]
    guard let url = URL(string: weatherManager.createFetchUrl(selectCity)) else { return }
    let favoriteCity = FavoriteCityController()
    favoriteCity.outputUrl = url
    navigationController?.pushViewController(favoriteCity, animated: true)
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
