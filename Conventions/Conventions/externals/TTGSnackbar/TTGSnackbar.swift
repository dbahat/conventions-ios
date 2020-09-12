//
//  TTGSnackbar.swift
//  TTGSnackbar
//
//  Created by zekunyan on 15/10/4.
//  Copyright © 2015年 tutuge. All rights reserved.
//
// NOTE -
// Changes from the original code:
// 1. Updated constraints to support RTL
// 2. Switched the SlideFromBottomBackToBottom animation with SlideFromTopBackToTop
// 3. Accepting the superView as input instead of taking the root screen view, so the snackbar
// can appear under top bars or above tab bars.
// 4. Removed the original view margins and added side margin to the messageLabel.

import UIKit
import Darwin

// MARK: -
// MARK: Enum

/**
Snackbar display duration types.

- Short:   1 second
- Middle:  3 seconds
- Long:    5 seconds
- Forever: Not dismiss automatically. Must be dismissed manually.
*/
public enum TTGSnackbarDuration: TimeInterval {
    case short = 1.0
    case middle = 3.0
    case long = 5.0
    case forever = 9999999999.0 // Must dismiss manually.
}

/**
 Snackbar animation types.
 
 - FadeInFadeOut:               Fade in to show and fade out to dismiss.
 - SlideFromBottomToTop:        Slide from the bottom of screen to show and slide up to dismiss.
 - SlideFromTopBackToTop: Slide from the bottom of screen to show and slide back to bottom to dismiss.
 - SlideFromLeftToRight:        Slide from the left to show and slide to rigth to dismiss.
 - SlideFromRightToLeft:        Slide from the right to show and slide to left to dismiss.
 - Flip:                        Flip to show and dismiss.
 */
public enum TTGSnackbarAnimationType {
    case fadeInFadeOut
    case slideFromBottomToTop
    case slideFromTopBackToTop
    case slideFromLeftToRight
    case slideFromRightToLeft
    case flip
}

open class TTGSnackbar: UIView {
    // MARK: -
    // MARK: Class property.
    
    /// Animation duration.
    fileprivate static let snackbarAnimationDuration: TimeInterval = 0.3
    
    /// Snackbar height.
    fileprivate static let snackbarHeight: CGFloat = 44
    
    /// Snackbar margin to the bottom of screen.
    fileprivate static let snackbarBottomMargin: CGFloat = 0
    
    /// Snackbar margin to the left and right.
    fileprivate static let snackbarHorizonMargin: CGFloat = 0
    
    /// Snackbar action button width.
    fileprivate static let snackbarActionButtonWidth: CGFloat = 64
    
    // MARK: -
    // MARK: Typealias
    
    /// Action callback closure definition.
    public typealias TTGActionBlock = (_ snackbar:TTGSnackbar) -> Void
    
    /// Dismiss callback closure definition.
    public typealias TTGDismissBlock = (_ snackbar:TTGSnackbar) -> Void
    
    // MARK: -
    // MARK: Public property.
    
    /// Action callback.
    open var actionBlock: TTGActionBlock? = nil
    
    /// Dismiss callback.
    open var dismissBlock: TTGDismissBlock? = nil
    
    /// Snackbar display duration. Default is Short - 1 second.
    open var duration: TTGSnackbarDuration = TTGSnackbarDuration.short
    
    /// Snackbar animation type. Default is SlideFromTopBackToTop.
    open var animationType: TTGSnackbarAnimationType = TTGSnackbarAnimationType.slideFromTopBackToTop
    
    open var superView: UIView?;
    
    /// Main text shown on the snackbar.
    open var message: String = "" {
        didSet {
            self.messageLabel.text = message
        }
    }
    
    /// Message text color. Default is white.
    @objc open dynamic var messageTextColor: UIColor = UIColor.white {
        didSet {
            self.messageLabel.textColor = messageTextColor
        }
    }
    
