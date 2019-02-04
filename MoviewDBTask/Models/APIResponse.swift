//
//  APIResponse.swift
//  MoviewDBTask
//
//  Created by Asim Karel on 04/02/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import Foundation
import UIKit
class APIResponse: NSObject {
    var statusCode:Int?
    var message:String?
    var data:Any? ;
    var token:String?
    var imagePath:String?
    var image:UIImage?
    var filePath:String!;
    public override init() {
        
    }
}
