Errors and Debugging
====================

Errors
------

There aren't many errors that can occur in the consistency manager, but a few are possible. They usually arise because of an error in one of the protocol methods you need to implement. Because they are the result of a coding error, there isn't much you can do to handle errors on a case by case basis. Instead, the library provides a delegate method for you to catch errors and log them. Then, you can fix these errors in a future release.

As an initial implementation, it's recommended to implement the ``ConsistencyManagerDelegate`` method with ``assertionFailure`` so that in your debug builds, you will see problems early.

Debugging
---------

Also in the ``ConsistencyManagerDelegate`` is a method that is called every time the consistency manager makes a change. This is useful when you're seeing unexpected changes due to the consistency manager. If you place a break point here or print out the models, you can see why certain changes are being made.
