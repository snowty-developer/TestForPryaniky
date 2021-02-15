//
//  SecondViewController.swift
//  Pods
//
//  Created by Александр Зубарев on 13.02.2021.
//

import UIKit
import RxSwift
import RxCocoa

class SecondViewController: UIViewController {

    var data: DataType? 
    
    @IBOutlet weak var textViewLabel: UILabel!
    @IBOutlet weak var nameViewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    

    private func bind() {
        switch self.data!.name {
        case .hz:
            Observable<String>.just("Обьект \((self.data as! Hz).name)")
                .bind(to: nameViewLabel.rx.text)
            Observable<String>.just((self.data as! Hz).text)
                .bind(to: textViewLabel.rx.text)
        case .picture:
            Observable<String>.just("Обьект \((self.data as! Picture).name)")
                .bind(to: nameViewLabel.rx.text)
            Observable<String>.just((self.data as! Picture).text)
                .bind(to: textViewLabel.rx.text)
        case .variant:
            Observable<String>.just("Обьект c ID \((self.data as! Variants).id)")
                .bind(to: nameViewLabel.rx.text)
            Observable<String>.just((self.data as! Variants).text)
                .bind(to: textViewLabel.rx.text)
        default:
            break
        }
    }
}
