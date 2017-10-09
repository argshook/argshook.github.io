# 6 weird functions to reduce boilerpate from react + redux. number 4 will shock you

> **TL;DR;** i worked with react + redux, noticed few patterns and made helper functions to standardize those patterns. `npm i redux-msg`. available on github <a href="https://github.com/argshook/redux-msg" target="_blank">github</a>.

were you ever "i want to change this piece of redux
action/state/selector/whatever but ugh there's so much of similar stuff i would need to touch might as well not do it at all and keep pilling more stuff over". well, i went like that.

### `my-component/logic.js`:

```js
export const NAME = 'myComponent';

export const MODEL = {
  thing: {},
  more: 'stuff'
};

const SET_THING = `${NAME}/SET_THING`;

export const setThing = thing => ({ type: SET_THING, thing });

export const reducer = createReducer(NAME)({
  [SET_THING]: (state, { thing }) => ({ ...state, thing })
});

export const selectors = createSelectors(NAME)(MODEL);
export const createState = createState(NAME)(MODEL);
```

if you have all of the above, you can:

* `dispatch(setThing({ hello: 'im a thing' }))` and get redux state looking
like this: `{ myComponent: { thing: { hello: 'im a thing' } } }`
* use `selectors.thing(store.getState())` to get `{ hello: im a thing}`.
this is useful withing `mapStateToProps`, for example:

    `my-component/index.js`:

    ```js
    import { selectors } from './logic';
    const mapStateToProps = state => ({
      thingAsPropForMyComponent: selectors.thing(state),
      moreStuff: selectors.more(state) // <= 'stuff'
    });
    export default connect(mapStateToProps)(MyComponent);
    ```

* use reducer within redux `createStore` and use `createState` to
hydrate redux state of `myComponent`:

    `create-store.js`:

    ```js
    import { createStore, combineReducers } from 'redux';
    import * as myComponent from './my-component/logic';

    const rootReducer = combineReducers({
      [myComponent.NAME]: myComponent.reducer
    });

    const store = createStore(rootReducer, {
      ...myComponent.createState({
        more: 'of everything im no longer just "stuff" :)'
      })
    });
    ```

this alone make refactoring a much easier task.

However, this wasn't enough for me, i can still see repetition.

90% of the time all i care is that once some `onClick` happens, state
changes the way i want. the essence is: once some function is called,
make state of my component to be `{ ...previousState, ...somethingNew }`, that's it.
everything else is usually just noise. 

how can i achieve that?

enter `messages`.

let's look at same `my-component/logic.js` file from above, but now use these messages:

`my-component/logic.js`:

```js
export const NAME = 'myComponent';

export const MODEL = {
  thing: {},
  more: 'stuff'
};

export const message = createMessage(NAME);
export const reducer = createMessagesReducer(NAME)(MODEL);

export const setThing = thing => message(state => ({ ...state, thing }));

export const selectors = createSelectors(NAME)(MODEL);
export const createState = createState(NAME)(MODEL);
```

something got removed, something got added.

missing are parts that had most brackets:
```js
const SET_THING = `${NAME}/SET_THING`;

export const setThing = thing => ({ type: SET_THING, thing });

export const reducer = createReducer(NAME)({
  [SET_THING]: (state, { thing }) => ({ ...state, thing })
});
```

they are replaced with:
```js
export const message = createMessage(NAME);
export const reducer = createMessagesReducer(NAME)(MODEL);
export const setThing = thing => message(state => ({ ...state, thing }));
```

notice `setThing` function. theres this `message` thing inside.

`message` can be called with function which receives current component
state and return a new state. this is all it does.

internally, `message` creates a regular redux action which looks like `{ type: MESSAGE, message: 'payload' }`.
here, `payload` is whatever is returned from that function you give for `message`.

reducer, created with `createMessagesReducer` knows how to handle such message.
