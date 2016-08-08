Consistency Manager
===================

This page gives a detailed view of how you should use the consistency manager and how it works.

Trees
-----

Denormalized data models can be represented as trees. For instance, JSON is a tree. The root node is the root dictionary. Each new dictionary is a node and the edges are the keys in the dictionary or indexes in an array. Across an application, different models often have many subtrees in common. Whenever you update a node (or set of nodes), you want any model that has this node to update.

Let's say you are writing a messaging app and you have two models which, in tree form, look like this:

.. image:: ../images/treeOriginal.png

In our application, we have two view controllers each with a reference to one of these models. Each has also registered with the consistency manager as listening to these models. Next, we'll look at an update.

For more information on how these models may look in code or encoded into JSON, see :doc:`020_modelRequirements`.

An Update
---------

Now, let's assume that through some source (network request, push notification, user action, etc.), we learn that a person with id=12 has come online. In code, you would create a new immutable person object with the online field set to true.

.. image:: ../images/nodeUpdate.png

Then, in a REST-like fashion, you can post this new object to the consistency manager.

.. code-block:: c

		consistencyManager.updateWithNewModel(personModel)

The consistency manager will notice that two models are listening to changes on this person model so need to be updated. It will then create a new Message model and a new Contacts model (it must be a new model since the original model is immutable), and the consistency manager will call a delegate method on each listener with their new model. Each new tree will look like this:

.. image:: ../images/treeUpdate.png

In code, this will look something like:

.. code-block:: c

    func modelUpdated(model: ConsistencyManagerModel?, updates: ModelUpdates, context: Any?) {
      if let model = model as? MessageModel {
        self.message = model
        tableView.reloadData()
      }
    }

Notice how this vastly simplifies the code for listeners. The listening model doesn't need to KVO on all the properties on its model, or listen to a bunch of custom notifications. All it needs to do is reset its model and call reload data. The listener will automatically be listening to new changes on its new model.

Also provided in this callback is an updates model describing what's changed and a context. You can read more about these parameters in :doc:`060_otherFeatures`.

Other Updates
-------------

There are other ways in which updates can happen to models. For instance, let's say that later in the application, the user navigates to the contacts page and pulls to refresh. This will return a new Contacts model which we'll now post to the consistency manager (it's recommended to post all new network models to the consistency manager).

In this response, let's say that the user has gone back offline. Though the message view controller is not listening to the contact model, the consistency manager does notice that it is listening to the same person model. It will follow exactly the same flow as above and update the message view controller with a new Message model.

There are a few cases which can cause consistency updates, but regardless of the method, any common subtrees are guaranteed to be kept consistent.

Deletes
-------

The consistency manager also supports deleting a model. This will cause it to be deleted from any model referencing this and replaced with nil (or removed from an array). Some models may have required fields (non-optional instance variables in swift). If you delete a required model, the behavior is up to you (in the implementation of the ConsistencyManagerModel protocol). However, we recommend that you cascade the delete and also delete its parent. This will cascade deletes.
