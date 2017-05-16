//
//  L3SDKUtilityLazyLoad.swift
//  iOS-LazyTableView
//
//  Created by Abhi on 5/15/17.
//  Copyright © 2017 Abhi. All rights reserved.
//

import Foundation

class L3SDKUtilityLazyLoad
{
    var currentCursor: Int = -1
    var enabled: Bool = true
    var pageSize: Int = -1
    
    init()
    {}
    
    init(withPageSize pSize: Int, andEnabled isEnabled: Bool)
    {
        self.pageSize = pSize
        self.enabled = isEnabled
    }
    
    func nextCursor() -> Int
    {
        if !self.enabled { return -1 }
        
        switch currentCursor
        {
            case -1:
                currentCursor = 0
                break
            case 0:
                currentCursor = self.pageSize
                break
            default:
                currentCursor += pageSize
        }
        return currentCursor
    }
    
    func resetCursor()
    {
        currentCursor = -1
    }
}
