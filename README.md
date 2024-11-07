# encrypt_project_ECE341
Model for encryption hardware analyzing 128-bit size data blocks  

**Members**: 
Andrew Duguay, Mark Johnston, Chaturanga Liyanage

**Overview of Process**: 
Using the AES, implement an algorithm that can be synthesized into hardware to encrypt and decrypt 128-bit sized blocks of data. The encryption will happen in four steps: 
1) XOR with the current round's cipher key (first operation on round 1, last operation on subsequent rounds).
   - Simple bitwise XOR operation
   - Initial cipher key generated or stored??
   - Data from encryption round n is used to generate cipher key for encryption round n+1
2) Inversion of the bytes of data using Galois field operations
   - A look-up table will be used to implement this step using combinational logic gates
   - Byte data will be manipulated as if using polynomial notation
3) Rotation of rows
   - Byte converted into 4x4 matrix, with bits 0-3 -> column 1, 4-7 -> column 2, etc.
   - Row n is roted n slots to the (left/right?)
5) Shuffling of columns.
   - Pattern of shuffle is either uniform or can be determined by the particular round's key 

**Design Restraints**: 
- Function in frequency range [10Mhz, 500Mhz]
- 2^64 bit memory
- Tech Resources: 110,000
- Mem Units: 200
- Buffers not permitted internally
- Integrated look-up table/ FF combination
- Delays: look-up-table: 175ps, setup: 25ps, hold: 14ps, flip flop propogation delay: 125ps

