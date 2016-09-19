//
//  DependencyViewController.swift
//  ProcedureKitTest
//
//  Created by Joe Levin on 9/18/16.
//  Copyright © 2016 Joe Levin. All rights reserved.
//

import Foundation
import UIKit
import ProcedureKit

class DependencyViewController: UIViewController {
    @IBOutlet weak var GETView: UITextView!
    @IBOutlet weak var POSTView: UITextView!
    
    lazy var getRequest = AlamofireGETOperation()
    lazy var postRequest = AlamofirePOSTOperation()
    var delayOp = DelayProcedure(by: 2)
    let queue = ProcedureQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queue.maxConcurrentOperationCount = 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        self.GETView.text = "Loading data..."
        self.POSTView.text = "Loading data..."
        
        if self.getRequest.isFinished || self.postRequest.isFinished || self.delayOp.isFinished {
            self.getRequest = AlamofireGETOperation()
            self.postRequest = AlamofirePOSTOperation()
            self.delayOp = DelayProcedure(by: 2)
       }
        
        self.getRequest.addDidFinishBlockObserver { [weak self] (operation, errors) in
            self?.GETView.text = String(describing: operation.JSON)
        }
        
        self.postRequest.addDidFinishBlockObserver { [weak self] (operation, errors) in
            self?.POSTView.text = String(describing: operation.JSON)
        }
        
        self.getRequest.addDependency(self.delayOp)
        self.getRequest.addDependency(self.postRequest)
        
        queue.add(operations: getRequest, postRequest, delayOp)

    }
}
