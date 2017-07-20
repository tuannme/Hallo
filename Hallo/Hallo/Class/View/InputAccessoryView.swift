//
//  InputAccessoryView.swift
//  Up+
//
//  Created by Dreamup on 2/24/17.
//  Copyright © 2017 Dreamup. All rights reserved.
//

import UIKit

class InputAccessoryView: UIView {
        
    var inputAcessoryViewFrameChangedBlock : ((CGRect) -> Void)?
    
     var storedFinalCallback: () -> Void = { arg in }
    
    let myContext = UnsafeMutableRawPointer(bitPattern: 8)
    
    var inputAcesssorySuperviewFrame:CGRect{
        return self.superview!.frame
    }
    
    var observerAdded = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if(observerAdded) {
            self.superview?.removeObserver(self, forKeyPath: "frame", context:myContext)
            self.superview?.removeObserver(self, forKeyPath: "center", context:myContext)
        }
    }
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        
        if(observerAdded){
            self.superview?.removeObserver(self, forKeyPath: "frame")
            self.superview?.removeObserver(self, forKeyPath: "center")
        }
        
        newSuperview?.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context:myContext)
        newSuperview?.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.new, context:myContext)
        
        observerAdded = true;
        super.willMove(toSuperview: newSuperview)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if object as AnyObject? === self.superview && (keyPath! == "frame") || keyPath! == "center"{
            self.inputAcessoryViewFrameChangedBlock?((self.superview?.frame)!)
        }
    }
    
    
    override func layoutSubviews() {
        self.inputAcessoryViewFrameChangedBlock?((self.superview?.frame)!)
    }
    
}
