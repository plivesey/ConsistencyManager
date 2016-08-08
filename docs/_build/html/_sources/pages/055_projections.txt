Projections
===========

The Consistency Manager supports projections for models. This allows using the same ``modelIdentifier`` for instances of different classes. For instance, let's say you have two projections of the same base type - ``PersonModel`` and ``FullProfileModel``. Both models represent the same data (and share fields) so we want to use the same ID for both. However, this doesn't come for free. In general, it's not advised to use projections if you can avoid it and instead use composition (see the Alternatives section of this page).

Let's say that our models look something like this:

.. code-block:: c

	struct PersonModel {
		let id: String
		let name: String
		let pictureURL: String
	}

	struct FullProfileModel {
		let id: String
		let name: String
		let pictureURL: String
		let age: Int
		let username: String
	}

If we want these models to sometimes have the same ID, we need to implement an additional method (``mergeModel(model: ConsistencyManagerModel)``) which merges one model into the other. For instance, for ``PersonModel``, this would be:

.. code-block:: c

	extension PersonModel {
		func mergeModel(model: ConsistencyManagerModel) -> ConsistencyManagerModel {
			if let model = model as? PersonModel {
				// If the class is the same, we can just return the other model (that's the model with the fresh data)
				return model
			} else if let model = model as? FullProfileModel {
				// Return a new PersonModel with all the updated fields from the new model
				return PersonModel(id: id, name: model.name, pictureURL: model.pictureURL)
			} else {
				assertionFailure("We cannot merge models of this type")
				// Best we can do is not apply any updates
				return self
			}
		}
	}

This method should always return the same class as ``Self``. It should take all the new data from the new model and merge it with all the current data.

Implementation Difficulties
---------------------------

There are a couple of things which makes implementing this method tricky.

First, it needs to be recursive. It not only needs to merge the current model, but merge all of the submodels too. This can't be done automatically, but it's not always clear how to merge subtrees.

Second, merging arrays of different classes is difficult. If the array has new members, it may not be possible to create members of a class if it's missing required fields. For this reason, it's recommended not to use different projections in arrays.

In general, it's advised to use this feature sparingly if at all and to ensure that you know what you're doing.

Alternatives
------------

Instead of using projections, you can use composition. Larger models can contain smaller models. This means whenever a smaller model updates, the larger model will receive this update. For instance, for the models above, we could rewrite them as:

.. code-block:: c

	struct PersonModel {
		let id: String
		let name: String
		let pictureURL: String

		var modelIdentifier: String { return "PersonModel:\(id)" }
	}

	struct FullProfileModel {
		let id: String
		let person: PersonModel
		let age: Int
		let username: String

		var modelIdentifier: String { return "FullProfileModel:\(id)" }
	}

Here, each model defines a different ID and one model contains the other. This is a much simpler way to write your models while achieving consistency as well as the ability to choose large or small models for each use case.

Additional features
-------------------

The Consistency Manager also allows models to use the same class for different projections. This is useful if you want to define a model with multiple optional fields and not always set them all. This is rare, and again, use with caution as it can be hard to tell if a field has been deleted or has not yet been set. See ``ConsistencyManagerModel.swift`` for more information.
