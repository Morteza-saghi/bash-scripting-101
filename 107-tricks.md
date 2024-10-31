# Shell Scripting Redirection and Exit Status Guide

This guide explains essential shell scripting operators and commands to handle **input**, **output**, **error redirection**, and **exit statuses** effectively.

## File Descriptors Overview

In shell scripting, file descriptors are numeric identifiers that control how data flows in and out of commands. The main file descriptors are:

- **`0` (stdin)** - Standard input, where commands read input.
- **`1` (stdout)** - Standard output, where commands print normal output.
- **`2` (stderr)** - Standard error, where commands print error messages.

## Redirection Operators

Redirection operators allow us to control the flow of `stdin`, `stdout`, and `stderr`. Here are the most commonly used redirection operators:

### `0>` - Standard Input (`stdin`)

Redirects a file as input to a command. Typically, this is used implicitly with `<`.

```
command < input.txt       # Redirects input from input.txt to the command
command 0< input.txt      # Equivalent to the above
```


### `1>` - Standard Output (stdout)
Redirects the standard output of a command to a file.

```
command > output.txt      # Redirects standard output to output.txt
command 1> output.txt     # Equivalent to the above
```

### `2>` - Standard Error (stderr)
Redirects the standard error of a command to a file.


```
command 2> error.log      # Redirects standard error to error.log
&> - Redirect Both stdout and stderr
Combines both stdout and stderr into the same file.


```
command &> combined.log   # Redirects both output and error to combined.log
2>&1 - Redirect stderr to stdout
Redirects stderr to wherever stdout is currently directed. This is commonly used to combine outputs.


```
command > output.log 2>&1 # Redirects output to output.log and error to the same file
>&2 - Redirect Output to stderr
Redirects any output to stderr, which is helpful for custom error messages.


```
echo "An error occurred" >&2   # Sends this message to stderr
&>/dev/null - Suppress Output and Error Messages
Redirects both stdout and stderr to /dev/null, effectively discarding all output and error messages. This is useful for commands where output is unnecessary.


```
command &>/dev/null     # Suppresses all output and errors
```

## Exit Status Commands
The exit status of a command is a numeric code representing whether the command ran successfully.

- An exit status of 0 indicates success.
- A non-zero exit status (e.g., 1) indicates an error.
- Exit statuses can be checked to control the flow of a script.

```
exit 0 - Successful Exit
Exits a script or function with a 0 status, signaling success.
```

```
exit 0   # Exits with a status of 0 (success)
exit 1 - Error Exit
```
Exits a script or function with a non-zero status, signaling an error. By convention, exit 1 signifies a general error.


```
exit 1   # Exits with a status of 1 (error)
```
---

###‌ Checking the Exit Status of Commands
The special variable $? stores the exit status of the last executed command, which you can use to check success or failure.


```
command
if [ $? -eq 0 ]; then
    echo "Command succeeded"
else
    echo "Command failed"
fi
```

Alternatively, use a direct check:

```
if command; then
    echo "Command succeeded"
else
    echo "Command failed"
fi
```

### set -e - Exit Immediately on Error
By using set -e, a script will exit immediately if any command returns a non-zero exit status, helping catch errors early.


```
set -e
command1    # If this command fails, the script exits immediately
command2
```

| Operator       | Description                                 | Example                        |
|----------------|---------------------------------------------|--------------------------------|
| `0>`           | Redirect `stdin`                           | `command 0< input.txt`         |
| `1>`           | Redirect `stdout`                          | `command 1> output.txt`        |
| `2>`           | Redirect `stderr`                          | `command 2> error.log`         |
| `&>`           | Redirect both `stdout` and `stderr`        | `command &> combined.log`      |
| `2>&1`         | Redirect `stderr` to the same as `stdout`  | `command > output.log 2>&1`    |
| `>&2`          | Redirect output to `stderr`                | `echo "Error message" >&2`     |
| `&>/dev/null`  | Discard both output and error messages     | `command &>/dev/null`          |
| `exit 0`       | Exit with success status                   | `exit 0`                       |
| `exit 1`       | Exit with error status                     | `exit 1`                       |
| `set -e`       | Exit on error                              | `set -e`                       |
