Other Features
==============

Pausing
-------

If you would like to pause a listener so that it no longer gets updates and callbacks regarding its model, then call `pauseListeningForUpdates` on the listener. When a model is updated, you will not see the change or be notified. When you decide that you want to get updates again, call `resumeListeningForUpdates` on the listener. Then, you will register the listener again for changes on the model, and also get a single update of all the changes that you missed while the listener was paused.

Batch Updates
-------------

If you have multiple models that you want to update, you could call ``updateWithNewModel`` multiple times. However, this would cause listeners to update multiple times. Instead, you can batch these changes all at once so listeners will only get one update. You can do this using the BatchUpdateModel. See the code for more documentation.

Batch Listening
---------------

Usually, you only need to listen to one model. However, you may want to listen to multiple models at once (also, see :doc:`070_collections`). You get one callback whenever any of your models has changed and can work out which model has changed using the ModelUpdates object. See BatchListener for more information on how to set this up.

Context
-------

Whenever you create an update on the consistency manager, you can optionally pass in a context object. If this update causes a change, this context is then passed back to the listener.

This is useful if you want to associate changes with their origin. So, you may want to pass in a URL to understand where a change came from. Or maybe, you could pass in a timestamp to show when a change occurred.

Model Updates
-------------

When you receive changes, you are also passed back a ModelUpdates object. This includes a set of all the ids which were updated and all the ids which were deleted. You can use this to work out what has changed in the model.
