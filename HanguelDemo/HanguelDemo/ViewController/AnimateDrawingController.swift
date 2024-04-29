//
//  AnimateDrawingController.swift
//  HanguelDemo
//
//  Created by 박형환 on 4/18/24.
//

import UIKit
import SwiftHangeul
import Combine

public final class AnimateDrawingController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AnimateDrawingController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension AnimateDrawingController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
