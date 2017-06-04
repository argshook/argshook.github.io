# ng-directive-compiler-helper for angular 1.5 unit testing to the rescue!

angular is not dying okay? 1.5 is pretty nice to work
with. yes, there's react and aurelia or whatever, i know and still
kinda like angular.

one sort of pain points in angular is testing its directives (aka
components). to do that, you normally have to `$inject` `$compiler` into your `$scope` and then `$digest` that ugh grose

this rather sucks especially writing many tests for different components. it quickly becomes boilerplate.

here comes [ng-directive-compiler-helper](https://github.com/argshook/ng-directive-compiler-helper) to, guess what, help you compile angular directives. i know, great name thanks.

## installing

```sh
npm i ng-directive-compiler-helper --save-dev
```

include it in your tests:

```js
// good 'ol karma:

files: [
  'node_modules/ng-directive-compiler-helper/lib/ng-directive-compiler-helper.js'
]
```

this file contains `createCompiler` function just floating there. So in
karma it's available on global scope. it's good enough for me right
now so excuse my immodularity. maybe one day.

## simple usage

```js
describe('Component: bestComponent', () => {
  let compile;

  beforeEach(module('yourModule'));

  beforeEach(inject(($compile, $rootScope) => {
    compile = createCompiler('<best-component />', $rootScope, $compile);
  }));
});
```

`createCompiler` requires three things:

1. `<best-component />` - template string of your component
1. `$rootScope` to create `$scope` so you don't have to
1. `$compile`- to properly compile so you don't have to

nice, you now have this helper function assigned to `compile`, let's use it:

```js
describe('Component: bestComponent', () => {
  /* code as above and then: */

  it('should work!', () =>
    compile(scope => {
      expect(scope).toBeDefined();
    })
  );
});
```

call `compile` and give it a callback. this will compile `<best-component />` and call given callback passing `scope` and `element`.  Bam, assert the hell out of those.

---

## great, what else

suppose you have this super useful component:

```js
angular
  .module('Pupper')
  .component('pupperLeggies', {
    bindings: {
      count: '<'
    },
    template: '<div>{{$ctrl.count}}</div>'
  });
```

you could use this component inside other components like so:

```html
<div>
  <h1>Pupper has this many legs:</h1>
  <pupper-leggies count="$ctrl.count"></pupper-leggies>
</div>
```

to mimic same environment for `<pupper-leggies />` in tests using `compile`:

```js
it('display pupper leg count', () =>
  compile(
    { countFromParent: 4 },
    { count: 'countFromParent' },
    (scope, element) => {
      expect(element.text()).toBe('4');
    })
);
```

this time i give three arguments to `compile`:

1. `{ countFromParent: 4 }` - object to imitate parent scope in which
   `<pupper-leggies>` is compiled
1. `{ count: 'countFromParent' }` - object which resembles
   `<pupper-leggies>` attributes.  key - attribute name, value -
   attribute value
1. `(scope, element) => { /* ... */ }` - same callback as before

by doing this i'm essentially creating an element that looks like this:

```js
<pupper-leggies count="countFromParent" />
```

the surrounding `$scope` for it is `{ countFromParent: 4 }`, so i can
assign its properties on the element.

> **Note**: if you don't care about element attributes, just skip the
second argument:
```js
compile({ scopeProperty: 4 }, (scope, element) => /* ... */ )`
```

---

## why all this?

yeah it may look like boilerplate to solve boilerplate. however, this
helps tremendously when testing many components under many different
scenarios. it also DRYs up code quite a bit since you don't need to
write custom compile functions anymore (i know i did that a lot)

by compiling components this way you're free to supply all parameters to
`compile` function programatically. just one way to do this:

```js
it('should display given value ', () => {
  const valuesAndAsserts = [
    [ '1', '1'  ],
    [  100, '100' ],
    [ false, '' ]
    [ -10.5, '-10.5' ]
    [ undefined, '0' ]
  ];

  valuesAndAsserts.map(([ value, assert ]) =>
      compile({}, { value: value }, (scope, element) =>
        expect(element.text()).toBe(assert))
  );
});
```

basically you can easily prepare component to be tested for 99% of the
cases, keep tests dry and easy to maintain. i wrote somewhat 700 to
800 unit tests with this and have yet to stumble upon case which
this helper couldn't handle. perhaps i'm lucky though i'd say this
approach is pretty solid.

---

## wait there's more

still think this stinks? well allow me to introduce the support for
drivers. if this is first time you hear about testing with drivers,
the approach most likely be new to you. it is helpful to learn
nonetheless.

let's rewind to the beginning, how to prepare compiler:

```js
describe('Directive: pupperLeggies', () => {
  let compile;

  beforeEach(module('yourModule'));

  beforeEach(inject(($compile, $rootScope) => {
    compile = createCompiler('<pupper-leggies count="4" />', $rootScope, $compile, {
      text: () => this.$.text()
    });
  }));
});
```

this time I gave fourth argument to `createCompiler`. it is something
you can access in a callback of `compile` as a third argument:

```js
compile((scope, element, driver) => {
  expect(driver.text()).toBe('4');
});
```

simple example is simple, though consider component with a bunch of
elements that need to be targeted, their attributes checked, clicked,
some form elements massaged, etc.

each property you set in `driver` can access other driver properties
through `this`:

```js
const driver = {
  textClass: '.component-text-child'
  text: function() { return this.$.find(this.textClass).text(); }
};

let compile = createCompiler('<pupper-leggies count="4" />', $rootScope, $compile, driver);

compile((scope, element, driver) {
  expect(driver.text()).toBe('whatever .component-text-child text is');
});
```

you probably wonder dafuq is `this.$`. it's simply a reference to root
component element. Hopefully this speaks for itself:

```js
const driver = {
  // receives element as argument:
  text: element => element.find('.text-element').text(),

  // uses this.$ to reach same element:
  nestedText: function(selector) { return this.$.find(selector).text(); },
};

let compile = createCompiler('<pupper-leggies count="4" />', $rootScope, $compile, driver);

compile((scope, element, driver) {
  expect(driver.text(element)).toBe('text from .text-element');
  expect(driver.nestedText('child')).toBe('text from .child');
});
```

suppose for whatever reason you need to check if some child element has
expected attributes with expected values. Again, under many conditions.
below is one example to do this (taken from <a href="https://github.com/argshook/orodarius/blob/2df5f232822f98993977235e054c8f539922c4aa/test/unit/sidebar/sidebar-list.directive.spec.js" target="_blank">here</a>):


```js
const driver = {
  validateAttrs: attrsAndValues =>
    attrsAndValues
      .reduce(
        (acc, [attr, value]) =>
          this.$.find('.important-element').attr(attr) === value,
        false
      )
};

let compile = createCompiler('<sidebar-list />', $rootScope, $compile, driver);

compile((scope, element, driver) => {
  const attrsAndValues = [
    [ 'currentSubreddit', '$ctrl.currentSubreddit' ],
    [ 'video-item', 'item' ],
    [ 'index', '$index + 1' ]
  ];

  expect(driver.validateAttrs(attrsAndValues)).toBe(true);
});
```

---

in order not to bore myself rewriting same `createCompiler` preparations
for each test suite, i made a snippet that lays out the scaffold. It
basically renders this:

```js
describe('Component: pupperLeggies', () => {
  const compile;

  const parentScopeMock = {};

  const elementAttrsMock = {};

  const driver = {
    root: function() { return this.$.find('.pupper-root'); }
  };

  beforeEach(module('butcher'));

  beforeEach(inject(($compile, $rootScope) => {
    compile = createCompiler('<pupper-leggies />', $rootScope, $compile, driver);
  }));

  it('should exist', () => {
    compile(parentScopeMock, elementAttrsMock, (scope, element, driver) => {
      expect(driver.root().length).toBe(1);
    });
  });
});
```

---

nothing really ecstatic though i find it very useful. the compilation
setup is simplified a lot both for directives (isolate scope or not)
and components. what used to be tedious work is quick and easy now
which allows to focus on tests more.

