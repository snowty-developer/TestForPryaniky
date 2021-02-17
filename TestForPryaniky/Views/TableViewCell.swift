//
//  TableViewCell.swift
//  TestForPryaniky
//
//  Created by Александр Зубарев on 15.02.2021.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell (_ item: DataType, _ image: UIImage?) {
        switch item.name {
        case .hz:
            let hz = item as! Hz
            textLabel!.text = hz.text
        case .picture:
            let picture = item as! Picture
            textLabel!.text = picture.text
            imageView!.image = image
        case .variant:
            let variants = item as! Variants
            textLabel!.text = variants.text
        default:
            break
        }
    }

}
