//
//  Event.swift
//  LePla0418
//
//  Created by 吉川椛 on 2020/04/29.
//  Copyright © 2020 com.litech. All rights reserved.
//

import Foundation
import RealmSwift

class Event: Object {

    @objc dynamic var time1: String = ""
    @objc dynamic var time2: String = ""
    @objc dynamic var subject: String = ""
    @objc dynamic var contetnt: String = ""
    
}
