//
//  CollisionCategories.swift
//  Space Destroyers
//
//  Created by Best on 10/11/2567 BE.
//

struct CollisionCategories{
  static let Invader : UInt32 = 0x1 << 0
  static let Player: UInt32 = 0x1 << 1
  static let InvaderBullet: UInt32 = 0x1 << 2
  static let PlayerBullet: UInt32 = 0x1 << 3
  static let EdgeBody: UInt32 = 0x1 << 4
}
