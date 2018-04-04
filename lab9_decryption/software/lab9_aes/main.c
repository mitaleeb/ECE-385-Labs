/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000040;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

// Declarations
uint* keyExpansion (unsigned char key[40]);
void addRoundKey(unsigned char* state, uint* w, int round);
void rotWord(uint* input);
void subBytes(unsigned char* state);
void subWord(uint* word);
void shiftRows(uchar* state);
void mixColumns(uchar* state);
uchar xtime(uchar a);

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *  
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *  
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	// Implement this function
	uchar state[16];

	// Change to hex
	uchar hexmsg[16];
	int i;
	int count = 0;
	uchar lastChar = msg_ascii[0];
	for (i = 0; i < 32; i++) {
		if (i % 2 == 1) {
			hexmsg[count] = charsToHex(lastChar, msg_ascii[i]);
			count++;
		}
		lastChar = msg_ascii[i];
	}

	uchar hexkey[16];
	count = 0;
	lastChar = key_ascii[i];
	for (i = 0; i < 32; i++) {
		if (i % 2 == 1) {
			hexkey[count] = charsToHex(lastChar, key_ascii[i]);
			count++;
		}
		lastChar = key_ascii[i];
	}

	// Turn into 4x32 int
	int j;
	count = 0;
	for (i = 0; i < 4; i++) {
		key[i] = 0;
		for (j = 0; j < 4; j++) {
			key[i] <<= 8;
			key[i] |= hexkey[count];
			count++;
		}
	}

	/*printf("Key in HEX\n");
	for (i = 0; i < 4; i++) {
		printf("%08X", key[i]);
	}
	printf("\n");*/

	// Generate the key schedule
	uint* w = keyExpansion(hexkey);

	// print key schedule for debugging
	/*int q = 0;
	printf("key schedule:\n");
	for(q=0; q<44; q++) {
		printf("%08X ", w[q]);
		if((q+1)%4 == 0) printf("\n");
	}*/

	printf("\nkey expansion final val:\n");
	printf("%08x%08x%08x%08x \n\n", w[40], w[41], w[42], w[43]);

	for (i = 0; i < 16; i++) {
		state[i] = hexmsg[i];
	}

	addRoundKey(state, w, 0);

	for (i = 1; i < 10; i++) {
		// Print current state for debugging
		/*printf("\nState at start of round %d\n", i);
		int j;
		for (j = 0; j < 16; j++) {
			printf("%02x ", state[j]);
			if ((j+1) % 4 == 0)
				printf("\n");
		}*/

		subBytes(state);
		/*printf("\nsubBytes: \n");
		for (j = 0; j < 16; j++) {
			printf("%02x ", state[j]);
			if ((j+1) % 4 == 0)
				printf("\n");
		}*/

		shiftRows(state);
		/*printf("\nshiftRows: \n");
		for (j = 0; j < 16; j++) {
			printf("%02x ", state[j]);
			if ((j+1) % 4 == 0)
				printf("\n");
		}*/

		mixColumns(state);
		/*printf("\nmixColumns: \n");
		for (j = 0; j < 16; j++) {
			printf("%02x ", state[j]);
			if ((j+1) % 4 == 0)
				printf("\n");
		}*/

		addRoundKey(state, w, i);
	}

	subBytes(state);
	shiftRows(state);
	addRoundKey(state, w, 10);

	uchar msg_enc_hex[16];
	for (i = 0; i < 16; i++) {
		msg_enc_hex[i] = state[i];
	}
	// Turn into 4x32 int
	count = 0;
	for (i = 0; i < 4; i++) {
		msg_enc[i] = 0;
		for (j = 0; j < 4; j++) {
			msg_enc[i] <<= 8;
			msg_enc[i] |= msg_enc_hex[count];
			count++;
		}
	}

	// Write to registers
	AES_PTR[0] = key[0];
	AES_PTR[1] = key[1];
	AES_PTR[2] = key[2];
	AES_PTR[3] = key[3];


	// don't forget to free any allocated memory
	free(w);
}

