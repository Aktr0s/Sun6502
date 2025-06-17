# Sun6502 Hobby Computer

## My first try at electonics. Wish me luck.

# Memory Map:

| Address Range   | Size   | Description        |
|-----------------|--------|--------------------|
| `$0000-$7FFF`   | 32KB   | RAM                |
| `$8000-$83FF`   | 1KB    | VIA #1             |
| `$8400-$87FF`   | 1KB    | VIA #2             |
| `$8800-$8BFF`   | 1KB    | UART               |
| `$8C00-$8FFF`   | 1KB    | Unused             |
| `$9000-$BFFF`   | 12KB   | Expansion Port     |
| `$C000-$FFFF`   | 16KB   | ROM                |

> **Total:** 64KB

## More Info:
While VIA's and UART have 1KB they only use first needed bits.

VIA#2 Port (Expansion) does not have CE/ signal but Bus Expansion Port does.

It should be compatible with Ben's Breadboard 6502 but you **HAVE** to change memory adressess since the memory map is different as well as elements connected to VIA

### The project took inspiration from:
* Ben Eater Breadboard 6502 Computer
* PE6502 by Putnam Electronics

> [!WARNING]
> This project is yet untested. I yet recently ordered a PCB. When i confirm that the project is indeed working i will result in next commit