//
//  FavoriteListController.swift
//  Clima
//
//  Created by 根岸智也 on 2024/06/08.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

@available(iOS 15.0, *)
class FavoriteCityTableController: UIViewController {
  
  var weatherManager = WeatherDataManager()
  let commonApi = CommonApi()
  
  @IBOutlet weak var cityTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = R.string.localizable.cityTableTitle()
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = R.color.cityTableTitleBg()
    
    navigationItem.standardAppearance = appearance
    navigationItem.scrollEdgeAppearance = appearance
    navigationItem.compactAppearance = appearance
    
    navigationItem.backBarButtonItem = UIBarButtonItem(title:  R.string.localizable.back(), style:  .plain, target: nil,action: nil)
    
    cityTableView.dataSource = self
    cityTableView.delegate = self
    
    cityTableView.register(UINib(nibName: R.reuseIdentifier.favoriteCityTableCell.identifier, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.favoriteCityTableCell.identifier)
    cityTableView.sectionHeaderTopPadding = 1
  }
  
  private let headerArray: [String] = [R.string.localizable.europe(), R.string.localizable.asia(), R.string.localizable.oceania(), R.string.localizable.africa()]
  private let europeArray: [String] = [R.string.localizable.berlin(), R.string.localizable.amsterdam(), R.string.localizable.london()]
  private let asiaArray: [String] = [R.string.localizable.tokyo(), R.string.localizable.bangkok()]
  private let oceaniaArray: [String] = [R.string.localizable.sydney(), R.string.localizable.melbourne()]
  private let africaArray: [String] = [R.string.localizable.capeTown()]
  
  private lazy var favoriteCityArray = [
    city(isShown: true, region: self.headerArray[0], cityArray: self.europeArray),
    city(isShown: false, region: self.headerArray[1], cityArray: self.asiaArray),
    city(isShown: false, region: self.headerArray[2], cityArray: self.oceaniaArray),
    city(isShown: false, region: self.headerArray[3], cityArray: self.africaArray)
  ]
}

@available(iOS 15.0, *)
extension FavoriteCityTableController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favoriteCityArray[section].isShown ? favoriteCityArray[section].cityArray.count : 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = cityTableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.favoriteCityTableCell.identifier)
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

@available(iOS 15.0, *)
extension FavoriteCityTableController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView else { return }
    header.tintColor = R.color.cityTableHeader()
    header.textLabel?.textColor = R.color.label()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectCity = favoriteCityArray[indexPath.section].cityArray[indexPath.row]
    guard let url = URL(string: weatherManager.createFetchUrl(selectCity)) else { return }
    commonApi.getRequest(url: url, type: WeatherData.self) { (weatherData: WeatherData) in
      DispatchQueue.main.sync {
        let favoriteCityVC = FavoriteCityController(weatherData: weatherData)
        self.navigationController?.pushViewController(favoriteCityVC, animated: true)
      }
    } failedWithError: { (error) in
      print(error)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UITableViewHeaderFooterView()
    let gesture = UITapGestureRecognizer(target: self, action: #selector(headertapped(sender:)))
    headerView.addGestureRecognizer(gesture)
    headerView.tag = section
    return headerView
  }
  
  @objc func headertapped(sender: UITapGestureRecognizer) {
    guard let section = sender.view?.tag else {
      return
    }
    favoriteCityArray[section].isShown.toggle()
    cityTableView.beginUpdates()
    cityTableView.reloadSections([section], with: .automatic)
    cityTableView.endUpdates()
  }
}
