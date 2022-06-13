//
//  CardTableViewCell.swift
//  begateway.framework
//
//  Created by admin on 02.11.2021.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    var cardNumbertitleLabel: UILabel?
    var cardImageView: UIImageView?
    var stateSwitch: UISwitch?
    
    var onChange: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        for view in self.contentView.subviews {
//            print(view.restorationIdentifier)
            
            switch view.restorationIdentifier {
            case "cardNumbertitleLabel":
                self.cardNumbertitleLabel = view as? UILabel
            case "cardImageView":
                self.cardImageView = view as? UIImageView
            case "stateSwitch":
                self.stateSwitch = view as? UISwitch
                self.stateSwitch?.isOn = false
            default:
                print("nil")
            }
        }
        
        self.stateSwitch?.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.onChange?(sender.isOn)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell(card: StoreCard, onChange: ((Bool) -> Void)?, textColor: UIColor? = nil, textFont: UIFont? = nil) {
        self.cardNumbertitleLabel?.text = "\(card.first1)*** **** **** \(card.last4)"
        
        if let image = MainHelper.getCardImageByName(brandName: card.brand ?? "", bundle: Bundle(for: type(of: self))) {
            self.cardImageView?.image = image
        }
        
        self.stateSwitch?.isOn = card.isActive
        self.onChange = onChange
        
        if textColor != nil {
            self.cardNumbertitleLabel?.textColor = textColor
        }
        
        if textFont != nil {
            self.cardNumbertitleLabel?.font = textFont
        }
    }
    
}