/**
 * keyExpansion
 * Helper function to perform AES encryption.
 * Takes the Cipher Key and performs a Key Expansion to generate a
 * series of Round Keys (4-Word matrix) and store them into Key Schedule
 *
 * Input: key[16] - length 4*Nk byte array holding the encryption key
 * Returns: pointer to the beginning of the key schedule array
 */
uint* keyExpansion (uchar key[16]) {
	int Nk = 4;
	int Nb = 4;
	int Nr = 10;

	uint* w = (uint*) malloc(sizeof(uint) * Nr * (Nk+1));

	// Words are same size as integers = 32 bits
	uint temp;
	int i;
	for (i = 0; i < Nk; i++) {
		uint first4 = key[4*i] << 24;
		uint second4 = key[4*i+1] << 16;
		uint third4 = key[4*i+2] << 8;
		uint fourth4 = key[4*i+3];

		// "or" all together to create a 32 bit word
		w[i] = first4 | second4 | third4 | fourth4;
	}

	// Printing for debugging
	/*printf("\nw(1:4):\n");
	for (i = 0; i < 4; i++) {
		printf("%08X \n", w[i]);
	}
	printf("\n");*/

	for (i = Nk; i < Nb*(Nr+1); i++) {
		temp = w[i-1];
		if (i % Nk == 0) {
			rotWord(&temp);
			subWord(&temp);
			temp ^= Rcon[i/Nk];
		}
		w[i] = w[i-Nk] ^ temp;
	}
	return w;
}

/**
 * addRoundKey
 * Helper function for AES encryption
 * Takes the Cipher Key and
 */
void addRoundKey(unsigned char* state, uint* w, int round) {
	// Note w has length 44
	uint start = round*4;
	uint wIndex = start;
	int i;
	for (i = 0; i < 16; i++) {
		wIndex = start + i/4;
		uchar temp = (uchar)((w[wIndex] >> (8*(3-i%4))) & 0x000000FF);
		state[i] ^= temp;
	}
}

//Rotate Word
void rotWord(uint* input) {
    uint temp_1;
    uint temp_2;

    temp_1 = *input << 8;
    temp_2 = *input & 0xFF000000;
    temp_2 = temp_2 >> 24; 
    *input = temp_1 | temp_2;

}

// SubBytes()
// Loop through each byte in the state and look up the table using the two hex values of the byte as the row and column indicies 
// SBox is stored as a 256 Byte array instead of a 16x16 matrix
void subBytes(unsigned char* state) {
    int i;  
    for(i=0; i<16; i++){
        state[i] = aes_sbox[state[i]];
    }
}

void subWord(uint* word) {

	/*INSERT TYPE FOR ALL TEMP VARIABLES*/
	uchar temp_0 = (uchar)(*word);
	uchar temp_1 = (uchar)((*word >> 8));
	uchar temp_2 = (uchar)((*word >> 16));
	uchar temp_3 = (uchar)((*word >> 24));

	/*INDIVIDUAL BYTES SUBSTITUTED USING S-BOX LOOKUP TABLE*/
	temp_0 = aes_sbox[temp_0];
	temp_1 = aes_sbox[temp_1];
	temp_2 = aes_sbox[temp_2]; 
	temp_3 = aes_sbox[temp_3];
	*word = (temp_3 << 24)|(temp_2 << 16)|(temp_1 << 8)|(temp_0);
}

/**
 * shiftRows
 * The rows in the updating state is cyclically shifted by a certain offset.
 * Row n is left-circulated by n-1 bytes
 * @param state the state that will be changed.
 */
