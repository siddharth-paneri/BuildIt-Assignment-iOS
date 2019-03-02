//
//  SuperViewController.swift
//  Weather
//
//  Created by Siddharth Paneri on 28/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import UIKit


fileprivate let TAG_LOADING_VIEW: Int = 999
fileprivate let HEIGHT_LOADING_VIEW: CGFloat = 90
fileprivate let PADDING_MESSAGE_LABEL: CGFloat = 10
fileprivate let HEIGHT_LABEL_MESSAGE: CGFloat = 40
fileprivate let WIDTH_ACTIVITY_VIEW: CGFloat = 30

class SuperViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /** Default viewController cann not rotate to other orientations */
    @objc func canRotate()-> Bool {
        return false
    }

    /** Show error alert box */
    func showError(withTitle title: String, message : String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    /** Show loading view */
    func showLoadingView(with message: String) {
        DispatchQueue.main.async {
            var view_LoadingContainer = UIApplication.shared.keyWindow?.viewWithTag(TAG_LOADING_VIEW)
            if view_LoadingContainer != nil {
                view_LoadingContainer?.removeFromSuperview()
                view_LoadingContainer = nil
            }
            view_LoadingContainer = UIView()
            view_LoadingContainer?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            view_LoadingContainer?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            view_LoadingContainer?.alpha = 1.0
            view_LoadingContainer?.tag = TAG_LOADING_VIEW
            
            let messagelabel = UILabel(frame: CGRect(x: PADDING_MESSAGE_LABEL, y: (view_LoadingContainer!.frame.size.height-HEIGHT_LABEL_MESSAGE)/2, width: self.view.frame.size.width - PADDING_MESSAGE_LABEL*2, height: HEIGHT_LABEL_MESSAGE))
            messagelabel.backgroundColor = UIColor.clear
            messagelabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            messagelabel.textColor = UIColor.white
            messagelabel.textAlignment = NSTextAlignment.center
            messagelabel.numberOfLines = 0
            messagelabel.text = message
            view_LoadingContainer?.addSubview(messagelabel)
            
            let activity = UIActivityIndicatorView(style: .whiteLarge)
            activity.frame = CGRect(x: (self.view.frame.size.width-WIDTH_ACTIVITY_VIEW)/2, y: messagelabel.frame.origin.y+messagelabel.frame.size.height+HEIGHT_LABEL_MESSAGE, width: WIDTH_ACTIVITY_VIEW, height: WIDTH_ACTIVITY_VIEW)
            activity.hidesWhenStopped = true
            activity.startAnimating()
            view_LoadingContainer?.addSubview(activity)
            
//            UIApplication.shared.keyWindow?.addSubview(view_LoadingContainer!)
            self.view.addSubview(view_LoadingContainer!)
            
        }
    }
    
    /** Can be used to fide offline view from top of screen */
    @objc func hideLoadingView() {
        DispatchQueue.main.async {
            var view_LoadingContainer = UIApplication.shared.keyWindow?.viewWithTag(TAG_LOADING_VIEW)
            if view_LoadingContainer != nil {
                view_LoadingContainer?.removeFromSuperview()
                view_LoadingContainer = nil
            }
        }
        
    }

}
