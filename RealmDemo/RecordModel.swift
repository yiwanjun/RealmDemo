//
//  RecordModel.swift
//  SoloFitness
//
//  Created by direnjie on 2017/4/25.
//  Copyright © 2017年 赤子城. All rights reserved.
//

import UIKit
import RealmSwift

class RecordModel: Object {
    
    struct Category {
        static let  full  = 0
        static let  abs   = 1
        static let  butt  = 2
        static let  arm   = 3
        static let  leg   = 4
        static let  non   = 999
    }
    
    struct Level {
        static let beginner1     = 0
        static let beginner2     = 1
        static let intermediate1 = 2
        static let intermediate2 = 3
        static let advanced1     = 4
        static let advanced2     = 5
        static let non           = 999
    }
    
    dynamic var recordId = 0
    dynamic var uid = 0
    dynamic var date = Date()
    dynamic var during = 0
    dynamic var category = Category.non
    dynamic var level = Level.non
    dynamic var day = 0
    dynamic var weight = 0.00
    dynamic var height = 0.00
    dynamic var reset = false
    dynamic var tmp1 = ""
    dynamic var tmp2 = ""
    dynamic var tmp3 = ""
    dynamic var tmp4 = 0.00
    dynamic var tmp5 = 0.00
    dynamic var tmp6 = 0.00
    dynamic var tmp7 = 0
    dynamic var tmp8 = Date()
    
    override static func primaryKey() ->String?{
        return "recordId"
    }
}



extension RecordModel{
    //插入数据
    open class func insert(_ item: RecordModel) -> Bool {
        return RecordDataHelper.insert(item)
    }
    //删除数据
    open class func deleteAll() -> Bool{
        return RecordDataHelper.deleteAll()
    }
    //删除数据
    open class func delete<T: Object>(item: T) -> Bool{
        return RecordDataHelper.delete(item as! RecordModel)
    }
    //更新不受管理的对象
    open class func update<T: Object>(item: T) -> Bool{
        return RecordDataHelper.update(item: item)
    }
    ////更新受管理的对象
    open class func update( withClosures closures: @escaping (() throws -> Void)){
        return RecordDataHelper.update(withClosures:closures)
    }
    //查询所有数据
    open class func quryAllRecord() -> Results<RecordModel> {
        let records = RecordDataHelper.query(type: RecordModel.self)
        return records
    }
    //查询某一天的数据
    open class func queryToday(date: Date) -> Results<RecordModel>{
        let records = RecordDataHelper.queryDay(date: date, type: self)
        return records
    }
    //查询某月的数据
    open class func queryMonth(date: Date) -> Results<RecordModel>{
        let records = RecordDataHelper.queryMonth(date: date, type: self)
        return records
    }
    //查询某类别的数据
    open class func queryCategory(category: Int) -> Results<RecordModel>{
        let records = RecordDataHelper.queryByCategory(category: category, type: self)
        return records
    }
    //查询某类别某难度的数据
    open class func queryCategoryAndLevel(category: Int, level: Int) -> Results<RecordModel>{
        let records = RecordDataHelper.queryByCategoryAndLevel(category: category,level: level, type: self)
        return records
    }
    //查询某类别的最近的一条数据
    open class func queryCategoryLatest(category: Int) -> RecordModel{
        let record: RecordModel = RecordDataHelper.queryByCategoryLatest(category: category, type: self) as! RecordModel
        return record
    }
    //查询最近30天的数据
    open class func queryLatestThirtyDays() -> Results<RecordModel>{
        let records = RecordDataHelper.queryByLatestThirtyDays(type: RecordModel.self)
        return records
    }
}
extension RecordModel{
    
    open class func allARCData(){
        DispatchQueue(label: "jhdhe2background").async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    let count = 5
                    for i in 0..<count {
                        realm.beginWrite()
                        for j in 0..<count {
                            for k in 0..<count{
                                realm.create(RecordModel.self, value: [
                                    "recordId": Int( NSDate().timeIntervalSince1970) + i*count*count + j*count + k,
                                    "category": Int(arc4random_uniform(6)),
                                    "level": Int(arc4random_uniform(6)),
                                    "day" : Int(arc4random_uniform(30)),
                                    "during" : Int(arc4random_uniform(60)),
                                    "date": Date(timeIntervalSince1970: TimeInterval(1481000000 + i * 1000000 + j * 100000 + k * 10000 + k * 1000 ))
                                    ])
                            }
                        }
                        
                        try! realm.commitWrite()
                    }
                } catch  {
                    print(error)
                }
            }
        }
    }
}
