//
//  UIView.swift
//  iosExperiments
//
//  Created by Andrew Ashurow on 1/20/16.
//  Copyright © 2016 Spalmalo. All rights reserved.
//




//Create a new Project in ObjC
//Create a new .swift file
//A popup window will appear and ask "Would You like to configure an Objective-C bridging Header".
//Choose Yes.
//Click on your Xcode Project file
//Click on Build Settings
//Find the Search bar and search for Defines Module.
//Change the value to Yes.
//Search Product Module Name.
//Copy the value (name of your project).
//In App delegate, add the following : #import "YourProjectName-swift.h"

import UIKit
import ObjectiveC

private struct AssociatedKeys {
    static var
    fieldTintAssociationKey     = "customKey.fieldTintAssociation",
    refreshIndicatorInBarKey    = "customKey.refreshIndicatorInBar",
    placeHolderKey              = "customKey.placeHolder"
}

let
ANIMATION_DURATION = 0.3,
IMAGE_ANIMATION_DURATION = 0.05

//MARK: generic
public extension UIView {
    static func CGColorFromRGB(rgbValue: UInt) -> CGColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
            ).CGColor
    }
    static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var placeHolder:UIView? {
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.placeHolderKey) as? UIView
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.placeHolderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func setCustomPlaceHolder(placeHolder:UIView){
        placeHolder.frame = frame
        placeHolder.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
        self.placeHolder = placeHolder
        addSubview(placeHolder)
        hidePlaceHolder()
    }
    func showPlaceHolder(scrollEnabled:Bool = false) {
        (self as? UIScrollView)?.scrollEnabled = scrollEnabled
        placeHolder?.hidden = false
        if let placeHolder = placeHolder{
            bringSubviewToFront(placeHolder)
        }
    }
    func hidePlaceHolder() {
        (self as? UIScrollView)?.scrollEnabled = true
        placeHolder?.hidden = true
        if let placeHolder = placeHolder{
            sendSubviewToBack(placeHolder)
        }
    }
    
    
    public func setZeroHeigh(animated:Bool = false){
        let heighConstr = findHeighConstrant()
        if animated {
            UIView.animateWithDuration(
                ANIMATION_DURATION,
                animations: {[weak self, weak heighConstr] in
                    heighConstr?.constant = 0
                    self?.window?.layoutIfNeeded()
                },
                completion: { [weak self] _ in
                    self?.hidden = true
                }
            )
            return
        }
        
        heighConstr.constant = 0
        
        hidden = true
    }
    func findHeighConstrant() -> NSLayoutConstraint{
        for constraint in constraints {
            if (constraint.firstAttribute == .Height) {
                return constraint
            }
        }
        
        let constrant = NSLayoutConstraint (
            item: self,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: bounds.height
        )
        addConstraint(constrant)
        if #available(iOS 8.0, *) {
            constrant.active = true
        } else {
            // Fallback on earlier versions
        }
        return constrant
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.addAnimation(animation, forKey: "shake")
    }
    func rotateBy180(multiplier:CGFloat = 1){
        UIView.animateWithDuration(ANIMATION_DURATION) {[weak self] in
            if let selfRef = self{
                selfRef.transform = CGAffineTransformRotate(selfRef.transform, 3.1415926 * multiplier)
            }
        }
    }
    
}

extension UIViewController{
    func getVCfromSB(storyBoardID:String, viewControllerID:String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyBoardID, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(viewControllerID)
    }
}

extension UIScrollView {// Dont disable scrolling
    func didRotateScreen(){
        if frame.height != 0 {
            setHeighByContent(true)
        }
    }
    func setHeighByContent(animated:Bool = false) {
        let heighConstr = findHeighConstrant()
        hidden = false
        if animated {
            UIView.animateWithDuration(
                ANIMATION_DURATION,
                animations: {[weak self] in
                    heighConstr.constant = self?.contentSize.height ?? 0
                    self?.window?.layoutIfNeeded()
                },
                completion: {[weak self] bool in
                    heighConstr.constant = self?.contentSize.height ?? 0
                }
            )
            return
        }
        heighConstr.constant = contentSize.height
        
    }
    func toggleHeigh(animated:Bool = false) -> Bool{//Returuns - will be shown
        if frame.height == 0 {
            setHeighByContent(animated)
            return true
        } else {
            setZeroHeigh(animated)
            return false
        }
    }
}

