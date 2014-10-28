// © 2016 LinkedIn Corp. All rights reserved.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at  http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import UIKit
import ConsistencyManager


class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate, ConsistencyManagerListener {

    var stream: StreamModel?

    @IBOutlet var tableView: UITableView!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Demo"

        ConsistencyManager.sharedInstance.listenForUpdates(self)

        Network.fetchUpdates() { stream in
            self.stream = stream
            ConsistencyManager.sharedInstance.listenForUpdates(self)
            self.tableView.reloadData()
        }

        tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    // MARK: - Table View Delegate/DataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stream?.updates.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let update = stream?.updates[indexPath.row]
        if let update = update {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
            cell.delegate = self
            cell.idLabel.text = update.id
            if update.liked {
                cell.button.setTitle("Unlike", forState: .Normal)
            } else {
                cell.button.setTitle("Like", forState: .Normal)
            }
            return cell
        } else {
            assert(false)
            return UITableViewCell()
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let update = stream?.updates[indexPath.row]
        let detail = DetailViewController(update: update!)
        navigationController?.pushViewController(detail, animated: true)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }

    // MARK: - Cell Actions

    func buttonWasTappedOnCell(cell: TableViewCell) {
        let index = tableView.indexPathForCell(cell)?.row
        if let index = index {
            let update = stream?.updates[index]
            if let update = update {
                UpdateHelper.likeUpdate(update, like: !update.liked)
            }
        }
    }

    // MARK: - Consistency Manager Delegate

    func currentModel() -> ConsistencyManagerModel? {
        return stream
    }

    func modelUpdated(model: ConsistencyManagerModel?, updates: ModelUpdates, context: Any?) {
        if let model = model as? StreamModel {
            if model != stream {
                stream = model
                tableView.reloadData()
            }
        }
    }
}
