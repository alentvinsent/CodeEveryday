//
//  Permission.swift
//  QRCodeScanner
//
//  Created by Apple  on 21/04/23.
//

import Foundation

/// Camera Permission Enum
enum Permission:String{
    case idle = "Not determined"
    case approved = "Access Granded"
    case denied = "Access Denied"
}
