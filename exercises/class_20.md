## :sparkles: _Update films collection: camelCasify fields and parse values_

```js
db.films.updateMany(
  {},
  {
    $rename: {
      Actors: 'actors',
      Category: 'category',
      Description: 'description',
      Length: 'length',
      Rating: 'rating',
      'Rental Duration': 'rentalDuration',
      'Replacement Cost': 'replacementCost',
      'Special Features': 'specialFeatures',
      Title: 'title',
    },
  }
);
db.films.find().forEach(x => {
  x.actors = x.actors.map(x => ({
    firstName: x['First name'],
    lastName: x['Last name'],
    actorId: x.actorId,
  }));
  x.length = parseFloat(x.length);
  x.rentalDuration = parseFloat(x.rentalDuration);
  x.replacementCost = parseFloat(x.replacementCost);
  x.specialFeatures = x.specialFeatures.split(/,/g);
  db.films.save(x);
});
```

## 1. Show title and special_features of films that are PG-13

```js
db.films.find({ rating: 'PG-13' }, { title: 1, specialFeatures: 1 });
```

## 2. Get a list of all the different films duration.

```js
db.films.distinct('length');
```

```js
var a = new Set();
db.films
  .find()
  .sort({ length: 1 })
  .forEach(x => a.add(x.length));
print([...a]);
```

## 3. Show title, rental_rate and replacement_cost of films that have replacement_cost from 20.00 up to 24.00

```js
db.films.find(
  { replacementCost: { $gte: 20, $lte: 24 } },
  { title: 1, rentalRate: 1, replacementCost: 1 }
);
```

## 4. Show title, category and rating of films that have 'Behind the Scenes' as special_features

```js
db.films.find(
  { specialFeatures: ['Behind the Scenes'] },
  { title: 1, category: 1, rating: 1 }
);
```

## 5. Show first name and last name of actors that acted in 'ZOOLANDER FICTION'

```js
db.films.find(
  { title: 'ZOOLANDER FICTION' },
  { actors: { firstName: 1, lastName: 1 } }
);
```

```js
db.films.find({ title: 'ZOOLANDER FICTION' }).forEach(x => {
  print(x.actors.map(x => ({ firstName: x.firstName, lastName: x.lastName })));
});
```

```js
db.films
  .find({ title: 'ZOOLANDER FICTION' })
  .map(x =>
    x.actors.map(x => ({ firstName: x.firstName, lastName: x.lastName }))
  );
```

## 6. Show the address, city and country of the store with id 1

```js
db.stores.find({ _id: 1 }, { Address: 1, City: 1, Country: 1 });
```

## 7. Show pair of film titles and rating of films that have the same rating.

```js
db.films.aggregate([
  { $group: { _id: '$rating', films: { $push: '$title' } } },
]);
```

```js
var a = {};
db.films.find().forEach(x => {
  (a[x.rating] = a[x.rating] || []).push({ title: x.title, rating: x.rating });
});
JSON.stringify(a, null, 2);
```

## 8. Get all the films that are available in store id 2 and the manager first/last name of this store (the manager will appear in all the rows).

```js

```
