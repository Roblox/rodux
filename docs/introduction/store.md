The `store` is comprised of three parts and is your main entry point for all things Rodux. It is created via [`Store.new`](../api-reference.md#storenew).

### State
This is the object tree that contains all of the data backing the business logic of your application. It can be read via [`Store:getState`](../api-reference.md#storegetstate).

### Reducer
This is a pure function that takes in an `action` object and the current state of your `store` and outputs a new state in response to the `action`. Reducers are often broken down into many individual pure functions, each of which modifies one portion of the `store` state object tree. You provide your global `reducer` to the `store` during initialization via [`Store.new`](../api-reference.md#storenew).

### Dispatcher
This is the portion of the `store` that handles incoming `action` objects. If you have applied any additional `middleware` to your `store`, the `dispatcher` is responsible for passing `action` objects to appropriate `middleware` before forwarding those `action` objects to the `reducer`. You can provide `middleware` to the `store` during initialization via [`Store.new`](../api-reference.md#storenew).