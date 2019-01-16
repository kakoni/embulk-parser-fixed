[![Build Status](https://travis-ci.org/kakoni/embulk-parser-fixed.svg?branch=master)](https://travis-ci.org/kakoni/embulk-parser-fixed)

# Fixed width parser plugin for Embulk

Fixed width parser. Useful for parsing fixed width format files.
Can be used to transform `FirstSecond Third` line to `{key: "First", key2: "Second", key3: "Third"}`

## Overview

* **Plugin type**: parser
* **Guess supported**: no

## Configuration

- **columns**: declares the list of columns, their types and positions as range in input. Values will be assigned to these in order.
- **strip_whitespace**: Strip whitespace from parsed values. (bool, default: true)

## Example

```yaml
in:
  type: any file input plugin type
  parser:
    type: fixed
    columns:
    - {name: first, type: string, pos: 0..1}
    - {name: second, type: string, pos: 3..7}
    - {name: third, type: string, pos: 10..12}

```

## Install plugin

```
$ embulk gem install embulk-parser-fixed
```