extension UIWebView{
    func setHeighByContent(animated:Bool = false) {
        let heighConstr = findHeighConstrant()
        hidden = false
        if animated {
            UIView.animateWithDuration(
                ANIMATION_DURATION,
                animations: {[weak self] in
                    heighConstr.constant = self?.scrollView.contentSize.height ?? 0
                    self?.window?.layoutIfNeeded()
                },
                completion: {[weak self] bool in
                    heighConstr.constant = self?.scrollView.contentSize.height ?? 0
                }
            )
            return
        }
        heighConstr.constant = scrollView.contentSize.height
        
    }
    func toggleHeigh(animated:Bool = false) -> Bool{//Returuns - will be shown
        if frame.height == 0 {
            setHeighByContent(animated)
            return true
        } else {
            setZeroHeigh(animated)
            return false
        }
    }
}

extension UIRefreshControl {
    func beginRefreshingProgrammatically(){
        if !refreshing {
            if let scrollView = superview as? UIScrollView {
                scrollView.setContentOffset(
                    CGPointMake(0, scrollView.contentOffset.y - frame.size.height),
                    animated: true
                )
            }
            beginRefreshing()
        }
    }
}

extension UITableView {
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {[weak self] in
            if let
                numberOfSections = self?.numberOfSections,
                numberOfRows = self?.numberOfRowsInSection(numberOfSections-1)
                where
                numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self?.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
            
            })
    }
    func scrolToSelectedCell(atScrollPosition scrollPosition: UITableViewScrollPosition = .Middle){
        if let indexPathForSelectedRow = indexPathForSelectedRow {
            scrollToRowAtIndexPath(indexPathForSelectedRow, atScrollPosition: scrollPosition, animated: true)
        }
    }
    func clearSelection() {
        for indexPath in indexPathsForSelectedRows ?? [] {
            deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}

extension UILabel {
    var textInt:Int?{
        set{
            text = (newValue != nil && newValue != 0) ? String(newValue ?? 0) : nil
        }
        get{
            return Int(text ?? "")
        }
    }
    func setAttributedTextOrHideView(text:NSAttributedString?, viewToHide:UIView? = nil){
        var text = text
        let rowIsEmpty = text?.string.isBlank ?? true
        
        text = rowIsEmpty ? nil : text
        if let attributedText = text {
            self.attributedText = attributedText
        } else {
            viewToHide?.setZeroHeigh()
            setZeroHeigh()
        }
    }
    func setTextOrHideView( text:String?, viewToHide:UIView? = nil){
        
        var text = text
        let rowIsEmpty = text?.isBlank ?? true
        text = rowIsEmpty ? nil : text
        if let text = text {
            self.text = text
        } else {
            viewToHide?.setZeroHeigh()
            setZeroHeigh()
        }
    }
}

extension UITextView{
    func setAttributedTextOrHideView(text:NSAttributedString?, viewToHide:UIView? = nil ,SetHeighByContent:Bool = true) -> Bool{
        
        var text = text
        let rowIsEmpty = (text?.string.isBlank ?? true) || text?.string.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet()) == "--"
        
        text = rowIsEmpty ? nil : text
        if let attributedText = text {
            self.attributedText = attributedText
            if SetHeighByContent {
                setHeighByContent()
            }
            return true
        } else {
            viewToHide?.setZeroHeigh()
            setZeroHeigh()
            return false
        }
    }
    func setTextOrHideView( text:String?, viewToHide:UIView? = nil ,SetHeighByContent:Bool = true){
        
        var text = text
        let rowIsEmpty = text?.isBlank ?? true
        text = rowIsEmpty ? nil : text
        if let text = text {
            self.text = text
            if SetHeighByContent {
                setHeighByContent()
            }
        } else {
            viewToHide?.setZeroHeigh()
            setZeroHeigh()
        }
    }
}

