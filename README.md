legit
=====

A language whose programs are defined entirely by the graph formed by a Git repositories commits. Inspirations: [Befunge](https://esolangs.org/wiki/Befunge), [Brainfuck](https://esolangs.org/wiki/Brainfuck), [Folders](https://esolangs.org/wiki/Folders).

(This specification will probably not be stable for a while.)

Memory
------

Two types of data structures are available: A stack, and an endless tape. Both hold signed integers.

Execution
---------

Execution starts at the commit pointed to by the master branch. Commit messages can contain a series of single-word instructions, seperated with spaces, which are executed one by one.

After executing a commit with a tag, jump to the branch with the same name. Otherwise:

- If a commit has only one parent, execution will continue there after executing all instructions in the current commit.
- If a commit has multiple parents (numbered 1, 2, 3, ...), the top stack element will be popped. If that element is n, to go (n-1)-th parent, or to the last one, if there are less than (n-1) parents.

Instructions
------------

- getchar: read char from STDIN and place it on the stack
- putchar: pop top stack element and write it to STDOUT as a char
- <Letter>: push ASCII value of that letter on the stack
- <Number>: push the number on the stack

- read: place value of current cell on the stack
- write: pop top stack element and write it to the current cell
- left: pop top stack value, move left for that many places
- right: pop top stack value, move right for that many places

- add: pop two topmost stack values, add them, push result on the stack
- sub: pop two topmost stack values, subtract top one from bottom one, push result on the stack
- dup: duplicates topmost stack value
- cmp: pops two top values, pushes 1 if bottommost one is larger, 0 otherwise

- quit: stop the program