
//
//  FeedbackView.swift
//  Conventions
//
//  Created by David Bahat on 6/24/16.
//  Copyright © 2016 Amai. All rights reserved.
//

import Foundation

protocol FeedbackViewProtocol : class {
    func feedbackViewHeightDidChange(_ newHeight: CGFloat)
    
    func feedbackProvided(_ feedback: FeedbackAnswer)
    
    func feedbackCleared(_ feedback: FeedbackQuestion)
    
    func sendFeedbackWasClicked()
}

class FeedbackView : UIView, UITableViewDataSource, UITableViewDelegate, FeedbackQuestionProtocol, UITextViewDelegate {
    
    @IBOutlet private weak var feedbackIconContainerWidth: NSLayoutConstraint!
    @IBOutlet private weak var feedbackIcon: UIImageView!
    @IBOutlet private weak var changeStateButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var questionsTableView: UITableView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var questionsTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var footerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var footerView: UIView!
    @IBOutlet private weak var sendMailIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var moreInfoFeedbackTextView: UITextView!
    
    private let urlFotAdditionalEventFeedback = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSdqH12zcrWijR56WbQsu1w6HtMSAOT3UG2mefNJr0ubLMPEbg/viewform?usp=pp_url")!
    private let urlFotAdditionalConventionFeedback = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLScAhC6xcSDmexSAMyVnGIEApiRC0jUBXVfvAxv2E9wvLoZeHg/viewform")!
    
    var textColor = Colors.textColor {
        didSet {
            titleLabel.textColor = textColor
            questionsTableView.reloadData()
            updateMoreFeedbackLink()
        }
    }
    var buttonColor = Colors.buttonColor {
        didSet {
            changeStateButton.setTitleColor(buttonColor, for: UIControl.State())
            sendButton.setTitleColor(buttonColor, for: UIControl.State())
        }
    }
    var answerButtonsColor = Colors.buttonColor
    var answerButtonsPressedColor = Colors.buttonPressedColor
    var event: ConventionEvent? {
        didSet {
            updateMoreFeedbackLink()
        }
    }
    
    private var questions: Array<FeedbackQuestion> = []
    private var answers: Array<FeedbackAnswer> = []
    private var isSent: Bool = false {
        didSet {
            if !isSent {
                return
            }
            
            if let rating = self.answers.getFeedbackWeightedRating() {
                feedbackIcon.image = rating.answer.getImage()
            }
            
            sendButton.setTitle("הפידבק נשלח. תודה!", for: UIControl.State())
            sendButton.setTitleColor(UIColor.white, for: UIControl.State())
            sendButton.isUserInteractionEnabled = false
        }
    }
    
    weak var delegate: FeedbackViewProtocol?
    
    private let headerHeight = CGFloat(30)
    private let footerHeight = CGFloat(67)
    private let paddingSize = CGFloat(10)
    
