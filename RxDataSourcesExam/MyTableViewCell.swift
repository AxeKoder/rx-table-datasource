//
//  MyTableViewCell.swift
//  RxDataSourcesExam
//
//  Created by Daeho Park on 2023/09/17.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    static let identity: String = "MyTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(item: MyModel) {
        self.titleLabel.text = item.message
    }

}
