# MagicNumber Solution

The solidity compiler compiles the Solidity code into machine assembly code that can be executed by the EVM.
More specifically, the bytecode translates into opcodes executed with a stack machine.
The bytecode contains both the `Initialization bytecode` and the `Runtime bytecode` sequentially in that order.

- Init bytecode: Executed when the contract is first deployed and returns the runtime bytecode. Responsible for preparing contract and returning the runtime bytecode
- Runtime bytecode: This is the actual code run after the contract creation. 



Runtime bytecode:

```
# We want store the number 42 in memory and return it
# The opcodes we want to use is MSTORE and RETURN

# 1. 
PUSH1 0x2A  # Push 42 onto stack
PUSH1 0x80  # Store in memory slot 0x80
MSTORE

# 2.
PUSH1 0x20  # value of 42 is padded to 32 bytes in memory
PUSH1 0x80  # return value at slot 0x80
F3          # return


Real bytecode
602A60805260206080F3
```


Init bytecode:
```
Store runtime code 602A60805260206080F3 to memory

PUSH10 602A60805260206080F3
PUSH1 0
MSTORE

# Return 10 bytes from memory starting at offset 22,
# MSTORE stores 32 bytes so runtime code is left-padded with 22 bytes
# 0x00000000000000000000000000000000000000000000602A60805260206080F3

PUSH1 0x0a    # PUSH 10 onto stack 
PUSH1 0x16 # 22 bytes offset
RETURN  

# Could also use CODECOPY opcode to copy runtime code at the end but we will 
# just simply use PUSH and RETURN

Real init bytecode
69602A60805260206080F3600052600A6016F3
```