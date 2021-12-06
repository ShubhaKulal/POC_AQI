//
//  AQITableViewCell.swift
//  AirQualityMonitoring
//
//  Created by techjini on 02/12/21.
//

import UIKit

protocol AQITableCellViewModel {
    var cityName: String {get}
    var aqiValue: String {get}
    var updatedTime: String {get}
    var backgroundColor: UIColor? {get}
}

class AQITableViewCell: UITableViewCell {

    @IBOutlet weak var updatedTimeLabel: UILabel!
    @IBOutlet weak var aqiValueLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configurView(with model: AQITableCellViewModel) {
        cityLabel.text = model.cityName
        aqiValueLabel.text = model.aqiValue
        updatedTimeLabel.text = model.updatedTime
        aqiValueLabel.textColor = model.backgroundColor
        cityLabel.textColor = UIColor.white
        updatedTimeLabel.textColor = UIColor.white
        cardView.backgroundColor = UIColor.gray
        cardView.layer.cornerRadius = 10.0
        self.backgroundColor = UIColor.white
    }
}


