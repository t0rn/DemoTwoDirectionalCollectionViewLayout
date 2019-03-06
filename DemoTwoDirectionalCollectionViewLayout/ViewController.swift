//
//  ViewController.swift
//  DemoTwoDirectionalCollectionViewLayout
//
//  Created by Alexey Ivanov on 27/02/2019.
//  Copyright © 2019 Alexey Ivanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var colors: [[UIColor]] = {
        let colors = stride(from: 360, through: 0, by: -5)
            .map { (i) -> AnySequence<UIColor> in
                let phase = CGFloat(i) * CGFloat.pi / 180
                return UIColor.rainbowSequence(phase1: 0, phase2: phase, phase3: phase * 2)
        }
        return colors.map {Array($0)}
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

extension ViewController : UICollectionViewDataSource {
    
    //number of sections == number of rows
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return colors.count
    }
    
    //number of items == number of columns
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        
        let color = colors[indexPath.section][indexPath.row]
        cell.backgroundColor = color
        return cell
    }
}
