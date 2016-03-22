#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <openssl/des.h>

#define DES_IV_KEY        "iPcAmErA"
#define DES_KEY_LEN       8u
static int DES_encrypt(const uint8_t *plaintext,uint8_t *ciphertext,int *len,const uint8_t *des_key);
static int DES_decrypt(const uint8_t *ciphertext,uint8_t *plaintext,int *len,const uint8_t *des_key);

//************************************************************************************************
//! brief DES-cbcº”√‹∑Ω Ω≤‚ ‘
//! param[in] argc argv
//! return 0 OK -1 err  (gcc -o des_cbc  des_cbc_test.c  -lcrypto)
//************************************************************************************************
//int main(int argc, uint8_t *argv[])
int main(int argc, char** argv)
{
	uint8_t test_data[] = "fa02fbivylinkshfcIVYLink";
	uint8_t KEY[] = "1ac4ac2c";
	uint8_t ciphertext[256];
	uint8_t plaintext[256];
	int len;
	int i;
	len = strlen(test_data);
	printf("len =%d\n",len);
	if(DES_encrypt(test_data,ciphertext,&len,KEY) < 0) 
	{
		printf("encrypt err!\n");
		return -1;
	}
	printf("len= %d\n",len);
	printf("encrypt message:\n");
    for (i = 0; i < len; i++) 
	{
        printf("%02x", ciphertext[i]);
    }
	printf("\n");
	
	if(DES_decrypt(ciphertext,plaintext,&len,KEY) < 0) 
	{
		printf("decrypt err!\n");
		return -1;
	}
	printf("len =%d\n",len);
	printf("decrypt message:\n");
    for (i = 0; i < len; i++) 
	{
        printf("%02x", plaintext[i]);
    }
	printf("\n");
	printf("plaintext = %s\n",plaintext);
	
    return 0;
}
//************************************************************************************************
//! brief DES decrypt method:   cbc and PKCS7Padding 
//! param[in] ciphertext(value):ciphertext
//! param[in] plaintext(result): plaintext
//! param[in] len(value-result):input ciphertext-len,output plaintext-len
//! param[in] des_key(len=8):  des original key  
//! return 0 ok -1 err
//************************************************************************************************
static int DES_decrypt(const uint8_t *ciphertext,uint8_t *plaintext,int *len,const uint8_t *des_key)
{
	DES_key_schedule ks;
	DES_cblock ivec;
	unsigned char okey[8];
	int size;
	if(ciphertext == NULL || plaintext == NULL || len == NULL || des_key == NULL) return -1;
	size = *len;
	if((size == 0)||(size % 8)) return -1;
	memcpy(ivec,DES_IV_KEY,8);
	memcpy(okey, des_key, 8);  
	DES_set_key_unchecked((const_DES_cblock*)okey, &ks);
    DES_ncbc_encrypt(ciphertext,plaintext,size,&ks,&ivec, DES_DECRYPT);
	// removal PKCS7 Padding
	*len = size - plaintext[size-1];
	return 0;
}
//************************************************************************************************
//! brief DES encrypt method:   cbc and PKCS7Padding 
//! param[in] plaintext(value):   plaintext
//! param[in] ciphertext(result): ciphertext
//! param[in] len(value-result):input plaintext-len,output ciphertext-len
//! param[in] des_key(len=8):  des original key  
//! return 0 ok -1 err
//************************************************************************************************
static int DES_encrypt(const uint8_t *plaintext,uint8_t *ciphertext,int *len,const uint8_t *des_key)
{
	DES_key_schedule ks;
	DES_cblock ivec;
	unsigned char okey[8];
	unsigned char *plain;
	unsigned char padding;
	int size;
	if(ciphertext == NULL || plaintext == NULL || len == NULL || des_key == NULL) return -1;
	if((*len == 0)) return -1;
	// key and ivec set
	memcpy(ivec,DES_IV_KEY,8);
	memcpy(okey, des_key, 8);  
	// PKCS7 Padding
	size = ((*len)/8)*8 + 8;
	plain = malloc(size);
	if(plain == NULL) return -1;
    memcpy(plain, plaintext, *len);
	padding = 8-(*len)%8;
    memset(plain + *len, padding,padding);
	// encrypt
	DES_set_key_unchecked((const_DES_cblock*)okey, &ks);
    DES_ncbc_encrypt(plain,ciphertext,size,&ks,&ivec, DES_ENCRYPT);
	// PKCS7 Padding 
	*len = size;
	free(plain);
	return 0;
}
