Future Plans
============

	- We are working on creating another project which offers another layer of abstraction for caching. Since all your models have a unique modelIdentifier, caching is easy to add. This library adds logic to handle collections and share them across your application. This should be a full replacement for CoreData and abstracts away the consistency manager implementation. We will be working on open sourcing this soon.
	- Adding a listener functionality which allows you to listen for certain changes. For instance, you may want to listen for any new Message model with unread property equal to true that's been added. This is similar to using predicates to identify changes which haven't even happened yet.
