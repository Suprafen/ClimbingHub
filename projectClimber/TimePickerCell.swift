//
//  TimePickerCell.swift
//  ClimbingHub
//
//  Created by Ivan Pryhara on 5.04.22.
//

import UIKit

protocol TimePickerDelegate {
    func recieveTime(inSeconds time: Int, fromPickerIndexPath indexPathForTitleCell: IndexPath, isSplitPicker: Bool)
}

class TimePickerCell: UITableViewCell {

    
    let timePicker: UIPickerView = {
        let timePicker = UIPickerView()
        return timePicker
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var isSplitPicker: Bool = false
    var indexPath: IndexPath?
    var minutes = 0
    var seconds = 0
    var delegate: TimePickerDelegate?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        timePicker.delegate = self
        timePicker.dataSource = self
        
        timePicker.selectRow(minutes, inComponent: 0, animated: false)
        timePicker.selectRow(seconds, inComponent: 1, animated: false)
        
        self.contentView.addSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        // Configure the view for the selected state
        
        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            timePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            timePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            timePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }
}

extension TimePickerCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0,1:
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) min"
        case 1:
            return "\(row) Sec"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
                minutes = row
        case 1:
            if row == 0 {
                pickerView.selectRow(row + 1, inComponent: 1, animated: true)
                seconds = 1
            } else {
                seconds = row
            }
        default:
            break
        }
        guard let indexPath = self.indexPath else { return }
        delegate?.recieveTime(inSeconds: (minutes * 60) + seconds, fromPickerIndexPath: indexPath, isSplitPicker: isSplitPicker)
    }
}
