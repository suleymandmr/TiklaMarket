//
//  ChildViewController.swift
//  TiklaMarket
//
//  Created by eyüp yaşar demir on 18.08.2023.
//

import UIKit
import XLPagerTabStrip

class ChildViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    var childNumber: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = childNumber
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
         return IndicatorInfo(title: "\(childNumber)")
    }

}
