# API Documentation

This page documents all the commands available in Star scripts, with descriptions, parameters, return values, and examples.

---

## Arithmetic and Value Commands

### `math <number1> <operator> <number2>`
- **Description:** Performs basic arithmetic operations.
- **Parameters:**
  | Name | Type | Description |
  |------|------|-------------|
  | `number1` | number | First operand |
  | `operator` | string | `"+"`, `"-"`, `"*"`, `"/"` |
  | `number2` | number | Second operand |
- **Returns:** Result of the arithmetic operation
- **Example:**
```star
math 5 + 3  -- returns 8
math 10 / 2 -- returns 5
````

---

### `random <min> <max>`

* **Description:** Returns a random number between `min` and `max`.
* **Parameters:**

  | Name  | Type   | Description   |
  | ----- | ------ | ------------- |
  | `min` | number | Minimum value |
  | `max` | number | Maximum value |
* **Returns:** Random number between `min` and `max`
* **Example:**

```star
random 1 10  -- returns a random number between 1 and 10
```

---

### `len <string>`

* **Description:** Returns the length of a string.
* **Parameters:**

  | Name     | Type   | Description           |
  | -------- | ------ | --------------------- |
  | `string` | string | The string to measure |
* **Returns:** Number of characters in the string
* **Example:**

```star
len "hello" -- returns 5
```

---

### `input <prompt>`

* **Description:** Prompts the user for input.
* **Parameters:**

  | Name     | Type   | Description                  |
  | -------- | ------ | ---------------------------- |
  | `prompt` | string | Text to display before input |
* **Returns:** User input as a string
* **Example:**

```star
input "Enter your name:"  -- waits for user input
```

---

### `concat <a> <b>`

* **Description:** Concatenates two values into a string.
* **Parameters:**

  | Name | Type | Description  |
  | ---- | ---- | ------------ |
  | `a`  | any  | First value  |
  | `b`  | any  | Second value |
* **Returns:** Concatenated string
* **Example:**

```star
concat "Hello, " "world!"  -- returns "Hello, world!"
```

---

### `type <value>`

* **Description:** Returns the type of a value.
* **Parameters:**

  | Name    | Type | Description        |
  | ------- | ---- | ------------------ |
  | `value` | any  | The value to check |
* **Returns:** `"string"`, `"number"`, `"boolean"`, or `"nil"`
* **Example:**

```star
type 42      -- returns "number"
type "hi"    -- returns "string"
```

---

### `equal <a> <b>`

* **Description:** Checks if two values are equal.
* **Parameters:**

  | Name | Type | Description  |
  | ---- | ---- | ------------ |
  | `a`  | any  | First value  |
  | `b`  | any  | Second value |
* **Returns:** `true` if equal, `false` otherwise
* **Example:**

```star
equal 5 5   -- returns true
equal 5 10  -- returns false
```

---

### `greater <a> <b>`

* **Description:** Checks if `a` is greater than `b`.
* **Parameters:**

  | Name | Type   | Description   |
  | ---- | ------ | ------------- |
  | `a`  | number | First number  |
  | `b`  | number | Second number |
* **Returns:** `true` if `a > b`, `false` otherwise
* **Example:**

```star
greater 10 5   -- returns true
greater 2 3    -- returns false
```

---

### `less <a> <b>`

* **Description:** Checks if `a` is less than `b`.
* **Parameters:**

  | Name | Type   | Description   |
  | ---- | ------ | ------------- |
  | `a`  | number | First number  |
  | `b`  | number | Second number |
* **Returns:** `true` if `a < b`, `false` otherwise
* **Example:**

```star
less 2 5    -- returns true
less 10 3   -- returns false
```

---

### Logical Operators: `and`, `or`, `not`

#### `and <a> <b>`

* **Description:** Logical AND of two values.
* **Returns:** `true` if both `a` and `b` are truthy
* **Example:**

```star
and true false  -- returns false
```

#### `or <a> <b>`

* **Description:** Logical OR of two values.
* **Returns:** `true` if at least one value is truthy
* **Example:**

```star
or false true  -- returns true
```

#### `not <a>`

* **Description:** Logical NOT.
* **Returns:** Inverts the boolean value
* **Example:**

```star
not true  -- returns false
```

---

## Execution Commands

### `print <value>`

* **Description:** Prints a value to the console.
* **Parameters:** `<value>` any
* **Returns:** None
* **Example:**

```star
print "Hello World"
print math 2 + 3
```

---

### `let <name> = <value>`

* **Description:** Creates a new variable.
* **Parameters:**

  | Name    | Type   | Description     |
  | ------- | ------ | --------------- |
  | `name`  | string | Variable name   |
  | `value` | any    | Value to assign |
* **Example:**

```star
let x = 42
let message = "Hello"
```

---

### `const <name> = <value>`

* **Description:** Creates a constant variable (cannot be changed).
* **Parameters:** Same as `let`
* **Example:**

```star
const pi = 3.14159
```

---

### `set <name> to <value>`

* **Description:** Changes the value of an existing variable.
* **Parameters:**

  | Name    | Type   | Description   |
  | ------- | ------ | ------------- |
  | `name`  | string | Variable name |
  | `value` | any    | New value     |
* **Example:**

```star
set x to 100
```

---

### `if <condition>` / `while <condition>`

* **Description:** Conditional and looping statements.
* **Parameters:** `<condition>` any expression returning boolean
* **Example:**

```star
if equal x 10
    print "x is 10"
conclude

while less x 5
    print x
    set x to math x + 1
conclude
```
