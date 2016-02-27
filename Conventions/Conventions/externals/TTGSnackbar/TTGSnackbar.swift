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
public enum TTGSnackbarDuration: NSTimeInterval {
    case Short = 1.0
    case Middle = 3.0
    case Long = 5.0
    case Forever = 9999999999.0 // Must dismiss manually.
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
    case FadeInFadeOut
    case SlideFromBottomToTop
    case SlideFromTopBackToTop
    case SlideFromLeftToRight
    case SlideFromRightToLeft
    case Flip
}

public class TTGSnackbar: UIView {
    // MARK: -
    // MARK: Class property.
    
    /// Animation duration.
    private static let snackbarAnimationDuration: NSTimeInterval = 0.3
    
    /// Snackbar height.
    private static let snackbarHeight: CGFloat = 44
    
    /// Snackbar margin to the bottom of screen.
    private static let snackbarBottomMargin: CGFloat = 0
    
    /// Snackbar margin to the left and right.
    private static let snackbarHorizonMargin: CGFloat = 0
    
    /// Snackbar action button width.
    private static let snackbarActionButtonWidth: CGFloat = 64
    
    // MARK: -
    // MARK: Typealias
    
    /// Action callback closure definition.
    public typealias TTGActionBlock = (snackbar:TTGSnackbar) -> Void
    
    /// Dismiss callback closure definition.
    public typealias TTGDismissBlock = (snackbar:TTGSnackbar) -> Void
    
    // MARK: -
    // MARK: Public property.
    
    /// Action callback.
    public var actionBlock: TTGActionBlock? = nil
    
    /// Dismiss callback.
    public var dismissBlock: TTGDismissBlock? = nil
    
    /// Snackbar display duration. Default is Short - 1 second.
    public var duration: TTGSnackbarDuration = TTGSnackbarDuration.Short
    
    /// Snackbar animation type. Default is SlideFromTopBackToTop.
    public var animationType: TTGSnackbarAnimationType = TTGSnackbarAnimationType.SlideFromTopBackToTop
    
    public var superView: UIView?;
    
    /// Main text shown on the snackbar.
    public var message: String = "" {
        didSet {
            self.messageLabel.text = message
        }
    }
    
    /// Message text color. Default is white.
    public dynamic var messageTextColor: UIColor = UIColor.whiteColor() {
        didSet {
            self.messageLabel.textColor = messageTextColor
        }
    }
    
    /// Message text font. Default is Bold system font (14).
    public dynamic var messageTextFont: UIFont = UIFont.boldSystemFontOfSize(14) {
        didSet {
            self.messageLabel.font = messageTextFont
        }
    }
    
    /// Message text alignment. Default is left
    public dynamic var messageTextAlign: NSTextAlignment = .Left {
        didSet {
            self.messageLabel.textAlignment = messageTextAlign
        }
    }
    
    /// Action button title.
    public dynamic var actionText: String = "" {
        didSet {
            self.actionButton.setTitle(actionText, forState: UIControlState.Normal)
        }
    }
    
    /// Action button title color. Default is white.
    public dynamic var actionTextColor: UIColor = UIColor.whiteColor() {
        didSet {
            actionButton.setTitleColor(actionTextColor, forState: UIControlState.Normal)
        }
    }
    
    /// Action text font. Default is Bold system font (14).
    public dynamic var actionTextFont: UIFont = UIFont.boldSystemFontOfSize(14) {
        didSet {
            self.actionButton.titleLabel?.font = actionTextFont
        }
    }
    
    // MARK: -
    // MARK: Private property.
    
    private var messageLabel: UILabel!
    private var seperateView: UIView!
    private var actionButton: UIButton!
    private var activityIndicatorView: UIActivityIndicatorView!
    
    /// Timer to dismiss the snackbar.
    private var dismissTimer: NSTimer? = nil
    
    // Constraints.
    private var centerXConstraint: NSLayoutConstraint? = nil
    private var topMarginConstraint: NSLayoutConstraint? = nil
    private var actionButtonWidthConstraint: NSLayoutConstraint? = nil
    
