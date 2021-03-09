# Carrot Chase 🥕

A cute little script to make me smile. 😁

## Can the 🐰 Reach the 🥕? 

![example][example]

## Execution

```sh
./carrot_chase.rb
```

or

```sh
ruby carrot_chase.rb
```

## Tracking Progress

A temp file is used to track progress across multiple calls. This creates incremental progress,
as opposed to the pure randomness of the original design. It also keeps the position of the sun
the same for each chase.

The temp file is stored in the directory returned by `Dir.tmpdir`, and is called
`carrot_chase.json`.

[example]:  assets/example.png
