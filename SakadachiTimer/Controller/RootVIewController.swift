//
//  RootVIewController.swift
//
//  Created by Masato Sawada on 2022/11/13.
//

import UIKit

class RootViewController: UIViewController {
    
    
    @IBOutlet weak var customLabel: CustomLabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - 説明用ラベルの設定(パディング：CustomLabelクラスで設定)
        // 丸める
        customLabel.layer.cornerRadius = 10
        customLabel.clipsToBounds = true
        // 枠線
        customLabel.layer.borderColor = UIColor.lightGray.cgColor
        customLabel.layer.borderWidth = 2.0
        // 背景
        customLabel.backgroundColor = UIColor.white
        // autoAdjust
        customLabel.adjustsFontSizeToFitWidth = true
        
        //MARK: - スタートボタンの設定
        // 丸める
        startButton.layer.cornerRadius = 10
        // 枠線
        startButton.layer.borderColor = UIColor.lightGray.cgColor
        startButton.layer.borderWidth = 2.0
        //影
        startButton.layer.shadowColor = UIColor.black.cgColor
        startButton.layer.shadowOpacity = 0.5
        startButton.layer.shadowRadius = 5.0
        
    }
    
    
}
