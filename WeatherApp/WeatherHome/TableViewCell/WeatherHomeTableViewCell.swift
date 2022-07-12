//
//  WeatherHomeTableViewCell.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 11/07/22.
//

import UIKit

class WeatherHomeTableViewCell: UITableViewCell {

    @IBOutlet private weak var lblDayTitle: UILabel!
    @IBOutlet private weak var lblTemprature: UILabel!
    @IBOutlet private weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func refreshView(with value: (day: String?, icon: UIImage?, temp: String?)) {
        self.lblDayTitle.text = value.day
        self.lblTemprature.text = value.temp
        self.icon.image = value.icon
    }
}
