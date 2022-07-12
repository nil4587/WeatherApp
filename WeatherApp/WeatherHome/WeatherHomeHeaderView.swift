//
//  WeatherHomeHeaderView.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 08/07/22.
//

import UIKit

class WeatherHomeHeaderView: UIView {

    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Properties Declaration
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
        
    @IBOutlet private weak var lblMinTempratureTitle: UILabel!
    @IBOutlet private weak var lblCurrentTempratureTitle: UILabel!
    @IBOutlet private weak var lblMaxTempratureTitle: UILabel!
    @IBOutlet private weak var lblMinTemprature: UILabel!
    @IBOutlet private weak var lblCurrentTemprature: UILabel!
    @IBOutlet private weak var lblMaxTemprature: UILabel!

    var view: UIView!
    
    func viewFromNib() -> UIView {
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: "WeatherHomeHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Init
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        view = viewFromNib()
        view.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y,
                            width: self.bounds.width, height: self.bounds.height)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: User-defined methods
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    func set(minTemp: String?,
             maxTemp: String?,
             currentTemp: String?,
             color: UIColor?) {
        self.lblMinTemprature.text = minTemp
        self.lblMaxTemprature.text = maxTemp
        self.lblCurrentTemprature.text = currentTemp
        self.view.backgroundColor = color
    }
}
