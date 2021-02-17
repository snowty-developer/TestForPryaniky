//
//  ViewModel.swift
//  TestForPryaniky
//
//  Created by Александр Зубарев on 13.02.2021.
//

import Foundation
import SwiftyJSON
import Alamofire
import RxSwift

class ViewModel {

    var image = UIImage()
    var loadingView: [DataName] = []
    var loadingData: [DataType] = []
    var sections: [SectionOfCustomData] = []
    
    
    func loadData(completion: @escaping ([DataName],[DataType]) -> Void) {
        Alamofire.request("https://pryaniky.com/static/json/sample.json").responseJSON { response in
            if response.result.isSuccess {
                let dataResult = JSON(response.value!)
                
                if let dataArray = dataResult["data"].array {
                    for data in dataArray {
                        switch data["name"].stringValue {
                        case "hz":
                            self.loadingData.append(Hz.init(text: data["data"]["text"].stringValue))
                        case "picture":
                            self.loadingData.append(Picture.init(url: data["data"]["url"].stringValue, text: data["data"]["text"].stringValue))
                            self.loadImage(picture: data["data"]["url"].stringValue)
                        case "selector":
                            self.loadingData.append(Selector.init(selectedId: data["data"]["selectedId"].intValue, data: data["data"]["variants"].arrayValue))
                        default:
                            print("Not found data!")
                        }
                    }
                }
                
                if let viewArray = dataResult["view"].array {
                    for view in viewArray {
                        switch view.stringValue {
                        case "hz":
                            self.loadingView.append(.hz)
                        case "picture":
                            self.loadingView.append(.picture)
                        case "selector":
                            self.loadingView.append(.selector)
                        default:
                            self.loadingView.append(.any)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(self.loadingView, self.loadingData)
                }
            }
            else { print("Connection error!") }
        }
    }
    
    func createSection(_ datas: [DataType], _ views: [DataName]) {
        for view in views {
            switch view {
            case .hz:
                sections.append(SectionOfCustomData.init(header: "hz", items: datas.filter{$0.name == .hz}))
            case .picture:
                sections.append(SectionOfCustomData.init(header: "picture", items: datas.filter{$0.name == .picture}))
            case .selector:
                let variants = datas.filter{$0.name == .selector}.first as! Selector
                sections.append(SectionOfCustomData.init(header: "selector", items: variants.data))
            default:
                continue
            }
        }
    }
    
    func loadImage(picture: String) {
            if let data = try? Data(contentsOf: URL(string: picture)!) {
                if let image = UIImage(data: data) {
                    self.image = image
                }
            }
    }
}
