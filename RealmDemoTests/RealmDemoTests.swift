//
//  RealmDemoTests.swift
//  RealmDemoTests
//
//  Created by zhouyi on 2017/5/4.
//  Copyright © 2017年 NewBornTown, Inc. All rights reserved.
//

import XCTest
import RealmSwift
@testable import RealmDemo

class RealmDemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testRecordSave(){
        let record = RecordModel()
        record.recordId = Int(Date().timeIntervalSinceNow)
        record.category = Int(arc4random_uniform(6))
        record.level    = Int(arc4random_uniform(6))
        record.day      = Int(arc4random_uniform(30))
        let successed = RecordModel.insert(record)
        assert(successed, "添加数据失败")
    }
    
    //批量数据插入，tests中不生效
    func testBigDate(){
        RecordModel.allARCData()
    }

    //查询所有数据
    func testQuryAllRecord()  {
        let records = RecordModel.quryAllRecord()
        print(records)
        
    }
    
    //查询某一天的数据
    func testQueryToday(){
       let records = RecordModel.queryToday(date: Date(timeIntervalSince1970: TimeInterval(1483200000)))
        print(records)
    }
    //查询某月的数据
    func testQueryMonth(){
        let records = RecordModel.queryMonth(date: Date(timeIntervalSince1970: TimeInterval(1483200000)))
//        assert(records.count == 96, "记录数量不对")
        print(records)
    }
    //查询当年的数据
    func testQueryYear(){
        let records = RecordModel.queryYear(date: Date(timeIntervalSince1970: TimeInterval(1401011001)))
        print(records)
    }
    //查询某类别的数据
    func testQueryCategory(){
        let records = RecordModel.queryCategory(category: RecordModel.Category.full)
        print(records)
    }
    //查询某类别某难度的数据
    func testQueryCategoryAndLevel(){
        let records = RecordModel.queryCategoryAndLevel(category: RecordModel.Category.abs, level: RecordModel.Level.advanced2)
        print(records)
    }
    //查询某类别的最近的一条数据
    func testQueryCategoryLatest() {
        let record = RecordModel.queryCategoryLatest(category: RecordModel.Category.arm)
        print(record)
    }
    //查询最近30天的数据
    func testQueryLatestThirtyDays(){
        let records = RecordModel.queryLatestThirtyDays()
        print(records)
    }
    //重置某类别某难度的数据,注意这里的更新只限于受管理的对象
    func testReset() {
        let records = RecordModel.quryAllRecord()
        print(records)
        records.forEach { (record) in
            RecordModel.update(withClosures: { 
                record.reset = false
            })
        }
    }
    func testReset2() {
        let records = RecordModel.quryAllRecord()
        print(records)
        RecordModel.update(withClosures: {
            records.setValue(true, forKey: "reset")
        })
    }
    
    
    //重复插入数据
    func testRepeatInsert(){
        let p1 = Person()
        p1.birthday = 0
        p1.name     = "jack"
        let realm = try! Realm()
        do {
            try realm.write {
                 realm.add(p1)//没有主键直接报错
            }
        } catch  {
            print(error)
        }
    }
}
