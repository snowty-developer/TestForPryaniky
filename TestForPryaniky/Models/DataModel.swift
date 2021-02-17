//
//  DataModel.swift
//  TestForPryaniky
//
//  Created by Александр Зубарев on 14.02.2021.
//

import Foundation
import SwiftyJSON
import RxDataSources
import RxSwift


enum DataName {
    case hz , picture, selector, variant, any
}

protocol DataType {
    var name: DataName { get }
}

struct Hz: DataType {
    let name = DataName.hz
    let text: String
    
    init (text: String) {
        self.text = text
    }
}

struct Picture: DataType {
    let name = DataName.picture
    let url: String
    let text: String
    
    init (url: String, text: String) {
        self.url = url
        self.text = text
    }
}

struct Selector: DataType {
    let name = DataName.selector
    let selectedId: Int
    var data: [Variants]
    
    init (selectedId: Int, data: [JSON]) {
        self.selectedId = selectedId
        self.data = []
        for element in data {
            self.data.append(Variants.init(id: element["id"].intValue, text: element["text"].stringValue))
        }
    }
}

struct Variants: DataType {
    let name = DataName.variant
    let id: Int
    let text: String
}

// MARK: - Создание секций для TableView
struct SectionOfCustomData {
  var header: String
  var items: [DataType]
}

extension SectionOfCustomData: SectionModelType {    
    init(original: SectionOfCustomData, items: [DataType]) {
        self = original
        self.items = items
    }
}


