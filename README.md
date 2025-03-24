This small library allows a user to perform simple unit tests in LSL

# How To

## Installation

You can either download and copy the scripts in your Firestorm Preprocessor include folder manually or if your code is versionned you can use `git submodule add https://github.com/Stella-The-Switch/SLUnit.git include/SLUnit`

---

## Usage

### `AssertIsEqual(string testName, list src, list expected)`

Checks if 2 values are strictly equal

- `string testName`: The name of the test defined in the calling function
- `list src`: boxed\* value to be tested
- `list expected`: boxed\* value to be found

\*Since the type `list` can contain any base type, we can use it as generic type. The same function can therefore take any kind of value.

```lsl
integer foo = 42;
AssertIsEqual("foo should contain the value 42", [ foo ], [ 42 ]);

string bar = "Hello world";
AssertIsEqual("bar should contain the value 'Hello world'", [ bar ], [ "Hello world" ]);

vector color = llGetColor(FRONT_FACE);
AssertIsEqual("front face color should be red", [ color ], [ <1.0, 0.0, 0.0> ]);
```

---

### `AssertContainsExactlyNTimes(string testName, list src, list expected, integer n)`

Searches the boxed value `expected` inside `src` and checks if the value was found exactly `n` times

- `string testName`: The name of the test defined in the calling function
- `list src`: The collection to be searched in
- `list expected`: boxed\* value to be found
- `integer n`: The amount of time `expected` should be found

\*Since the type `list` can contain any base type, we can use it as generic type. The same function can therefore take any kind of value.

```lsl
list nums = [ 1, 2, 3, 2, 4, 5, 6, 2 ];
AssertContainsExactlyNTimes("Searches 2 in nums 3 times", nums, [ 2 ], 3);

list users = [ llGenerateKey(), llGenerateKey(), llGenerateKey(), llGenerateKey() ];
AssertContainsExactlyNTimes("No null keys in user list", users, [ NULL_KEY ], 0);
```

---

## The output

The final result will be displayed on local chat on `DEBUG_CHANNEL`. The message is built with the internal function `AssertCallback(string testName, list actual, list expected, integer result)` which then will call `AssertMessaging(string message)`

Here are some output example

> Running test '_key2 should appear only once'
> 
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Expected '1' Actual '1'
> 
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SUCCESS

> Running test 'message should be 10#2#4'
> 
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Expected '10#2#4' Actual '8c179a2f-9459-a59b-cf26-da89fa3546f3'
> 
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FAILED: Types mismatch

> Running test 'message should be 10#2#4#3#5'
> 
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Expected '10#2#4#3#5' Actual '15#2#4#3#5'
> 
> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FAILED: Values don't match

### How to override `AssertMessaging(string message)`

This function is declared top of the file `Assert.lsl` and wrapped into `#ifndef / #define / #endif` preprocessor commands.

```lsl
#ifndef __ASSERT_MESSAGING__
#define __ASSERT_MESSAGING__
AssertMessaging(string message)
{
    llSay(DEBUG_CHANNEL, message);
}

#endif // __ASSERT_MESSAGING__
```

Therefore, you can declare your own `AssertMessaging(string message)` function. To do so, you simply can define the constant `__ASSERT_MESSAGING__` and the function `AssertMessaging(string message)` before including the file `Assert.lsl`:

```lsl
#ifndef __ASSERT_MESSAGING__
#define __ASSERT_MESSAGING__
AssertMessaging(string message)
{
    MySuperBroadcastFunction(message);
}

#endif // __ASSERT_MESSAGING__

// include the file AFTER defining the constant
#include "Assert.lsl"

// ...
```

---

## Example

I suggest you to use this kind of file structure, but feel free to do as you wish.

- `include/YourScriptToBeTested.lsl` is the file that contains the functions you'll include in your main scripts and that you want to test
- `Test/TestScript.lsl` is the script in which you write test cases
- `include/SLUnit/Assert.lsl` is the library with the unit test functions

```
├── include
│   ├── SLUnit
│   │   └── Assert.lsl
│   └── YourScriptToBeTested.lsl
└── Test
    └── TestScript.lsl
```

Imagine `YourScriptToBeTested.lsl` contains code to handle admin stuff in your main project. We can imagine your code contains such functions

```lsl
list Admins = [];

AddAdmin(key newAdmin)
{
  // some code
}

RemoveAdmin(key adminToRemove)
{
  // some code
}

integer IsAdmin(key userToCheck)
{
  // some code
}
```

You might want to test if those functions work correctly and write tests functions. Create `Test/TestScript.lsl` and include both `SLUnit/Assert.lsl` and `YourScriptToBeTested.lsl`. Like in regular Unit test, you prepare your script, do your tests calls and check the results.

```lsl
#using "SLUnit/Assert.lsl"
#using "YourScriptToBeTested.lsl"

TestAddAdmin()
{
  // Arrange
  Admins = []; // reset the global variables, those are unit tests and should be independants
  key admin1 = llGenerateKey(); // It is okay to use poor naming in tests
  key admin2 = llGenerateKey();
  key admin3 = llGenerateKey();

  // Act
  AddAdmin(admin1);
  AddAdmin(admin2);
  AddAdmin(admin3);
  AddAdmin(admin3);
  AddAdmin(admin1);
  AddAdmin(admin1);
  AddAdmin(admin2);

  // Assert
  /*
    We want to test 2 things:
    the list should have a length of 3
    each key added in the list should appear only once
  */
  AssertIsEqual("Admins list should contain only 3 members", [ llGetListLength(Admins) ], [ 3 ]);
  AssertContainsExactlyNTimes("admin1 should appear only once", Admins, [ admin1 ], 1);
  AssertContainsExactlyNTimes("admin2 should appear only once", Admins, [ admin2 ], 1);
  AssertContainsExactlyNTimes("admin3 should appear only once", Admins, [ admin3 ], 1);
}
```
