//
//  FavoriteCityTableViewCell.swift
//  Clima
//
//  Created by 根岸智也 on 2024/06/08.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

class FavoriteCityTableViewCell: UITableViewCell {
  
  @IBOutlet weak var NextButton: UIButton!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    NextButton.setTitle("＞", for: .normal)
    NextButton.setTitleColor(.black, for: .normal)
  }
  
  static let identifier = "FavoriteCityTableCell"

  static func nib() -> UINib {
    return UINib(nibName: "FavoriteCityTableCell", bundle: nil)
  }
  
}