extension UIImage {
    func getTintedImage(color:UIColor) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        
        // flip the image
        CGContextScaleCTM(context, 1.0, -1.0)
        CGContextTranslateCTM(context, 0.0, -size.height)
        
        // multiply blend mode
        CGContextSetBlendMode(context, .Multiply)
        
        let rect = CGRectMake(0, 0, size.width, size.height)
        CGContextClipToMask(context, rect, CGImage)
        color.setFill()
        CGContextFillRect(context, rect)
        
        // create uiimage
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    func resizeImage(size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}


extension UISearchBar{
    private var fieldTintColor:UIColor {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.fieldTintAssociationKey) as? UIColor ?? tintColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.fieldTintAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    private var searchBarActivityIndicator:UIActivityIndicatorView {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.refreshIndicatorInBarKey) as? UIActivityIndicatorView ?? UIActivityIndicatorView()
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.refreshIndicatorInBarKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var textField:UITextField? {
        get {
            return valueForKey("searchField") as? UITextField
        }
    }
    func setFieldTextColor(color:UIColor) -> UISearchBar{
        textField?.textColor = color
        return self
    }
    func setFieldTintColor(color:UIColor) -> UISearchBar{
        //Tinting search icon
        let textFieldInsideSearchBar = textField
        let iconView = textFieldInsideSearchBar?.leftView as? UIImageView
        iconView?.image = iconView?.image?.imageWithRenderingMode(.AlwaysTemplate)
        iconView?.tintColor = color
        
        //Tinting clear icon
        let clearButton = textFieldInsideSearchBar?.valueForKey("clearButton") as? UIButton
        let clearImage = clearButton?.imageView?.image
        setImage(
            clearImage?.getTintedImage(color),
            forSearchBarIcon: UISearchBarIcon.Clear,
            state: UIControlState.Normal
        )
        fieldTintColor = color
        
        //Tinting UIActivityIndicatorView
        
        searchBarActivityIndicator = UIActivityIndicatorView()
        
        searchBarActivityIndicator.hidesWhenStopped = true
        searchBarActivityIndicator.color = color
        searchBarActivityIndicator.autoresizingMask = [.FlexibleHeight , .FlexibleWidth]
        textFieldInsideSearchBar?.addSubview(searchBarActivityIndicator)
        return self
    }
    
    func setFieldPlaceHolderTintedText(text:String) -> UISearchBar{
        //Tinting placeholder
        let attributeDict = [NSForegroundColorAttributeName: fieldTintColor]
        textField?.attributedPlaceholder = NSAttributedString(string: text, attributes: attributeDict)
        
        return self
    }    
    func setCancelText(text:String) -> UISearchBar{
        setValue(text, forKey:"_cancelButtonText")
        return self
    }
    
    func stopAnimatingIndicator(){
        searchBarActivityIndicator.stopAnimating()
    }
    func startAnimatingIndicator(){
        searchBarActivityIndicator.startAnimating()
    }
}

@available(iOS 8.0, *)
extension UIAlertController {
    //must call after presentViewController
    func fixTextFields(){
        for textField in textFields ?? [] {
            if let
                container = textField.superview,
                effectView = container.superview?.subviews[0]
            {
                if (effectView.isKindOfClass(UIVisualEffectView) ){
                    container.backgroundColor = UIColor.clearColor()
                    effectView.removeFromSuperview()
                }
            }
        }
    }
}

extension UINavigationController {
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return visibleViewController?.supportedInterfaceOrientations() ?? UIInterfaceOrientationMask.All
    }
}

//MARK: only for iosExperiments
extension UILabel {
    func setCountLeft(sales_limit:Int?,sold:Int?){
        if let
            sales_limit = sales_limit,
            sold = sold {
            setCountOrHide(sales_limit - sold,textIn: "COUNT_LEFT")
        } else {
            setCountOrHide(nil,textIn: "COUNT_LEFT")
        }
        
    }
    func setCountPurchases(value:Int?){
        setCountOrHide(value,textIn: "COUNT_PURCHASES")
    }
    private func setCountOrHide(value:Int?, textIn:String){
        if let value = value {
            if value > 0{
                text        = String( format: textIn.localized, value )
                hidden = false
                return
            }
        }
        hidden = true
    }
}