    /// Message text font. Default is Bold system font (14).
    @objc open dynamic var messageTextFont: UIFont = UIFont.boldSystemFont(ofSize: 14) {
        didSet {
            self.messageLabel.font = messageTextFont
        }
    }
    
    /// Message text alignment. Default is left
    @objc open dynamic var messageTextAlign: NSTextAlignment = .left {
        didSet {
            self.messageLabel.textAlignment = messageTextAlign
        }
    }
    
    /// Action button title.
    @objc open dynamic var actionText: String = "" {
        didSet {
            self.actionButton.setTitle(actionText, for: UIControl.State())
        }
    }
    
    /// Action button title color. Default is white.
    @objc open dynamic var actionTextColor: UIColor = UIColor.white {
        didSet {
            actionButton.setTitleColor(actionTextColor, for: UIControl.State())
        }
    }
    
    /// Action text font. Default is Bold system font (14).
    @objc open dynamic var actionTextFont: UIFont = UIFont.boldSystemFont(ofSize: 14) {
        didSet {
            self.actionButton.titleLabel?.font = actionTextFont
        }
    }
    
    // MARK: -
    // MARK: Private property.
    
    fileprivate var messageLabel: UILabel!
    fileprivate var seperateView: UIView!
    fileprivate var actionButton: UIButton!
    fileprivate var activityIndicatorView: UIActivityIndicatorView!
    
    /// Timer to dismiss the snackbar.
    fileprivate var dismissTimer: Timer? = nil
    
    // Constraints.
    fileprivate var centerXConstraint: NSLayoutConstraint? = nil
    fileprivate var topMarginConstraint: NSLayoutConstraint? = nil
    fileprivate var actionButtonWidthConstraint: NSLayoutConstraint? = nil
    
    // MARK: -
    // MARK: Init
    
