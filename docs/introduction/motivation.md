As applications become more complex it can be difficult to manage the state of our application in a way that is transparent and compartmentalized. State changes caused by network responses and user input become difficult to follow as our business logic gets spread out between an increasing number of models and views, producing unpredictable and undesirable results. Rodux tries to address this problem by following three core principles.

### Single Source of Truth
By collecting all of our application's state in a single object, we can quickly inspect the entirety of the data backing our business logic. We will no longer need to track down data models squirrelled away in disparate parts of our code base.

### State is Read-only
All changes to our single state object are accomplished by dispatching actions to our store, so which part of our code caused what changes to our underlying data will be completely transparent and reproducible. Features that were once difficult like undo/redo become trivial when all changes to our data are controlled via a single, consistent interface.

### Changes Are Made With Pure Functions
Actions dispatched to our store will be processed by pure functions called reducers. These reducers simply take an action and our store's current state as input and output the store's new state in response to that action. These functions have no side effects and give us a single location to put all of our business logic instead of spreading that business logic out over numerous views and models.

That's all there is to it! The API and tools Rodux provides are relatively simple, but solve many of the most common problems that occur in complex, asynchronous applications by introducing a single paradigm for all of our data management.