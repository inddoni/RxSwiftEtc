//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by 최인정 on 2021/03/29.
//  Copyright © 2021 iamchiwon. All rights reserved.
//

import Foundation

class MenuListViewModel {
    var menus: [Menu] = [
        Menu(name: "튀김1", price: 500, count: 0),
        Menu(name: "튀김2", price: 400, count: 0),
        Menu(name: "튀김3", price: 300, count: 0),
        Menu(name: "튀김4", price: 600, count: 0)
    ]
    
    var itemsCount: Int = 5
    var totalPrice: Int = 10000
}
