//
//  Mark+Extensions.swift
//  TuristV
//
//  Created by Pablo Perez Zeballos on 10/17/20.
//

import Foundation

extension Mark {
  
  public override func awakeFromInsert() {
    super.awakeFromInsert()
    latitude = String()
    logitude = String()
  }
}
