Collections
===========

The consistency manager usually just handles listening to one model. However, having an array of models without a parent model is common. In this case, we actually want to listen to multiple models. There are a couple of ways to do this.

Option #1 - BatchListener
-------------------------

The library supports batch listening (see :doc:`060_otherFeatures`). This allows you to listen to multiple models at once and receive a single callback for changes. This is probably the easiest way to implement this feature and provides a single ModelUpdates object with all the models that were changed or deleted.

Option #2 - Multiple Listeners
------------------------------

Another option is to create an array of listeners, each of which listens to one model. This way, you will receive multiple update notifications if multiple rows have changed so updates won't be batched.
