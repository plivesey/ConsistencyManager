Data Flow
=========

One of the advantages of using this library is that the flow of data is easy to reason about and simple to implement. The diagram below shows how data flows between view controllers, views, the consistency manager and other data sources.

.. image:: ../images/dataFlow.png

The data always flows in one direction. This is different from KVO when you'd see callbacks coming from models, or NSNotifications where you have many sideways calls. Also, the data coming from the consistency manager and the network (or other sources) is the same data. If you get a person model from the network, and listen to a person model, you'll always get a person model back from the consistency manager. This means that regardless of where your data comes from, you can render your screen in the same way.

The single direction of data flow also makes your code easier to reason about and debug.
