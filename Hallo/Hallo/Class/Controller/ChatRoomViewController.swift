//
//  ChatRoomViewController.swift
//  Hallo
//
//  Created by Dreamup on 7/20/17.
//  Copyright © 2017 Dreamup. All rights reserved.
//

import UIKit


class ChatRoomViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate {
    
    //MARK: - VARIABLE
    let INPUT_VIEW_MAX_HEIGHT:CGFloat = 70
    let BOTTOM_MARGIN:CGFloat = 0
    let INPUT_SIZE_MIN:CGFloat = 40
    let LINE_HEIGHT:CGFloat = 22.5
    
    var arrMessage:[String] = []
    var memberId:String!
    var isKeyboardBlock = false
    var isKeyboardVisiable = false
    
    @IBOutlet weak var inputViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tbView: UITableView! // table contain message
    @IBOutlet weak var listenView: UIView! // view fake layer over form type message -> listen event touch to show keyboard
    @IBOutlet weak var messageLb: UILabel! // label contain message content to show when keyboard hidden
    
    @IBOutlet weak var keyboardSpaceBottomConstraint: NSLayoutConstraint! // space from input view to bottom
    @IBOutlet weak var inputTv: UITextView! // view to user typing message
    
    @IBOutlet weak var typingMsgView: UIView! // view contain inputView, sendMsg btn, camera btn, art btn, paint btn
    @IBOutlet weak var typingLeadingSpaceContraint: NSLayoutConstraint! // space from inputView to leading
    @IBOutlet weak var mediaMsgLeadingSpaceConstraint: NSLayoutConstraint! // space from media view to leading
    
    var accessoryView:InputAccessoryView?// custom input accessory view
    
