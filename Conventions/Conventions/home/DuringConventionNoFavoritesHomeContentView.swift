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
    
    private let cellIdentifer = "cellIdentifer"
    private var events : Array<ConventionEvent> = []
    
    weak var delegate: ConventionHomeContentViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        inflateNib(DuringConventionNoFavoritesHomeContentView.self)
        
        eventsTable.estimatedRowHeight = 30
        eventsTable.rowHeight = UITableViewAutomaticDimension
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        inflateNib(DuringConventionNoFavoritesHomeContentView.self)
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
        
        return bind(UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifer), event:events[indexPath.row])
    }
    
    private func bind(_ cell: UITableViewCell, event: ConventionEvent) -> UITableViewCell {
        cell.textLabel?.text = event.title
        cell.textLabel?.textAlignment = .right
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font.withSize(18)
        cell.textLabel?.numberOfLines = 2
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.navigateToEventClicked(event: events[indexPath.row])
    }
}
