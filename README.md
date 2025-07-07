# Sun6502 Hobby Computer

## My first try at electonics. Wish me luck.

# Memory Map:

| Address Range   | Size   | Description        |
|-----------------|--------|--------------------|
| `$0000-$7FFF`   | 32KB   | RAM                |
| `$8000-$83FF`   | 1KB    | VIA #1             |
| `$8400-$87FF`   | 1KB    | UART               |
| `$8800-$8BFF`   | 1KB    | VIA #2             |
| `$8C00-$8FFF`   | 1KB    | Unused             |
| `$9000-$BFFF`   | 12KB   | Expansion Port     |
| `$C000-$FFFF`   | 16KB   | ROM                |

> **Total:** 64KB

> **If you have a previous version of the board notice that UART and VIA #2 addresses are swaped around.**

## More Info:
While VIA's and UART have 1KB they only use first needed bits.

VIA#2 Port (Expansion) does not have CE/ signal but Bus Expansion Port does.

It should be compatible with Ben's Breadboard 6502 but you **HAVE** to change memory adressess since the memory map is different as well as elements connected to VIA


### The project took inspiration from:
* Ben Eater Breadboard 6502 Computer
* PE6502 by Putnam Electronics

> [!NOTE]
> This project has been tested and is confirmed to work.
> Project uses 74LS TTL chips which are confirmed to work but are not ideal. It is recomended to use CMOS 74HC chips when possible.

## Software:

Software for this computer is based on 
* [msbasic](https://github.com/mist64/msbasic), licensed under the 2-clause BSD license.
As well as it's modified version by 
* [Ben Eater](https://github.com/beneater/msbasic).

Original README files are in "msbasic_for_sun6502" folder.