    //MARK: OVERRIDE METHOD
    override var shouldAutorotate: Bool {
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // register event keyboard show, hidden
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        // add tap gesture tableView to hidden keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapTableView))
        tbView.isUserInteractionEnabled = true
        tbView.addGestureRecognizer(tapGesture)
        
        // adđ gesture to listen event should show keyboard
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.didTouchOnInputView))
        self.listenView.isUserInteractionEnabled = true
        self.listenView.addGestureRecognizer(gesture)
        
        // set up UI typingMsgView
        typingMsgView.layer.cornerRadius = 10
        typingMsgView.clipsToBounds = true
        typingMsgView.layer.borderColor = UIColor.lightGray.cgColor
        typingMsgView.layer.borderWidth = 1
        
        // set up table View attribute
        tbView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive // enable interaction when swipe change keyboard height
        tbView.rowHeight = UITableViewAutomaticDimension //auto cell height
        tbView.estimatedRowHeight = 40 // minimum row hight
        
        // set up keyboard auto resize follow swipe in screen
        accessoryView = InputAccessoryView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:self.INPUT_VIEW_MAX_HEIGHT))
        accessoryView?.isUserInteractionEnabled = false
        self.inputTv.inputAccessoryView = accessoryView
        self.inputTv.isUserInteractionEnabled = true
        self.inputTv.delegate = self;
        accessoryView?.inputAcessoryViewFrameChangedBlock = {
            (inputAccessoryViewFrame) -> Void in
            
            if !self.isKeyboardBlock{
                let value = self.view.frame.height - inputAccessoryViewFrame.minY - (self.inputTv.inputAccessoryView?.frame.height)! + self.BOTTOM_MARGIN
                self.keyboardSpaceBottomConstraint.constant = max(self.BOTTOM_MARGIN, value);
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: SELECTOR
    func didTapTableView(){
        isKeyboardBlock = false
        if isKeyboardVisiable{
            inputTv.resignFirstResponder()
        }else{
            UIView .animate(withDuration: 0.25, animations: {
                self.keyboardSpaceBottomConstraint.constant =  self.BOTTOM_MARGIN
                self.view.layoutIfNeeded()
            })
            setUIWhenKeyboardHidden()
        }
        
    }
    
    func didTouchOnInputView(){
        isKeyboardBlock = false
        if(keyboardSpaceBottomConstraint.constant == 0 && listenView.isHidden == false){
            self.inputTv.becomeFirstResponder()
        }
        
        self.listenView.isHidden = true

        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            self.typingLeadingSpaceContraint.constant = 60
            self.mediaMsgLeadingSpaceConstraint.constant = -150
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        autoResizeTypingTextView()
    }
    
    
    //MARK: TEXT VIEW DELEGATE
    func textViewDidChange(_ textView: UITextView) {
        
        if(self.mediaMsgLeadingSpaceConstraint.constant == 0){
            self.listenView.isHidden = true
            UIView .animate(withDuration: 0.2, animations: {
                self.typingLeadingSpaceContraint.constant = 60
                self.mediaMsgLeadingSpaceConstraint.constant = -150
                self.view.layoutIfNeeded()
            })
            
        }
        autoResizeTypingTextView()
    }
    
    func autoResizeTypingTextView() {
        
        let message = inputTv.text
        let font = UIFont (name: "Helvetica Neue", size: 17)
        let minSize = "A".heightWithConstrainedWidth(width: inputTv.frame.width, font: font!)
        let height = message?.heightWithConstrainedWidth(width: inputTv.frame.width, font: font!)
        
        let numberLine = Int(height!/minSize)
        
        if(numberLine >= 5){
            self.inputTv.isScrollEnabled = true
        }else{
            self.inputViewHeightConstraint.constant = INPUT_SIZE_MIN + LINE_HEIGHT*CGFloat((numberLine-1))
            self.inputTv.isScrollEnabled = false
        }
    }
    
    //MARK: KEYBOARD NOTIFICATION
    func keyboardWillShow(notification:NSNotification){
        isKeyboardVisiable = true
    }
    
    func keyboardWillHide(notification:NSNotification){
        isKeyboardVisiable = false
        setUIWhenKeyboardHidden()
    }
    
    func setUIWhenKeyboardHidden(){
        if(self.inputTv.text.characters.count == 0){
            self.listenView.isHidden = false
            UIView .animate(withDuration: 0.2, animations: {
                self.typingLeadingSpaceContraint.constant = 150
                self.mediaMsgLeadingSpaceConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    //MARK: ACTION BUTTON
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func showMediaMessageAction(_ sender: Any) {
        
        isKeyboardBlock = true
        inputTv.resignFirstResponder()
        
        self.inputViewHeightConstraint.constant = INPUT_SIZE_MIN
        messageLb.text = inputTv.text.characters.count > 0 ? inputTv.text : "Say something ..."
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            self.typingLeadingSpaceContraint.constant = 150
            self.mediaMsgLeadingSpaceConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)

        
        self.listenView.isHidden = false
        
    }
    
    @IBAction func artAction(_ sender: Any) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            self.keyboardSpaceBottomConstraint.constant = Utils.getKeyboardHeight()
            self.typingLeadingSpaceContraint.constant = 150
            self.mediaMsgLeadingSpaceConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            self.keyboardSpaceBottomConstraint.constant = Utils.getKeyboardHeight()
            self.typingLeadingSpaceContraint.constant = 150
            self.mediaMsgLeadingSpaceConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func paintAction(_ sender: Any) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            self.keyboardSpaceBottomConstraint.constant = Utils.getKeyboardHeight()
            self.typingLeadingSpaceContraint.constant = 150
            self.mediaMsgLeadingSpaceConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
 
    
    @IBAction func sendMessageAction(_ sender: Any) {
        
        guard let message = inputTv.text else{return}
        if message.isEmtyContent(){ return }
        
        arrMessage.append(message)
        inputTv.text = ""
        autoResizeTypingTextView()
        tbView.reloadData()
    }
    
    
    //MARK: TABLE VIEW DELEGATE - DATA SOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMessage.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = arrMessage[indexPath.row]
        
        //let cell = tbView.dequeueReusableCell(withIdentifier: "MsgOutGoingCell") as! MsgOutGoingCell
        
        let cell = tbView.dequeueReusableCell(withIdentifier: "MsgInCommingCell") as! MsgInCommingCell
        cell.messageLb.text = message
        return cell
        
    }
    
    
    
}