    /**
    Show a single message like a Toast.
    
    - parameter message:  Message text.
    - parameter duration: Duration type.
    
    - returns: Void
    */
    public init(message: String, duration: TTGSnackbarDuration, superView: UIView?) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.duration = duration
        self.message = message
        self.superView = superView;
        configure()
    }
    
    /**
     Show a message with action button.
     
     - parameter message:     Message text.
     - parameter duration:    Duration type.
     - parameter actionText:  Action button title.
     - parameter actionBlock: Action callback closure.
     
     - returns: Void
     */
    public init(message: String, duration: TTGSnackbarDuration, actionText: String, actionBlock: @escaping TTGActionBlock) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.duration = duration
        self.message = message
        self.actionText = actionText
        self.actionBlock = actionBlock
        configure()
    }
    
    /**
     Show a custom message with action button.
     
     - parameter message:          Message text.
     - parameter duration:         Duration type.
     - parameter actionText:       Action button title.
     - parameter messageFont:      Message label font.
     - parameter actionButtonFont: Action button font.
     - parameter actionBlock:      Action callback closure.
     
     - returns: Void
     */
    public init(message: String, duration: TTGSnackbarDuration, actionText: String, messageFont: UIFont, actionTextFont: UIFont, actionBlock: @escaping TTGActionBlock) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.duration = duration
        self.message = message
        self.actionText = actionText
        self.actionBlock = actionBlock
        self.messageTextFont = messageFont
        self.actionTextFont = actionTextFont
        configure()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Public methods.
    
    /**
    Show the snackbar.
    */
    open func show() {
        // Only show once
        if self.superview != nil {
            return
        }
        
        // Create dismiss timer
        dismissTimer = Timer.scheduledTimer(timeInterval: duration.rawValue, target: self, selector: #selector(TTGSnackbar.dismiss), userInfo: nil, repeats: false)
        
        // Show or hide action button
        actionButton.isHidden = actionText.isEmpty || actionBlock == nil
        seperateView.isHidden = actionButton.isHidden
        actionButtonWidthConstraint?.constant = actionButton.isHidden ? 0 : TTGSnackbar.snackbarActionButtonWidth
        
        if let superView = self.superView {
            superView.addSubview(self)
            
            // Snackbar height constraint
            let heightConstraint: NSLayoutConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: TTGSnackbar.snackbarHeight)
            
            // Snackbar width constraint
            let widthConstraint: NSLayoutConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: superView.bounds.width - 2 * TTGSnackbar.snackbarHorizonMargin)
            
            // Center X constraint
            centerXConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
            
            // Bottom margin constraint
            topMarginConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superview, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            
            // Add constraints
            self.addConstraint(heightConstraint)
            self.addConstraint(widthConstraint)
            superView.addConstraint(topMarginConstraint!)
            superView.addConstraint(centerXConstraint!)
            
            // Show
            showWithAnimation()
        }
    }
    
    /**
     Dismiss the snackbar manually.
     */
    @objc open func dismiss() {
        // On main thread
        DispatchQueue.main.async {
            () -> Void in
            self.dismissAnimated(true)
        }
    }
    
    // MARK: -
    // MARK: Private methods.
    
    /**
    Init configuration.
    */
    fileprivate func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        
        messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = UIColor.white
        messageLabel.font = messageTextFont
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        messageLabel.numberOfLines = 2
        messageLabel.textAlignment = NSTextAlignment.left
        messageLabel.text = message
        self.addSubview(messageLabel)
        
        actionButton = UIButton()
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.backgroundColor = UIColor.clear
        actionButton.titleLabel?.font = actionTextFont
        actionButton.setTitle(actionText, for: UIControl.State())
        actionButton.setTitleColor(UIColor.white, for: UIControl.State())
        actionButton.addTarget(self, action: #selector(TTGSnackbar.doAction), for: UIControl.Event.touchUpInside)
        self.addSubview(actionButton)
        
        seperateView = UIView()
        seperateView.translatesAutoresizingMaskIntoConstraints = false
        seperateView.backgroundColor = UIColor.gray
        self.addSubview(seperateView)
        
        activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.stopAnimating()
        self.addSubview(activityIndicatorView)
        
        // Add constraints
        let hConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[messageLabel]-snackbarHorizonMargin-|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: ["snackbarHorizonMargin": 10],
            views: ["messageLabel": messageLabel!, "seperateView": seperateView!, "actionButn": actionButton!])
        
        let vConstraintsForMessageLabel: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[messageLabel]-|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 10),
            metrics: nil,
            views: ["messageLabel": messageLabel])
        
        let vConstraintsForSeperateView: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[seperateView]-|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: ["seperateView": seperateView])
        
        let vConstraintsForActionButton: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[actionButton]-|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: ["actionButton": actionButton])
        
        actionButtonWidthConstraint = NSLayoutConstraint.init(
            item: actionButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: TTGSnackbar.snackbarActionButtonWidth)
        
        let vConstraintsForActivityIndicatorView: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(2)-[activityIndicatorView]-(2)-|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: ["activityIndicatorView": activityIndicatorView])
        
        let hConstraintsForActivityIndicatorView: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[activityIndicatorView(activityIndicatorWidth)]-(2)-|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: ["activityIndicatorWidth": TTGSnackbar.snackbarHeight - 4],
            views: ["activityIndicatorView": activityIndicatorView])
        
        self.addConstraints(hConstraints)
        self.addConstraints(vConstraintsForMessageLabel)
        self.addConstraints(vConstraintsForSeperateView)
        self.addConstraints(vConstraintsForActionButton)
        self.addConstraints(vConstraintsForActivityIndicatorView)
        self.addConstraints(hConstraintsForActivityIndicatorView)
        actionButton.addConstraint(actionButtonWidthConstraint!)
    }
    
    /**
     Invalid the dismiss timer.
     */
    fileprivate func invalidDismissTimer() {
        dismissTimer?.invalidate()
        dismissTimer = nil
    }
    
    /**
     Dismiss.
     
     - parameter animated: If dismiss with animation.
     */
    fileprivate func dismissAnimated(_ animated: Bool) {
        invalidDismissTimer()
        activityIndicatorView.stopAnimating()
        
        if !animated {
            dismissBlock?(self)
            self.removeFromSuperview()
            return
        }
        
        var animationBlock: (() -> Void)? = nil
        
        switch animationType {
        case .fadeInFadeOut:
            animationBlock = {
                self.alpha = 0.0
            }
        case .slideFromTopBackToTop:
            topMarginConstraint?.constant = -TTGSnackbar.snackbarHeight
        case .slideFromBottomToTop:
            animationBlock = {
                self.alpha = 0.0
            }
            topMarginConstraint?.constant = -TTGSnackbar.snackbarHeight - TTGSnackbar.snackbarBottomMargin
        case .slideFromLeftToRight:
            centerXConstraint?.constant = superview!.bounds.width
        case .slideFromRightToLeft:
            centerXConstraint?.constant = -superview!.bounds.width
        case .flip:
            animationBlock = {
                self.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi / 2), 1, 0, 0)
            }
        }
        
        self.setNeedsLayout()
        UIView.animate(withDuration: TTGSnackbar.snackbarAnimationDuration,
            delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: UIView.AnimationOptions.curveEaseIn,
            animations: {
                () -> Void in
                animationBlock?()
                self.superView?.layoutIfNeeded()
            }) {
                (finished) -> Void in
                self.dismissBlock?(self)
                self.removeFromSuperview()
        }
    }
    
    /**
     Show.
     */
    fileprivate func showWithAnimation() {
        var animationBlock: (() -> Void)? = nil
        
        switch animationType {
        case .fadeInFadeOut:
            topMarginConstraint?.constant = -TTGSnackbar.snackbarBottomMargin
            self.alpha = 0.0
            animationBlock = {
                self.alpha = 1.0
            }
        case .slideFromTopBackToTop, .slideFromBottomToTop:
            // Init
            topMarginConstraint?.constant = -TTGSnackbar.snackbarHeight
            self.superview?.layoutIfNeeded()
            // Animation
            topMarginConstraint?.constant = TTGSnackbar.snackbarBottomMargin
        case .slideFromLeftToRight:
            // Init
            centerXConstraint?.constant = -superview!.bounds.width
            topMarginConstraint?.constant = -TTGSnackbar.snackbarBottomMargin
            self.superview?.layoutIfNeeded()
            // Animation
            centerXConstraint?.constant = 0
        case .slideFromRightToLeft:
            // Init
            centerXConstraint?.constant = superview!.bounds.width
            topMarginConstraint?.constant = -TTGSnackbar.snackbarBottomMargin
            self.superview?.layoutIfNeeded()
            // Animation
            centerXConstraint?.constant = 0
        case .flip:
            // Init
            topMarginConstraint?.constant = -TTGSnackbar.snackbarBottomMargin
            self.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi / 2), 1, 0, 0)
            self.superview?.layoutIfNeeded()
            // Animation
            animationBlock = {
                self.layer.transform = CATransform3DMakeRotation(0, 1, 0, 0)
            }
        }
        
        self.setNeedsLayout()
        
        UIView.animate(withDuration: TTGSnackbar.snackbarAnimationDuration,
            delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: UIView.AnimationOptions(),
            animations: {
                () -> Void in
                animationBlock?()
                self.superview?.layoutIfNeeded()
            }, completion: nil)
    }
    
    /**
     Action button.
     */
    @objc func doAction() {
        // Call action block first
        actionBlock?(self)
        
        // Show activity indicator
        if duration == TTGSnackbarDuration.forever && actionButton.isHidden == false {
            actionButton.isHidden = true
            seperateView.isHidden = true
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
        } else {
            dismissAnimated(true)
        }
    }
}