    // MARK: -
    // MARK: Init
    
    /**
    Show a single message like a Toast.
    
    - parameter message:  Message text.
    - parameter duration: Duration type.
    
    - returns: Void
    */
    public init(message: String, duration: TTGSnackbarDuration, superView: UIView?) {
        super.init(frame: CGRectMake(0, 0, 0, 0))
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
    public init(message: String, duration: TTGSnackbarDuration, actionText: String, actionBlock: TTGActionBlock) {
        super.init(frame: CGRectMake(0, 0, 0, 0))
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
    public init(message: String, duration: TTGSnackbarDuration, actionText: String, messageFont: UIFont, actionTextFont: UIFont, actionBlock: TTGActionBlock) {
        super.init(frame: CGRectMake(0, 0, 0, 0))
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
    public func show() {
        // Only show once
        if self.superview != nil {
            return
        }
        
        // Create dismiss timer
        dismissTimer = NSTimer.scheduledTimerWithTimeInterval(duration.rawValue, target: self, selector: "dismiss", userInfo: nil, repeats: false)
        
        // Show or hide action button
        actionButton.hidden = actionText.isEmpty || actionBlock == nil
        seperateView.hidden = actionButton.hidden
        actionButtonWidthConstraint?.constant = actionButton.hidden ? 0 : TTGSnackbar.snackbarActionButtonWidth
        
        if let superView = self.superView {
            superView.addSubview(self)
            
            // Snackbar height constraint
            let heightConstraint: NSLayoutConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: TTGSnackbar.snackbarHeight)
            
            // Snackbar width constraint
            let widthConstraint: NSLayoutConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: superView.bounds.width - 2 * TTGSnackbar.snackbarHorizonMargin)
            
            // Center X constraint
            centerXConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: superView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            
            // Bottom margin constraint
            topMarginConstraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: superview, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            
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
    public func dismiss() {
        // On main thread
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
            self.dismissAnimated(true)
        }
    }
    
    // MARK: -
    // MARK: Private methods.
    
    /**
    Init configuration.
    */
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        
        messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.font = messageTextFont
        messageLabel.backgroundColor = UIColor.clearColor()
        messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        messageLabel.numberOfLines = 2
        messageLabel.textAlignment = NSTextAlignment.Left
        messageLabel.text = message
        self.addSubview(messageLabel)
        
        actionButton = UIButton()
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.backgroundColor = UIColor.clearColor()
        actionButton.titleLabel?.font = actionTextFont
        actionButton.setTitle(actionText, forState: UIControlState.Normal)
        actionButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        actionButton.addTarget(self, action: Selector("doAction"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(actionButton)
        
        seperateView = UIView()
        seperateView.translatesAutoresizingMaskIntoConstraints = false
        seperateView.backgroundColor = UIColor.grayColor()
        self.addSubview(seperateView)
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.stopAnimating()
        self.addSubview(activityIndicatorView)
        
        // Add constraints
        let hConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[messageLabel]-snackbarHorizonMargin-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: ["snackbarHorizonMargin": 10],
            views: ["messageLabel": messageLabel, "seperateView": seperateView, "actionButn": actionButton])
        
        let vConstraintsForMessageLabel: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[messageLabel]-|",
            options: NSLayoutFormatOptions(rawValue: 10),
            metrics: nil,
            views: ["messageLabel": messageLabel])
        
        let vConstraintsForSeperateView: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[seperateView]-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["seperateView": seperateView])
        
        let vConstraintsForActionButton: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-[actionButton]-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["actionButton": actionButton])
        
        actionButtonWidthConstraint = NSLayoutConstraint.init(
            item: actionButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: TTGSnackbar.snackbarActionButtonWidth)
        
