//
//  ViewController.swift
//  RealmDemo
//
//  Created by zhouyi on 2017/5/4.
//  Copyright © 2017年 NewBornTown, Inc. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(NSHomeDirectory())
//        RecordModel.deleteAll()
//        sleep(3)
        RecordModel.allARCData()
    }
    func testsdd() {
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
                    let successed = RealmManager.sharedInstance.realm.add(record, update: true)
                    //                    XCTAssert(successed, "保存失败")
                    //                    sleep(1)
                    print("完成一次 : ", i * count * count + j * count + k )
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

