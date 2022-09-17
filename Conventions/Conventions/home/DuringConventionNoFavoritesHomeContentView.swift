//
//  DuringConventionNoFavoritesHomeContentView.swift
//  Conventions
//
//  Created by David Bahat on 17/09/2017.
//  Copyright © 2017 Amai. All rights reserved.
//

import Foundation

class DuringConventionNoFavoritesHomeContentView : UIView, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var eventsTable: UITableView!
    @IBOutlet private weak var titleContainer: UIView!
    @IBOutlet private weak var goToEventsButton: UIButton!
    
    private let cellIdentifer = "cellIdentifer"
    private var events : Array<ConventionEvent> = []
    
    weak var delegate: ConventionHomeContentViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        inflateNib(DuringConventionNoFavoritesHomeContentView.self)
        
        eventsTable.estimatedRowHeight = 30
        eventsTable.rowHeight = UITableView.automaticDimension
        
        titleContainer.backgroundColor = Colors.homeTimeBoxContainerColor
        titleLabel.textColor = Colors.homeTimeTextColor
        goToEventsButton.backgroundColor = Colors.homeButtonsColor
        goToEventsButton.setTitleColor(Colors.homeButtonsTextColor, for: .normal)
        eventsTable.backgroundColor = Colors.homeNextEventColor
        eventsTable.separatorColor = Colors.icon2022_green1
        
        eventsTable.layer.borderWidth = 1
        eventsTable.layer.borderColor = Colors.icon2022_green1.cgColor
    }
    
    @IBAction private func showAllEventsButtonWasClicked(_ sender: UIButton) {
        delegate?.navigateToEventsClicked()
    }
    
    func setEvents(_ events: Array<ConventionEvent>) {
        self.events = events
        
        if let eventsStartTime = events.first?.startTime {
            titleLabel.text = "אירועים שמתחילים ב-" + eventsStartTime.format("HH:mm")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = eventsTable.dequeueReusableCell(withIdentifier: cellIdentifer) {
            return bind(cell, event: events[indexPath.row])
        }
        
        return bind(UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifer), event:events[indexPath.row])
    }
    
    private func bind(_ cell: UITableViewCell, event: ConventionEvent) -> UITableViewCell {
        cell.textLabel?.text = event.title
        cell.textLabel?.textAlignment = .right
        cell.textLabel?.textColor = Colors.icon2022_green1
        cell.textLabel?.font.withSize(18)
        cell.textLabel?.numberOfLines = 2
        cell.backgroundColor = UIColor.clear
        
        if event.directWatchAvailable {
            cell.imageView?.image = UIImage(named: "HomeOnlineEvent")?.withRenderingMode(.alwaysTemplate)
            cell.tintColor = Colors.icon2022_green1
        } else {
            cell.imageView?.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.navigateToEventClicked(event: events[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
