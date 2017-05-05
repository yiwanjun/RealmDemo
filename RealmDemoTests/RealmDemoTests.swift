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
        //改变count决定生成数据多少
        let count = 9
        
        for i in 0..<count {
            for j in 0..<count {
                for k in 0..<count {
                    let record = RecordModel()
                    record.recordId = Int( NSDate().timeIntervalSince1970)
                    record.category = Int(arc4random_uniform(6))
                    record.level = Int(arc4random_uniform(6))
                    record.day = Int(arc4random_uniform(30))
                    record.during = Int(arc4random_uniform(60))
                    record.date = Date(timeIntervalSince1970: TimeInterval(1481000000 + i * 1000000 + j * 100000 + k * 10000 + k * 1000 ))
                    record.tmp7 = Int( record.date.timeIntervalSince1970)
                    let successed = RealmManager.sharedInstance.insert(record)
                    XCTAssert(successed, "保存失败")
                    sleep(1)
                    print("完成一次 : ", i * count * count + j * count + k )
                }
            }
        }
    }
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd mm:ss"
        return formatter.string(from: date)
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
    func testQueryMonth() {
        let records = RecordModel.queryMonth(date: Date(timeIntervalSince1970: TimeInterval(1483200000)))
//        assert(records.count == 96, "记录数量不对")
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
}
