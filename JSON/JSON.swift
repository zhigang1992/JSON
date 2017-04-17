//
//  JSON.swift
//  JSON
//
//  Created by Zhigang Fang on 4/17/17.
//  Copyright © 2017 matrix. All rights reserved.
//

import Foundation
public struct JSON {

    public var value: Optional<NSObject>

    public init(value: Optional<NSObject>) {
        self.value = value
    }

    public subscript(index: Int) -> JSON {
        get {
            return JSON(value: value.flatMap({ value in
                return (value as? NSArray).flatMap({
                    if $0.count > index && index >= 0 {
                        return $0[index] as? NSObject
                    }
                    return nil
                })
            }))
        }
        set {
            let newValueToSet = newValue.value ?? NSNull()
            guard let array = self.value as? NSArray else {
                self.value = NSMutableArray(object: newValueToSet)
                return
            }
            let mutableArray: NSMutableArray
            if let array = array as? NSMutableArray {
                mutableArray = array
            } else {
                mutableArray = array.mutableCopy() as! NSMutableArray
            }
            guard (mutableArray.count > index && index >= 0) else { return }
            mutableArray.replaceObject(at: index, with: newValueToSet)
            self.value = mutableArray
        }
    }

    public subscript(key: String) -> JSON {
        get {
            return JSON(value: value.flatMap({ value in
                return (value as? NSDictionary).flatMap({$0[key] as? NSObject})
            }))
        }
        set {
            let newValueToSet = newValue.value ?? NSNull()
            guard let dictionary = self.value as? NSDictionary else {
                self.value = NSMutableDictionary(object: newValueToSet, forKey: key as NSString)
                return
            }
            let mutableDictionary: NSMutableDictionary
            if let dictionary = dictionary as? NSMutableDictionary {
                mutableDictionary = dictionary
            } else {
                mutableDictionary = dictionary.mutableCopy() as! NSMutableDictionary
            }
            mutableDictionary.setValue(newValueToSet, forKeyPath: key as String)
            self.value = mutableDictionary
        }
    }

    public var int: Int? {
        get {
            return self.value as? Int
        }
        set {
            self.value = newValue.flatMap({ $0 as NSObject})
        }
    }

    public var float: Float? {
        get {
            return self.value as? Float
        }
        set {
            self.value = newValue.flatMap({ $0 as NSObject })
        }
    }

    public var string: String? {
        get {
            return self.value as? String
        }
        set {
            self.value = newValue.flatMap({ $0 as NSObject })
        }
    }

    public var bool: Bool? {
        get {
            return self.value as? Bool
        }
        set {
            self.value = newValue.flatMap({ $0 as NSObject })
        }
    }

    public var array: Array<JSON>? {
        return (self.value as? NSArray).map({ array in
            array.map({JSON(value: $0 as? NSObject)})
        })
    }

    public var dictionary: Array<(String, JSON)>? {
        return (self.value as? NSDictionary).map({ dictionary in
            dictionary.flatMap({ key, value in
                guard let key = key as? String else { return nil }

                return (key, JSON(value: value as? NSObject))
            })
        })
    }
    
}