void shiftRows(uchar* state) {
	uchar temp[4][4];

	// Populate the temporary 2-D array
	int i;
	for (i = 0; i < 16; i++) {
		temp[i % 4][i / 4] = state[i];
	}

	// Shift the 2D array
	int n;
	for (n = 0; n < 4; n++) {
		for (i = 0; i < n; i++) {
			uchar tempChar = temp[n][0];
			temp[n][0] = temp[n][1];
			temp[n][1] = temp[n][2];
			temp[n][2] = temp[n][3];
			temp[n][3] = tempChar;
		}
	}

	// Reload the 2D array into the 1D array
	for (i = 0; i < 16; i++) {
		state[i] = temp[i % 4][i / 4];
	}
}

void mixColumns(uchar* state) {
	uchar a[4];

	int i;
	for (i = 0; i < 4; i++) {
		// Get the words of the state
		a[0] = state[(4*i)];
		a[1] = state[(4*i) + 1];
		a[2] = state[(4*i) + 2];
		a[3] = state[(4*i) + 3];

		// perform operations, store in result
		state[(4*i)] = xtime(a[0]) ^ xtime(a[1]) ^ a[1] ^ a[2] ^ a[3];
		state[(4*i) + 1] = a[0] ^ xtime(a[1]) ^ xtime(a[2]) ^ a[2] ^ a[3];
		state[(4*i) + 2] = a[0] ^ a[1] ^ xtime(a[2]) ^ xtime(a[3]) ^ a[3];
		state[(4*i) + 3] = xtime(a[0]) ^ a[0] ^ a[1] ^ a[2] ^ xtime(a[3]);
	}
}

uchar xtime(uchar a) {
	if ((a & 0x80) == 0x80) {
		a <<= 1;
		a ^= 0x1B;
	} else {
		a <<= 1;
	}

	return a;
}

/**
 *
 */

/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	// Implement this function
	// write to enc message registers
	AES_PTR[0] = key[0];
	AES_PTR[1] = key[1];
	AES_PTR[2] = key[2];
	AES_PTR[3] = key[3];

	//printf("AES_PTR[0] = %08x, key[0] = %08x \n", AES_PTR[0], key[0]);

	AES_PTR[4] = msg_enc[0];
	AES_PTR[5] = msg_enc[1];
	AES_PTR[6] = msg_enc[2];
	AES_PTR[7] = msg_enc[3];

	//printf("AES_MSG_ENC: \n%08x\n%08x\n%08x\n%08x", AES_PTR[4], AES_PTR[5], AES_PTR[6], AES_PTR[7]);

	AES_PTR[14] = 1;
	unsigned int counter = 0;
	//printf("\nDONE SIGNAL AES_PTR[15] is %08x before loop\n", AES_PTR[15]);
	while (AES_PTR[15] == 0) {
		counter++;
		continue;
	}
	/*int j = 0;
	for (j = 0; j < 10000; j++) {
		continue;
	}*/

	//printf("\nThe loop ran: %u times\n", counter);

	// read to msg_dec
	msg_dec[0] = AES_PTR[8];
	msg_dec[1] = AES_PTR[9];
	msg_dec[2] = AES_PTR[10];
	msg_dec[3] = AES_PTR[11];
	//printf("AES_PTR[0] = %08x, key[0] = %08x \n", AES_PTR[0], key[0]);
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33] = "ece298dcece298dcece298dcece298dc";
	unsigned char key_ascii[33] = "000102030405060708090a0b0c0d0e0f";
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking, 2 for Dean's special test: ");
	scanf("%d", &run_mode);

	// Added by me to assist in debugging
	if (run_mode == 2) {
		//msg_ascii = "ece298dcece298dcece298dcece298dc";
		//key_ascii = "000102030405060708090a0b0c0d0e0f";
		encrypt(msg_ascii, key_ascii, msg_enc, key);
		printf("\nEncrypted message is: \n");
		int i = 0;
		for(i = 0; i < 4; i++){
			printf("%08x", msg_enc[i]);
		}
		printf("\n");
		decrypt(msg_enc, msg_dec, key);
		printf("\nDecrypted message is: \n");
		for(i = 0; i < 4; i++){
			printf("%08x", msg_dec[i]);
		}
		printf("\n");
	}

	else if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}
