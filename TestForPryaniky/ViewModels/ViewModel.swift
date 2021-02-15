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
    
    init() {
        loadData(completion: { loadingView, loadingData in
            DispatchQueue.global().async {
                    self.loadingView = loadingView
                    self.loadingData = loadingData
                    self.createSection()
//                print(loadingView)
//                print(loadingData)
                }
            }
        )
    }
        

    var image = UIImage()
    var loadingView: [DataName] = []
    var loadingData: [DataType] = []
    var sections: [SectionOfCustomData] = []
    
    func loadData(completion: @escaping ([DataName],[DataType]) -> Void) {
        Alamofire.request("https://pryaniky.com/static/json/sample.json").responseJSON { response in
            if response.result.isSuccess {
                let dataResult = JSON(response.value!)
                
                var loadingData: [DataType] = []
                if let dataArray = dataResult["data"].array {
                    for data in dataArray {
                        switch data["name"].stringValue {
                        case "hz":
                            loadingData.append(Hz.init(text: data["data"]["text"].stringValue))
                        case "picture":
                            loadingData.append(Picture.init(url: data["data"]["url"].stringValue, text: data["data"]["text"].stringValue))
                            self.loadImage(picture: data["data"]["url"].stringValue)
                        case "selector":
                            loadingData.append(Selector.init(selectedId: data["data"]["selectedId"].intValue, data: data["data"]["variants"].arrayValue))
                        default:
                            print("Not found data!")
                        }
                    }
                }
                
                var loadingView: [DataName] = []
                if let viewArray = dataResult["view"].array {
                    for view in viewArray {
                        switch view.stringValue {
                        case "hz":
                            loadingView.append(.hz)
                        case "picture":
                            loadingView.append(.picture)
                        case "selector":
                            loadingView.append(.selector)
                        default:
                            loadingView.append(.any)
                        }
                    }
                }
                completion(loadingView, loadingData)
            }
            else { print("Connection error!") }
        }
    }
    
    func createSection() {
        for view in loadingView {
            switch view {
            case .hz:
                sections.append(SectionOfCustomData.init(header: "hz", items: loadingData.filter{$0.name == .hz}))
            case .picture:
                sections.append(SectionOfCustomData.init(header: "picture", items: loadingData.filter{$0.name == .picture}))
            case .selector:
                let variants = loadingData.filter{$0.name == .selector}.first as! Selector
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
