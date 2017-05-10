//
//  RealmManager.swift
//  SoloFitness
//
//  Created by direnjie on 2017/4/25.
//  Copyright © 2017年 赤子城. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager: NSObject {
    
    let realm = try! Realm()
    
    static let sharedInstance = RealmManager()
    private override init() {}
    
    //向插入数据
    func insert<T: Object>(_ items:T ...) -> Bool {
        
        do {
            try realm.write{
                for item in items {
                    realm.add(item)
                }
            }
            return true
        } catch  {
            return false
        }
        
    }
    

    //查询表中的数据 realmManager.queryAllDataWithTable(type: WeightChangeModel.self)
    func query<T: Object>(type: T.Type) -> Results<T> {
        
        let items = realm.objects(T.self)
        return items
    }
    
    
    //根据日期查询当天的信息
    func query<T: Object>(date :Date , type: T.Type) -> Results<T>{
        
        let predicate = NSPredicate(format: "date == %@" , date as CVarArg)
        let items = realm.objects(T.self).filter(predicate)
        
        return items
    }
    
    
    //更新指定的元素
    func update<T: Object>(item: T) -> Bool {
        
        do {
            try realm.write{
               
               realm.add(item, update: true)
            
            }
            return true
        } catch  {
            return false
        }
        
    }
    
    func update( withClosures closures: @escaping (() throws -> Swift.Void)){
        do {
            try self.realm.write(closures)
        } catch  {
            print(error)
        }
    }
    
    //删除指定的元素
    func delete<T: Object>(item: T) -> Bool {
        
        do {
            try realm.write{
                realm.delete(item)
            }
            return true
        } catch  {
            return false
        }
        
   }
    
    
    //删除所有元素
    func deleteAll() -> Bool{
        
        do {
            try realm.write{
                realm.deleteAll()
            }
            return true
        } catch  {
            return false
        }
        
   }
    
    
    func query<T: Object>(type: T.Type , filterStr: String) -> Results<T>{
        
        let predicate = NSPredicate(format: filterStr)
        let items = realm.objects(T.self).filter(predicate)
        
        return items
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        
}
    