    var state: State = State.collapsed {
        didSet {
            switch state {
            case .expended:
                footerView.isHidden = false
                footerHeightConstraint.constant = footerHeight
                questionsTableHeightConstraint.constant = questions.height
                changeStateButton.setTitle("הסתר",for: UIControl.State())
                titleLabel.text = "פידבק"
                feedbackIconContainerWidth.constant = 0
                
            case .collapsed:
                footerView.isHidden = true
                footerHeightConstraint.constant = 0
                questionsTableHeightConstraint.constant = 0
                changeStateButton.setTitle(isSent ? "הצג פידבק" : "מלא פידבק",for: UIControl.State())
                titleLabel.text = getCollapsedTitleLabel()
                feedbackIconContainerWidth.constant = 38
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        let view = Bundle.main.loadNibNamed(String(describing: FeedbackView.self), owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        addSubview(view);
        
        feedbackIcon.image = feedbackIcon.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        feedbackIcon.tintColor = UIColor.white
        
        // Register all cells dynamiclly, since we want each cell to have a seperate xib file
        questionsTableView.register(UINib(nibName: String(describing: SmileyFeedbackQuestionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SmileyFeedbackQuestionCell.self))
        questionsTableView.register(UINib(nibName: String(describing: TextFeedbackQuestionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TextFeedbackQuestionCell.self))
        questionsTableView.register(UINib(nibName: String(describing: MultipleAnswerFeedbackQuestionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MultipleAnswerFeedbackQuestionCell.self))
        questionsTableView.register(UINib(nibName: String(describing: TableMultipleAnswerFeedbackQuestionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TableMultipleAnswerFeedbackQuestionCell.self))
        
        changeStateButton.setTitleColor(Colors.buttonColor, for: UIControl.State())
        sendButton.setTitleColor(Colors.buttonColor, for: UIControl.State())
        titleLabel.textColor = textColor
        moreInfoFeedbackTextView.textColor = textColor
        
        updateMoreFeedbackLink()
    }
    
    private func updateMoreFeedbackLink() {
        let moreFeedbackText = "רוצה להרחיב? לתת משוב נוסף? לחץ כאן"
        let moreFeedbackAttributedString = NSMutableAttributedString(string: moreFeedbackText , attributes: [.foregroundColor:textColor, .font: UIFont.systemFont(ofSize: 14)])
        let range = NSString(string: moreFeedbackText).range(of: "כאן")
        let url = event == nil ? urlFotAdditionalConventionFeedback : urlFotAdditionalEventFeedback
        moreFeedbackAttributedString.addAttribute(.link, value: url, range: range)
        
        moreInfoFeedbackTextView.attributedText = moreFeedbackAttributedString
        
        moreInfoFeedbackTextView.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if event == nil {
            UIApplication.shared.openURL(URL)
            return false
        }
        
        let items = ["entry.1572016508": event?.title, "entry.1917108492": event?.lecturer, "entry.10889808": event?.hall.name, "entry.1131737302": event?.startTime.format("dd.MM.yyyy HH:mm")]
        
        var components = URLComponents(url: URL, resolvingAgainstBaseURL: true)
        components?.queryItems = items.map({URLQueryItem(name: $0.key, value: $0.value)})
        if let urlWithPrefilledFields = components?.url {
            UIApplication.shared.openURL(urlWithPrefilledFields)
        }
        return false
    }
    
    func setFeedback(questions: Array<FeedbackQuestion>, answers: Array<FeedbackAnswer>, isSent: Bool) {
        self.questions = questions
        self.answers = answers
        self.isSent = isSent
        
        if isSent {
            // Filter out un-answered questions
            self.questions = questions.filter({question in
                answers.contains(where: {answer in question.question == answer.questionText})
            })
        } else {
            if Convention.instance.isFeedbackSendingTimeOver() {
                sendButton.setTitle("זמן שליחת הפידבק הסתיים", for: UIControl.State())
                sendButton.setTitleColor(UIColor.white, for: UIControl.State())
                sendButton.isUserInteractionEnabled = false
            } else {
                // Disable the send button unless the user answers a question
                sendButton.isEnabled = answers.count > 0
            }
        }
        
        questionsTableView.reloadData()
    }
    
    func removeAnsweredQuestions(_ answers: Array<FeedbackAnswer>) {
        self.answers = answers
        
        var indexesToUpdate = Array<IndexPath>()
        var answeredQuestions = Array<FeedbackQuestion>()
        
        // get the indexes of all un-answered questions, so we can animate their removal
        for index in 0...(questions.count - 1) {
            let question = questions[index]
            if !answers.contains(where: {answer in answer.questionText == question.question}) {
                indexesToUpdate.append(IndexPath(row: index, section: 0))
            } else {
                answeredQuestions.append(question)
            }
        }
        
        questions = answeredQuestions
        questionsTableView.deleteRows(at: indexesToUpdate, with: UITableView.RowAnimation.automatic)
        questionsTableHeightConstraint.constant = questions.height
    }
    
    func getHeight() -> CGFloat {
        switch state {
        case .collapsed:
            return headerView.frame.size.height + 2 * paddingSize
        case .expended:
            let size = paddingSize + headerViewHeightConstraint.constant + 2 * paddingSize
            return size + questions.height + footerHeight + paddingSize
        }
    }
    
    func setHeaderHidden(_ hidden: Bool) {
        headerView.isHidden = hidden
        headerViewHeightConstraint.constant = hidden ? 0 : headerHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let question = questions[indexPath.row]
        let cellId = String(describing: question.answerType) + String(describing: FeedbackQuestionCell.self)
        let cell = questionsTableView.dequeueReusableCell(withIdentifier: cellId)! as! FeedbackQuestionCell
        cell.delegate = self
        cell.question = question
        cell.feedbackTextColor = textColor
        cell.feedbackAnswerColor = answerButtonsColor
        cell.feedbackAnswerPressedColor = answerButtonsPressedColor
        
        // disable the question cell interactions if the feedback was already sent
        cell.enabled = !isSent
        
        if let foundAnswer = answers.filter({answer in answer.questionText == question.question}).first {
            cell.setAnswer(foundAnswer)
        }
        
        if (question.viewHeight != question.answerType.defaultHeight + cell.cellHeightDelta) {
            question.viewHeight = question.answerType.defaultHeight + cell.cellHeightDelta
            
            questionsTableHeightConstraint.constant = questions.height
            delegate?.feedbackViewHeightDidChange(getHeight())
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let question = questions[indexPath.row]
        return question.viewHeight
    }
    
    func questionWasAnswered(_ answer: FeedbackAnswer) {
        delegate?.feedbackProvided(answer)
    }
    
    func questionCleared(_ question: FeedbackQuestion) {
        delegate?.feedbackCleared(question)
    }
    
    func questionViewHeightChanged(caller: UITableViewCell, newHeight: CGFloat) {
        guard let indexPath = questionsTableView.indexPath(for: caller) else {
            // if the calling cell is not in the model, ignore it's event
            return
        }
        
        let question = questions[indexPath.row]
        question.viewHeight = question.answerType.defaultHeight + newHeight
        
        questionsTableView.beginUpdates()
        questionsTableView.endUpdates()
        
        questionsTableHeightConstraint.constant = questions.height
        delegate?.feedbackViewHeightDidChange(getHeight())
    }
    
    func setFeedbackAsSent(_ success: Bool) {
        sendMailIndicator.stopAnimating()
        sendButton.isHidden = false
        isSent = success
    }
    
    func setSendButtonEnabled(_ enabled: Bool) {
        sendButton.isEnabled = enabled;
    }

    @IBAction fileprivate func headerWasClicked(_ sender: UITapGestureRecognizer) {
        state = state.toggle()
        
        delegate?.feedbackViewHeightDidChange(getHeight())
        
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }) 
    }
    
    @IBAction fileprivate func sendWasClicked(_ sender: UIButton) {
        sendMailIndicator.startAnimating()
        sendButton.isHidden = true
        
        delegate?.sendFeedbackWasClicked()
    }
    
    fileprivate func getCollapsedTitleLabel() -> String {
        if isSent {
            return "הפידבק נשלח. תודה!"
        }
        
        return Convention.instance.isFeedbackSendingTimeOver() ? "זמן שליחת הפידבק הסתיים" : "האירוע נגמר"
    }
    
    enum State {
        case expended
        case collapsed
        
        func toggle() -> State {
            switch self {
            case .expended:
                return .collapsed
            case .collapsed:
                return . expended
            }
        }
    }
}

private extension Array where Element: FeedbackQuestion {
    var height: CGFloat {
        get {
            return self.reduce(0, {totalHight, question in totalHight + question.viewHeight})
        }
    }
}
