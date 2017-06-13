
# Exploring Different Ways Of Modeling Polymorhic React Props In Purescript

This repository contains tests and benchmarks of several ways to model
polymorphic react props in Purescript. This is, by no means, all possible ways you
can express props in PS. In fact, many old libraries model props as an
`Array ReactProps`. However, it does not provide safety, and does an extra step
conventing the array to an object and back.

Starting from `PS 0.11`, it's possible to model props in a much more efficient
and elegant way using `Union`s. It does however involve overlapping instances.

As an alternative solution that does not require overlapping instances, this
repo also explores modeling props as a
[`variant`](https://github.com/natefaubion/purescript-variant).

In total, it currently contains:

1. Union + Data (a perfect looking API)
2. Variant (does not require overlapping instances, better type inference)
3. Union + Newtype (more efficient, in addition to a perfect looking API)

All them contain benchmarks, unit tests and an example of how the API will look.
You are welcome to contribute your solution, if you feel like it.

## How Results Look

### Union + Data

```purescript
twoInputs :: Array ReactElement
twoInputs =
  [ input { iconPosition: Right } []
  , input { labelPosition: LeftCorner } []
  ]
```

### Variant

```purescript
twoInputs :: Array ReactElement
twoInputs =
  [ input (defaultInputProps { iconPosition = right }) []
  , input (defaultInputProps { labelPosition = leftCorner }) []
  ]
```

### Union + Newtype

```purescript
twoInputs :: Array ReactElement
twoInputs =
  [ input { iconPosition: right } []
  , input { labelPosition: leftCorner } []
  ]
```

## Benchmarks

| Name                | Op/s        | % max | +-(%) |
|---------------------|-------------|-------|-------|
| union data props    | 898213.06   | 5.88  | 0.48  |
| variant props       | 2111763.25  | 13.82 | 1.30  |
| union newtype props | 15275714.71 | 100   | 1.02  |

As you can see using `Newtype` is almost 20x faster than using `Data`. This is
because `Newtype`s only provide type information; they get erased at runtime and
they have the same representation as the type they wrap (in this case `String`).

This means that props are getting represented at runtime the same way as we would
write them by hand in JS.

We get type safety, far fewer bugs, ease of maintenance - all without sacrificing
performance.

## Syntax

Since, `Union` models props in a fairly elegant way, we get perfect readability,
making Purescript to be one of the best languages to write React Components in.

Compare those two pieces of code that express the same:

```jsx
<div>
  <Input iconPosition="right"/>
  <Input labelPosition="left corner"/>
</div>
```

```purecript
  [ input { iconPosition: right } []
  , input { labelPosition: leftCorner } []
  ]
```

same, but with helpers:

```purescript
  [ input_ { iconPosition: right }
  , input_ { labelPosition: leftCorner }
  ]
```

Pretty good, especially considering that we get compile-time verification that
props have valid values.

And when we start supplying components to props, `JSX` starts to look verbose,
while `PS` still keeps syntactic noise to the minimum.

```jsx
<Card description={<CardDescription> description </CardDescription>}/>
```

```purescript
card_ { description: cardDescription' "description" }
```

Of course, this is just for demonstration purposes. We don't need to use a
component inside props here. Our props are polymorphic, so we would pass a String
instead `card_ { description: "description" }` or `card' "description"`.
