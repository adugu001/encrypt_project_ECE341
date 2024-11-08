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
   - Row n is rotated n slots to the left
5) Shuffling of columns.
   - Pattern of shuffle is either uniform or can be determined by the particular round's key 
#Decryption
The decryption process... 


**Design Restraints**: 
- Function in frequency range [10Mhz, 500Mhz]
- 2^64 bit memory
- Tech Resources: 110,000
- Mem Units: 200
- Buffers not permitted internally
- Integrated look-up table/ FF combination
- Delays: look-up-table: 175ps, setup: 25ps, hold: 14ps, flip flop propagation delay: 125ps

**Ideas For Implementation**:
- Possibly have inputs to toggle between Encrypt, Decrypt, ECB and CBC (Much like a control input for reset)

**Summary of Material**:
1) Block Cipher Mode of Operation (<a href="https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation">Wikipedia Page</a>)
      -Uses block cipher to scramble data
      -initialization vector must be non repeating
      -Electronic Codebook (ECB):
      	Message divided into blocks and encrypted separately
      	Lack of diffusion for repeated sequences
      	data + key = encrypted	encrypted - key = data
      -Cipher Block Chaining (CBC):
      	Initialization vector encrypts first data block
      	Encrypted data block acts as initialization vector for next block
      -Possibly have inputs to toggle between Encrypt, Decrypt, ECB and CBC.

2) AESAVS
      -Specifies Tests required to verify effectiveness of implementation
      -Tests ECB and CBC modes of operation
      -Types of tests:
      	A) known answer test
      		-Types of K.A. tests: GFSbox, KeySBox, Variable Key, Variable Text
      		-AESVAS appendices B-E contain values for each known answer test (p 16-51)
      	B) Multi-block Message Test
      		-For each supported mode 10 messages supplied with length 
      		of each message being the block size.
      		-Tests longer messages of data, instead of just a single block
      		-EBC - Identical blocks of data in longer message should result 
      		in identical cipher-data
      		-CBC - Because each block iz XORed with previous block, identical
      		blocks of data should NOT match each other
      	C) Monte Carlo Algorithm Test
      		-??? Really confused by the pseudo code
3) NIST.FIPS.197
      -keyExpansion()			
      	-Generates 4*(numRounds+1) words(seq of 4 bytes)
      		-10 rounds -> 44 words
      		-Stores key as array of words[44]
      		-Uses fixed-word round constants stored in Rcon[10], each round key uses distinct constant
      			**Are rounds constants XORed with the input to keyExpansion?
      		-Uses shiftRows() then subBytes()
      		-First 4 words of expanded key are the key, each word after that is generated
      		by:	w[i] = w[i-4] XOR subWord(rotWord(w[i-1)) XOR Rcon[i/4]
      -cipher(128-bit-block-of-data, numRounds, keyExpansion(key))
      	-Last round does not mix columns
      -Function and inverse function for each step
      	-subBytes()    <--> invSubBytes()	
      		-substitutes bytes with values on lookup table
      		-Potential Lookup table values on HEX format: p14(pdf pg 22) p23(pdf pg 31)
      	-mixCol()      <--> invMixCol()
      		**Are columns mixed the same each time? or is order affected by the key?
      	-shiftRows()   <--> invShiftRows()
      		-Simple, just shift and reverse shift
      	-addRoundKey()		
      		-acts as both. XOR operation

