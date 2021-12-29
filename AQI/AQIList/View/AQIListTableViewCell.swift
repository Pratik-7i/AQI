//
//  AQIListTableViewCell.swift
//  AQI
//
//  Created by Pratik on 13/12/21.
//

import UIKit

class AQIListTableViewCell: UITableViewCell
{
    @IBOutlet var containerView   : UIView!
    @IBOutlet var colorView       : UIView!
    @IBOutlet var cityNameLabel   : UILabel!
    @IBOutlet var cityAqiLabel    : UILabel!
    @IBOutlet var aqiView         : UIView!
    @IBOutlet var airQualityLabel : UILabel!
    @IBOutlet var timeAgoLable    : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func load(_ cityModel: CityModel)
    {
        self.cityNameLabel.text = cityModel.name
        
        guard let aqiModel = cityModel.aqiHistory.last else { return }
        self.aqiView.backgroundColor = aqiModel.category.color
        self.colorView.backgroundColor = aqiModel.category.color.withAlphaComponent(0.03)
        self.cityAqiLabel.text = aqiModel.aqi.roundToDecimal(2).description
        self.timeAgoLable.text = "Updated " + aqiModel.time.timeAgo()

        let airQualityString = Message.airQualityName + aqiModel.category.name
        let resultString: NSMutableAttributedString = NSMutableAttributedString(string: airQualityString)
        resultString.addAttribute(.foregroundColor, value: aqiModel.category.color, range: NSRange(location: Message.airQualityName.count, length: airQualityString.count-Message.airQualityName.count))
        self.airQualityLabel.attributedText = resultString
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
