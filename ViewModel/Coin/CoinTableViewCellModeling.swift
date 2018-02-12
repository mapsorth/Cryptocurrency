//
//  CoinTableViewCellModeling.swift
//  ViewModel
//
//  Created by Matheus Orth on 07/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift

public protocol CoinTableViewCellModeling {

  var name: String { get }
  var symbol: String { get }
  }
