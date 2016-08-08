Model Requirements
==================

In order for the consistency manager to traverse and edit models as trees, all models must conform to the ConsistencyManagerModel protocol. This protocol is usually relatively easy to implement. There are four methods you need to implement. For more information, see the documentation in the code.

These models can be swift structs, swift classes, objective-c classes or really, any object. The models should be immutable and these models should be thread-safe. It should be easy to implement these methods in a thread safe manner since the models are immutable and these are all functional methods.

ConsistencyManagerModel
-----------------------

This protocol must be implemented for every model used by the consistency manager. It defines three main features:

  1. The ability to identify models as representing the same data. This is done by returning a globally unique identifier. If this identifier is the same, it means it represents the same data. This also defines a 'node' in the tree (see :doc:`010_consistencyManager`).
  2. The ability to create new models by mapping on old models. The protocol allows the consistency manager to iterate over child nodes (and then recursively iterate over the whole tree) and then replace these models with updated models.
  3. Compare model for equality. The consistency manager needs to compare models to determine if models have actually changed. If a model hasn't changed, the consistency manager can short circuit.

Equality
--------

One important requirement for models is that models with the same id must be equal. You cannot have one model that has a child and another model with the same id which does not have this child. This will be considered an update to the consistency manager and one model will be updated.

Deletes
-------

The consistency manager supports deleting models. When a model is deleted, the map function in the ConsistencyManagerProtocol will return nil for a model. This means the model should remove this child model. If the child model is required, we recommend you cascade this delete and return nil for the current model.

Examples
--------

These examples are based on the trees shown in :doc:`010_consistencyManager`.

=============
Message Model
=============

.. code-block:: c

  struct Message: ConsistencyManagerModel, Equatable {
    let id: String
    let text: String
    let author: Person
    let image: Image?

    var modelIdentifier: String? {
      return "Message-\(id)"
    }

    func map(transform: (ConsistencyManagerModel) -> ConsistencyManagerModel?) -> ConsistencyManagerModel? {
      guard let author = transform(self.author) as? Person else {
        // required field, so we will cascade the delete if person is deleted
        return nil
      }
      let image = transform(self.image)
      return Message(id: id, text: text, author: author, image: image)
    }

    func forEach(visit: (ConsistencyManagerModel) -> Void) {
      visit(author)
      if let image = image {
        visit(image)
      }
    }
  }

  func ==(lhs: Message, rhs: Message) -> Bool {
    return lhs.id == rhs.id &&
      lhs.text == rhs.text &&
      lhs.author == rhs.author &&
      lhs.image == rhs.image
  }

==============
Contacts Model
==============

.. code-block:: c

  struct Contacts: ConsistencyManagerModel, Equatable {
    let id: String
    let contacts: [Person]

    var modelIdentifier: String? {
      return "Contacts-\(id)"
    }

    func map(transform: (ConsistencyManagerModel) -> ConsistencyManagerModel?) -> ConsistencyManagerModel? {
      let contacts = self.contacts.flatMap { model in
        return transform(model) as? Person
      }
      return Contacts(id: id, contacts: contacts)
    }

    func forEach(visit: (ConsistencyManagerModel) -> Void) {
      contacts.forEach(visit)
    }
  }

  func ==(lhs: Contacts, rhs: Contacts) -> Bool {
    return lhs.id == rhs.id &&
      lhs.contacts == rhs.contacts
  }

The other models (Person and Image) have similar implementations which are hopefully clear given these examples.

====
JSON
====

You can use any networking protocol to represent your models. Here, we show how these models might be represented in JSON.

.. code-block:: json

  // Message model
  {
    "id": "12",
    "text": "Hey, how are you doing?",
    "author": {
      "id": "42",
      "username": "plivesey",
      "online": false
    },
    "image": {
      "path": "/static/images/img3.png",
      "width": 200
    }
  }

  // Contacts model
  {
    "id": "44",
    "contacts": [
      {
        "id": "42",
        "username": "plivesey",
        "online": false
      },
      {
        "id": "53",
        "username": "ndonti",
        "online": true
      }
    ]
  }
