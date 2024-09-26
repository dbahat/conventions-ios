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
        
        titleContainer.backgroundColor = Colors.homeTitleDuringConventionNoFavoritesBackgroundColor
        titleContainer.layer.cornerRadius = 4
        titleLabel.textColor = Colors.homeTitleDuringConventionNoFavoritesTextColor
        goToEventsButton.backgroundColor = Colors.homeGoToMyEventsButtonColor
        goToEventsButton.setTitleColor(Colors.homeGoToMyEventsButtonTitleColor, for: .normal)
        goToEventsButton.layer.cornerRadius = 4
        eventsTable.backgroundColor = UIColor.clear
        eventsTable.separatorColor = UIColor.clear
        
        eventsTable.layer.borderWidth = 0
        eventsTable.layer.borderColor = Colors.textColor.cgColor
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
        // Using section headers to simulate spacing between cells
        return events.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = eventsTable.dequeueReusableCell(withIdentifier: cellIdentifer) {
            return bind(cell, event: events[indexPath.section])
        }
        
        return bind(UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifer), event:events[indexPath.section])
    }
    
    private func bind(_ cell: UITableViewCell, event: ConventionEvent) -> UITableViewCell {
        cell.textLabel?.text = event.title
        cell.textLabel?.textAlignment = .right
        cell.textLabel?.textColor = Colors.homeDuringConvetionNoFavoriteCardTextColor
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.textLabel?.numberOfLines = 2
        cell.backgroundColor = Colors.homeDuringConvetionNoFavoriteCardBackgroundColor
        cell.layer.cornerRadius = 4
        
        if event.directWatchAvailable {
            cell.imageView?.image = UIImage(named: "HomeOnlineEvent")?.withRenderingMode(.alwaysTemplate)
            cell.tintColor = Colors.homeDuringConvetionNoFavoriteCardTextColor
        } else {
            cell.imageView?.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.navigateToEventClicked(event: events[indexPath.section])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
