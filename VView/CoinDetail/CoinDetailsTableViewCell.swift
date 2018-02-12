//
//  CoinDetailsTableViewCell.swift
//  VView
//
//  Created by Matheus Orth on 09/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import UIKit
import ViewModel
import ReactiveSwift

internal final class CoinDetailsTableViewCell: UITableViewCell {

  internal var viewModel: CoinDetailTableViewCellModeling? {
    didSet {
      dateLabel.text = viewModel?.date ?? ""
      closePriceLabel.text = viewModel?.closePrice ?? ""
    }
  }
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var closePriceLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }
}
