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

class RecordDataHelper: NSObject {
    
    let realmManager = RealmManager.sharedInstance
    
    //向插入数据
    open class func insert(_ item: RecordModel) -> Bool {
       return RealmManager.sharedInstance.insert(item)
    }
    //删除数据
    open class func delete(_ item: RecordModel) -> Bool{
        return RealmManager.sharedInstance.delete(item: item)
    }
    //删除所有数据
    open class func deleteAll() -> Bool{
        return RealmManager.sharedInstance.deleteAll()
    }
    //更新不受管理的对象
    open class func update<T: Object>(item: T) -> Bool{
        return RealmManager.sharedInstance.update(item: item)
    }
    //更新受管理的对象
    open class func update( withClosures closures: @escaping (() throws -> Void)){
        return RealmManager.sharedInstance.update(withClosures: closures)
    }
    //查询所有的数据
    open class func query<T: Object>(type: T.Type) -> Results<T> {
        let items = RealmManager.sharedInstance.query(type: type)
        return items
    }
    //查询某类别的数据
    open class func queryByCategory<T: Object>(category : Int ,type: T.Type) -> Results<T> {
        let predicate = NSPredicate(format: "category == %d", category as CVarArg)
        let items = RealmManager.sharedInstance.query(type: type, withPredicate: predicate)
        return items
    }
    //查询某类别某难度的数据
    open class func queryByCategoryAndLevel<T: Object>(category: Int ,level: Int, type: T.Type) -> Results<T>{
        let predicate = NSPredicate(format: "category == %d AND level == %d",category as CVarArg,level as CVarArg)
        let items = RealmManager.sharedInstance.query(type: type, withPredicate: predicate)
        return items
    }
    //查询某类别最近的一条数据
    open class func queryByCategoryLatest<T: Object>(category: Int,type: T.Type) -> Object? {
        let predicate = NSPredicate(format: "category == %d", category as CVarArg)
        let items = RealmManager.sharedInstance.query(type: type, withPredicate: predicate)
        return items.last
    }
    //查询最近30天的数据
    open class func queryByLatestThirtyDays<T: Object>(type: T.Type) -> Results<T>{
        let minDate = Date() - 3600 * 24 * 30
        let predicate = NSPredicate(format: "date >= %@", minDate as CVarArg)
        let items = RealmManager.sharedInstance.query(type: type, withPredicate: predicate)
        return items
    }
    //查询当天的数据
    open class func queryDay<T: Object>(date :Date , type: T.Type) -> Results<T>{
        let zeroDay = zeroDayDate(date: date)
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@" , zeroDay as CVarArg,(zeroDay + 3600 * 24) as CVarArg  )
        let items = RealmManager.sharedInstance.query(type: type, withPredicate: predicate)
        return items
    }
    //查询当月的数据
    open class func queryMonth<T: Object>(date :Date , type: T.Type) -> Results<T>{
        let minDate = zeroMonthDate(date: date)
        let dayCount = daysOfMonth(withDate: date)
        let maxDate = minDate + 3600 * 24 * TimeInterval(dayCount)
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@" , minDate as CVarArg,maxDate as CVarArg )
        let items = RealmManager.sharedInstance.query(type: type, withPredicate: predicate)
        return items
    }
    //查询当年的数据
    open class func queryYear<T: Object>(date: Date, type: T.Type) -> Results<T>{
        let minDate = zeroYearDate(date: date)
        let dayCount = daysOfYear(withDate: date)
        let maxDate = minDate + 3600 * 24 * TimeInterval(dayCount)
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", minDate as CVarArg, maxDate as CVarArg)
        let items = RealmManager.sharedInstance.query(type: type, withPredicate: predicate).sorted(byKeyPath: "date")
        return items
    }
    
}
extension RecordDataHelper{

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
    //获取当年第一天0时的时间戳
    fileprivate class func zeroYearDate(date: Date) -> Date{
        let cal = Calendar.current
        var compon = cal.dateComponents([.year], from: date)
        compon.timeZone = NSTimeZone.system as TimeZone
        let newDateTimeInter = cal.date(from: compon)?.timeIntervalSince1970
        return Date(timeIntervalSince1970: newDateTimeInter!)
        
        
    }
    //获取当月有多少天
    fileprivate class func daysOfMonth( withDate date: Date) -> Int{
        let days = (Foundation.Calendar.current as NSCalendar).range(of: .day, in: .month, for: date)
        return days.length
    }
    //获取一年有多少天
    fileprivate class func daysOfYear( withDate date: Date) -> Int{
        let calendar = Calendar.current as NSCalendar
        var comps: DateComponents = calendar.components([NSCalendar.Unit.year , NSCalendar.Unit.month , NSCalendar.Unit.day], from: Date())
        var count: Int = 0
        for i in 1...12 {
            comps.month = i
            let range: NSRange = calendar.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: calendar.date(from: comps)!)
            count += range.length
        }
        return count
    }
}

extension RealmManager{
    func query<T: Object>(type: T.Type,withPredicate fileter: NSPredicate) ->Results<T>  {
        return realm.objects(type).filter(fileter)
    }
}

