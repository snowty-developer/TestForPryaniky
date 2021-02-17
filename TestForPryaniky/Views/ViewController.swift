//
//  ViewController.swift
//  TestForPryaniky
//
//  Created by Александр Зубарев on 12.02.2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var viewModel = ViewModel() 
    let disposeBag = DisposeBag()
    let cellID = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(TableViewCell.self, forCellReuseIdentifier: cellID)
        
        viewModel.loadData {view, data in
            self.viewModel.createSection(data, view)
            self.bind()
        }
    }
    
    
    private func bind() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(
          configureCell: { dataSource, tableView, indexPath, item in
            var cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
            
            if cell.isEqual(nil) {
                cell = UITableViewCell(style: .default, reuseIdentifier: self.cellID)
            }
            
            switch item.name {
            case .hz:
                let hz = item as! Hz
                cell.textLabel!.text = hz.text
            case .picture:
                let picture = item as! Picture
                cell.textLabel!.text = picture.text
                cell.imageView!.image = self.viewModel.image
            case .variant:
                let variants = item as! Variants
                cell.textLabel!.text = variants.text
            default:
                break
            }
            return cell
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
          return dataSource.sectionModels[index].header
        }
        
        Observable.just(self.viewModel.sections)
          .bind(to: table.rx.items(dataSource: dataSource))
          .disposed(by: disposeBag)
        
        table.rx.modelSelected(DataType.self)
        .subscribe(onNext: {[weak self] value in
            let secondVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "secondView") as! SecondViewController
            secondVC.data = value
            self?.present(secondVC, animated: true, completion: nil)
        })
        .disposed(by: disposeBag)
    }
}



