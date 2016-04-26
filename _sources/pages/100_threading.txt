Threading
=========

Operations in general are extremely fast for the consistency manager (in general, you should see updates in 1 ms or less), but with large trees and many listeners, it could get a little slow. So, all operations are run in a background queue. You can rely on the following assumptions:

1. All operations will not block the main queue
2. All delegate methods will be run on the main queue
3. All operations will be run in order. It will only run one operation at a time and complete it before starting the next operation.
4. Whenever a listener is updated, or a model is requested, all other affected listeners will be requested in the same block. This means that when a bunch of listeners get updated, they all get requests for the current model in the same block, and they all get updated in the same block. This ensures that listeners don't get out of sync.
