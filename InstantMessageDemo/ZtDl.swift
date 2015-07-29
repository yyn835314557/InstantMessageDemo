//
//  ZtDl.swift
//  InstantMessageDemo
//
//  Created by 游义男 on 15/7/29.
//  Copyright (c) 2015年 游义男. All rights reserved.
//

import Foundation
//状态代理协议
protocol ZtDl{
    func isOn(zt:ZhuangTai)
    func isOff(zt:ZhuangTai)
    func meOff() 
}