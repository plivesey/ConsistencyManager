Listeners
=========

The listener protocol (ConsistencyManagerListener) should be implemented by anyone who wants to listen to a model using the consistency manager.

When a model is changed, the consistency manager will notify zero, one or many listeners about this change. Though the consistency manager is highly asynchronous, all the methods called on the listener protocol will be on the main thread so it's a great candidate for writing UI code. In general, the only thing you need to do in the ``modelUpdated`` method is refresh your view.

Listening to Multiple Models
----------------------------

For simplicity, the default API only allows you to listen to one model. If you want to listen to multiple models, you can use batch listening. See :doc:`060_otherFeatures` and :doc:`070_collections` for more information.

Example
-------

Here's an example implementation of the listener class. Here, were assuming we refresh the view with a tableview, but you may have some other way of redrawing your view.

.. code-block:: c

  var message: Message?

  override func viewDidLoad() {
    super.viewDidLoad()

    ConsistencyManager.sharedInstance.listenForUpdates(self)

    Network.fetchMessage() { message in
      self.message = message
      // You must relisten here since the model has changed
      ConsistencyManager.sharedInstance.listenForUpdates(self)
      self.tableView.reloadData()
    }
  }

  func currentModel() -> ConsistencyManagerModel? {
    return message
  }

  func modelUpdated(model: ConsistencyManagerModel?, updates: ModelUpdates, context: Any?) {
    // An unfortunate cast which will never fail
    if let model = model as? Message {
      message = model
      tableView.reloadData()
    }
  }
