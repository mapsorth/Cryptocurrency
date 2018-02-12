//
//  CoinDetail.swift
//  ViewModel
//
//  Created by Matheus Orth on 09/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import Foundation
import Himotoki

public struct CoinDetail {
  public let time: Double
  public let close: Float
  public let high: Float
  public let low: Float
  public let open: Float
}

extension CoinDetail : Himotoki.Decodable {
  public static func decode(_ e: Extractor) throws -> CoinDetail {
    return try CoinDetail(
      time:   e <| "time",
      close:  e <| "close",
      high:   e <| "high",
      low:    e <| "low",
      open:   e <| "open"
    )
  }
}
