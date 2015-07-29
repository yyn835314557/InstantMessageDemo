//
//  WXMessage.swift
//  InstantMessageDemo
//
//  Created by 游义男 on 15/7/29.
//  Copyright (c) 2015年 游义男. All rights reserved.
//

import Foundation

//好友 msg struct
struct WXMessage{
    var body:String = ""
    var from:String = ""
    var isCompossing:Bool = false
    var isDelay:String = ""
    var isMe:Bool = false
    
}

//state struct
struct ZhuangTai {
    var name:String = ""
    var isOnline:Bool = false
    
}