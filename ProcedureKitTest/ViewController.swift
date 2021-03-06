//
//  ViewController.swift
//  ProcedureKitTest
//
//  Created by Joe Levin on 9/18/16.
//  Copyright © 2016 Joe Levin. All rights reserved.
//

import UIKit
import ProcedureKit

class ViewController: UIViewController {
    lazy var getRequest = AlamofireGETOperation()
    lazy var postRequest = AlamofirePOSTOperation()
    let queue = ProcedureQueue()

    
    @IBOutlet weak var POSTView: UITextView!
    @IBOutlet weak var GETView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        queue.maxConcurrentOperationCount = 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.GETView.text = "Loading data..."
        self.POSTView.text = "Loading data..."
        
        if self.getRequest.isFinished || self.postRequest.isFinished {
            self.getRequest = AlamofireGETOperation()
            self.postRequest = AlamofirePOSTOperation()
        }
        
        self.getRequest.addDidFinishBlockObserver { [weak self] (operation, errors) in
            self?.GETView.text = String(describing: operation.JSON)
        }
        
        self.postRequest.addDidFinishBlockObserver { [weak self] (operation, errors) in
            self?.POSTView.text = String(describing: operation.JSON)
        }
        
        queue.addOperation(getRequest)
        queue.addOperation(postRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