        let vConstraintsForActivityIndicatorView: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-(2)-[activityIndicatorView]-(2)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["activityIndicatorView": activityIndicatorView])
        
        let hConstraintsForActivityIndicatorView: [NSLayoutConstraint] = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[activityIndicatorView(activityIndicatorWidth)]-(2)-|",
            options: NSLayoutFormatOptions(rawValue: 0),
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
    private func invalidDismissTimer() {
        dismissTimer?.invalidate()
        dismissTimer = nil
    }
    
    /**
     Dismiss.
     
     - parameter animated: If dismiss with animation.
     */
    private func dismissAnimated(animated: Bool) {
        invalidDismissTimer()
        activityIndicatorView.stopAnimating()
        
        if !animated {
            dismissBlock?(snackbar: self)
            self.removeFromSuperview()
            return
        }
        
        var animationBlock: (() -> Void)? = nil
        
        switch animationType {
        case .FadeInFadeOut:
            animationBlock = {
                self.alpha = 0.0
            }
        case .SlideFromTopBackToTop:
            topMarginConstraint?.constant = -TTGSnackbar.snackbarHeight
        case .SlideFromBottomToTop:
            animationBlock = {
                self.alpha = 0.0
            }
            topMarginConstraint?.constant = -TTGSnackbar.snackbarHeight - TTGSnackbar.snackbarBottomMargin
        case .SlideFromLeftToRight:
            centerXConstraint?.constant = superview!.bounds.width
        case .SlideFromRightToLeft:
            centerXConstraint?.constant = -superview!.bounds.width
        case .Flip:
            animationBlock = {
                self.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI_2), 1, 0, 0)
            }
        }
        
        self.setNeedsLayout()
        UIView.animateWithDuration(TTGSnackbar.snackbarAnimationDuration,
            delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.CurveEaseIn,
            animations: {
                () -> Void in
                animationBlock?()
                self.layoutIfNeeded()
            }) {
                (finished) -> Void in
                self.dismissBlock?(snackbar: self)
                self.removeFromSuperview()
        }
    }
    
    /**
     Show.
     */
    private func showWithAnimation() {
        var animationBlock: (() -> Void)? = nil
        
        switch animationType {
        case .FadeInFadeOut:
            topMarginConstraint?.constant = -TTGSnackbar.snackbarBottomMargin
            self.layoutIfNeeded()
            self.alpha = 0.0
            animationBlock = {
                self.alpha = 1.0
            }
        case .SlideFromTopBackToTop, .SlideFromBottomToTop:
            // Init
            topMarginConstraint?.constant = -TTGSnackbar.snackbarHeight
            self.layoutIfNeeded()
            // Animation
            topMarginConstraint?.constant = TTGSnackbar.snackbarBottomMargin
        case .SlideFromLeftToRight:
            // Init
            centerXConstraint?.constant = -superview!.bounds.width
            topMarginConstraint?.constant = -TTGSnackbar.snackbarBottomMargin
            self.layoutIfNeeded()
            // Animation
            centerXConstraint?.constant = 0
        case .SlideFromRightToLeft:
            // Init
            centerXConstraint?.constant = superview!.bounds.width
            topMarginConstraint?.constant = -TTGSnackbar.snackbarBottomMargin
            self.layoutIfNeeded()
            // Animation
            centerXConstraint?.constant = 0
        case .Flip:
            // Init
            topMarginConstraint?.constant = -TTGSnackbar.snackbarBottomMargin
            self.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI_2), 1, 0, 0)
            self.layoutIfNeeded()
            // Animation
            animationBlock = {
                self.layer.transform = CATransform3DMakeRotation(0, 1, 0, 0)
            }
        }
        
        self.setNeedsLayout()
        
        UIView.animateWithDuration(TTGSnackbar.snackbarAnimationDuration,
            delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                () -> Void in
                animationBlock?()
                self.layoutIfNeeded()
            }, completion: nil)
    }
    
    /**
     Action button.
     */
    func doAction() {
        // Call action block first
        actionBlock?(snackbar: self)
        
        // Show activity indicator
        if duration == TTGSnackbarDuration.Forever && actionButton.hidden == false {
            actionButton.hidden = true
            seperateView.hidden = true
            activityIndicatorView.hidden = false
            activityIndicatorView.startAnimating()
        } else {
            dismissAnimated(true)
        }
    }
}