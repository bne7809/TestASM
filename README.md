# TestASM

Small x86-64 assembly programs for Windows, built freestanding with no C runtime.
The assembly is hand-written MASM (`ml64`); a thin C++ layer provides the two
console I/O calls and the process entry point. Everything links against
`kernel32` only, with the default C/C++ runtime stripped out.

## Programs

- **helloworld** — writes a string to the console. The minimal end-to-end test
  of the assembly, build, and I/O setup.
- **guessnum** — a number-guessing game. Generates a random target, prints it,
  then loops reading numbers from the console and replying "too big" / "too
  small" until the input matches.

## How it works

The project runs without the C runtime: `/NODEFAULTLIB` at link time, a custom
`mainCRTStartup`, and `remcrt.cpp` to satisfy the few symbols the compiler still
expects. Console I/O goes straight to the Win32 API (`WriteFile`, `ReadConsole`,
`GetStdHandle`), so there is no `printf`/`scanf` and no hidden runtime.

Strings are UTF-16 (`wchar_t`), declared as `WORD` arrays in the assembly.

The C++ side (`src/main.cpp`) exposes two routines to the assembly across an
`extern "C"` boundary:

- `writeLine` — measures a null-terminated wide string and writes it with `WriteFile`.
- `readLine` — reads a line with `ReadConsole` and null-terminates it.

The assembly side (`inc/`) implements its own primitives:

- `itowa` — signed integer to wide-string. Computes the digit count with
  magic-number division (multiply and shift) instead of a divide loop.
- `watoi` — wide-string to signed integer, including a leading `-`.
- `strcmp` — wide-string compare.
- `standard.inc` — the `printStr` / `readStr` macros and `storeRand`, which uses
  the `rdrand` hardware instruction and a divide to produce a bounded value.

`guessnum.asm` follows the Windows x64 calling convention (arguments in
`rcx`/`rdx`, 32-byte shadow space, 16-byte stack alignment) when calling into the
C++ helpers and its own routines.

## Layout

```
src/
  helloworld.asm   program entry (writes a string)
  guessnum.asm     program entry (guessing game)
  main.cpp         Win32 I/O helpers + custom entry point
  remcrt.cpp       runtime stubs so /NODEFAULTLIB links
inc/
  itowa.inc        int  -> wide string
  watoi.inc        wide string -> int
  strcmp.inc       wide string compare
  standard.inc     I/O macros + rdrand-based random
build.bat
run.bat
```

## Build

Pass the program name (the `.asm` file in `src/` without the extension):

```bat
build.bat guessnum
build.bat helloworld
```

This assembles `src/<name>.asm` with `ml64`, compiles `main.cpp` and
`remcrt.cpp` with `cl`, and links them with `/NODEFAULTLIB` against `kernel32`
into `main.exe`.

## Run

```bat
run.bat
```

Runs `main.exe` and prints the exit code.

## Requirements

Windows x64 with the MSVC toolchain on `PATH` (`ml64` and `cl`), for example from
a Visual Studio "x64 Native Tools Command Prompt".
