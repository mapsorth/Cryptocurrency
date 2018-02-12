//
//  CoinTableViewCell.swift
//  VView
//
//  Created by Matheus Orth on 07/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import UIKit
import ViewModel
import ReactiveSwift
import ReactiveCocoa
import Result

internal final class CoinTableViewCell: UITableViewCell {
  
  internal var viewModel: CoinTableViewCellModeling? {
    didSet {
      nameLabel.text = viewModel?.name ?? ""
      symbolLabel.text = viewModel?.symbol ?? ""
    }
  }
  
  // MARK - Init and life cycle
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var symbolLabel: UILabel!
}

