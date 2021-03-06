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

//获取正确的删除索引 泛型
func getRemoveIndex(value:String,aArray:[WXMessage]) ->[Int]{
    var indexArray=[Int]()
    var correctArray=[Int]()
    
    //获取指定的值在数组中的索引并保存
    for (index,_) in enumerate(aArray){
        if(value == aArray[index].from){
            //如果找到指定的值，则把索引添加到索引数组
            indexArray.append(index)
        }
    }
    //计算正确的删除索引
    for (index,originIndex) in enumerate(indexArray){
        //正确的索引
        var y = 0
        //用指定值在原数组中的索引减去索引数组中的索引
        y = originIndex - index
        //添加到正确的索引数组中
        correctArray.append(y)
    }
    
    //返回正确的删除索引
    return correctArray
}
//从数组中删除指定的元素
func removeValueFromArray(value:String,inout aArray:[WXMessage]){
    var correctArray = [Int]()
    correctArray = getRemoveIndex(value,aArray)
    //从原数组中删除 指定的元素(用正确的索引)
    for index in correctArray{
        aArray.removeAtIndex(index)
    }
}
