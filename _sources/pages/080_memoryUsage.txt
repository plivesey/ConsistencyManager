Memory Footprint
================

Unlike other ORMs and consistency managers, this consistency manager does not hold onto any references to any models. Its internal state is in fact extremely light, and it's very unlikely to cause memory problems. Specifically, its internal state is just a list of its listeners. When it needs a model, it always requests a new one from a listener.

It also cleans up memory automatically when it's not needed anymore. For instance, if a listener is deallocated then the consistency manager will automatically remove this object. This means that the removeListener API is completely optional to call.
