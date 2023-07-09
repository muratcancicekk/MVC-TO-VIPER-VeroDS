//
//  ResultTableViewCell.swift
//  VeroDS
//
//  Created by Berkan Gezgin on 6.04.2023.
//

import UIKit

final class ResultTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var cellV: UIView!
    @IBOutlet weak var textV: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        textV.textColor = .gray
        textV.backgroundColor = UIColor.clear
        textV.isUserInteractionEnabled = false
        textV.font = UIFont(name: "Helvetica-Bold", size: 16)
        textV.delegate = self
        
        cellV.layer.cornerRadius = 10
        selectionStyle  = .none

    }
    
    func setupUI(data: HomeEntities.Response?) {
        var resultText: String?
        let currentResult = data
        
        if currentResult?.title != nil { resultText = "\(String(describing: currentResult?.title ?? ""))\n" }
        if currentResult?.task != nil { resultText = "\(String(describing: currentResult?.task ?? ""))\n" }
        if currentResult?.description != nil { resultText = "\(String(describing: currentResult?.description ?? ""))" }
        if currentResult?.colorCode != nil { cellV.backgroundColor = UIColor().colorFromHex(hexString: currentResult?.colorCode ?? "") }
        
        if resultText == "" {
            resultText = "Sorry, there's no information that can be shown right now"
        }
        
       textV.text = "\(resultText!)"
        
    }
}
