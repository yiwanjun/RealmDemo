//
//  RealmManager.swift
//  RealmDemo
//
//  Created by zhouyi on 2017/5/4.
//  Copyright © 2017年 NewBornTown, Inc. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class RecordDataManager: NSObject {
    
    let realmManager = RealmManager.sharedInstance
    
    //向插入数据
    func insert(_ item: RecordModel) -> Bool {
       return RealmManager.sharedInstance.insert(item)
    }
    //查询所有的数据
    open class func query<T: Object>(type: T.Type) -> Results<T> {
        let items = RealmManager.sharedInstance.query(type: type)
        return items
    }
    //查询某类别的数据
    open class func queryByCategory<T: Object>(category : Int ,type: T.Type) -> Results<T> {
        let predicate = String(format: "category == %d", category as CVarArg)
        let items = RealmManager.sharedInstance.query(type: type, filterStr: predicate)
        return items
    }
    //查询某类别某难度的数据
    open class func queryByCategoryAndLevel<T: Object>(category: Int ,level: Int, type: T.Type) -> Results<T>{
        let predicate = String(format: "category == %d AND level == %d",category as CVarArg,level as CVarArg)
        let items = RealmManager.sharedInstance.query(type: type, filterStr: predicate)
        return items
    }
    //查询某类别最近的一条数据
    open class func queryByCategoryLatest<T: Object>(category: Int,type: T.Type) -> Object? {
        let predicate = String(format: "category == %d", category as CVarArg)
        let items = RealmManager.sharedInstance.query(type: type, filterStr: predicate)
        return items.last
    }
    //查询最近30天的数据
    open class func queryByLatestThirtyDays<T: Object>(type: T.Type) -> Results<T>{
        let minDate = Date() - 3600 * 24 * 30
        let predicate = String(format: "date >= %@", minDate as CVarArg)
        let items = RealmManager.sharedInstance.query(type: type, filterStr: predicate)
        return items
    }
    //查询当天的数据
    open class func queryDay<T: Object>(date :Date , type: T.Type) -> Results<T>{
        let zeroDay = zeroDayDate(date: date)
        let predicate = String(format: "date >= %@ AND date <= %@" , zeroDay as CVarArg,(zeroDay + 3600 * 24) as CVarArg  )
        let items = RealmManager.sharedInstance.query(type: type, filterStr: predicate)
        return items
    }
    //查询当月的数据
    open class func queryMonth<T: Object>(date :Date , type: T.Type) -> Results<T>{
        let minDate = zeroMonthDate(date: date)
        let dayCount = daysOfMonth(withDate: date)
        let maxDate = minDate + 3600 * 24 * TimeInterval(dayCount)
        let predicate = String(format: "date >= %@ AND date <= %@" , minDate as CVarArg,maxDate as CVarArg )
        let items = RealmManager.sharedInstance.query(type: type, filterStr: predicate)
        return items
    }
    
}
extension RecordDataManager{

    //获取当天0时的时间戳
    fileprivate class func zeroDayDate(date: Date) -> Date {
        let cal = Calendar.current
        var compon = cal.dateComponents([.year,.month,.day], from: date)
        compon.timeZone = NSTimeZone.system as TimeZone
        let newDateTimeInter = cal.date(from: compon)?.timeIntervalSince1970
        return Date(timeIntervalSince1970: newDateTimeInter!)
        
    }
    //获取当月第一天0时的时间戳
    fileprivate class func zeroMonthDate(date: Date) -> Date {
        let cal = Calendar.current
        var compon = cal.dateComponents([.year,.month], from: date)
        compon.timeZone = NSTimeZone.system as TimeZone
        let newDateTimeInter = cal.date(from: compon)?.timeIntervalSince1970
        return Date(timeIntervalSince1970: newDateTimeInter!)
    }
    //获取当月有多少天
    fileprivate class func daysOfMonth( withDate date: Date) -> Int{
        let daysInMonth = (Foundation.Calendar.current as NSCalendar).range(of: .day, in: .month, for: date)
        return daysInMonth.length
    }
}
    
