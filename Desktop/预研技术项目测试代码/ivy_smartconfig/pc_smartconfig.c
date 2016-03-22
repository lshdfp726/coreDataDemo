#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <sys/time.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string.h>
#define DES_DECRYPT_EN    1u
#if DES_DECRYPT_EN == 1
#include <openssl/des.h>
#define DES_IV_KEY        "iPcAmErA"
#define DES_KEY_LEN       8u
#endif
#define BUFLEN 255
#define MAX_RECV_SIZE 1024
#define UDP_PORT   3301
#define L_UDP_PORT 23456
typedef union
{
    struct { unsigned char s_b1,s_b2,s_b3,s_b4; } S_un_b;
    struct { unsigned short s_w1,s_w2; } S_un_w;
    unsigned int S_addr;
}S_un;

typedef struct
{
    S_un*pkt;
    unsigned int pkt_len;
}Packet;
const char test_pak[] = "{\"body\":{\"server\":\"cloud.landinghome.com:8560\",\"time\":1440753988098,\"date\":\"2015-08-28 17:26:28\",\"GMT\":\"+0800\",\"appver\":1,\"country\":\"Asia\\/Hong_Kong\"},\"header\":{\"msg_id\":\"b178bbd34ad647a981ad9a2821bd123f\",\"action\":\"SET\",\"module\":\"config\",\"send_to\":\"8ee571dbfd64493a9c24f08c02a1bcf0\",\"bodyLen\":\"0\"}}";

static void *strtohex(void *hex, const void *Str);
static unsigned char*pkt_encode(int *len,char*ssid,char*pwd,char pwdtype,char*devid);
Packet* pkt_create(char*devid ,char*ssid,char*pwd,char pwdtype);
void pkt_free(Packet*Hpkt);
void pkt_printf(Packet*Hpkt);
//************************************************************************************************
//! brief DES encrypt method:   cbc and PKCS7Padding
//! param[in] plaintext(value):   plaintext
//! param[in] ciphertext(result): ciphertext
//! param[in] len(value-result):input plaintext-len,output ciphertext-len
//! param[in] des_key(len=8):  des original key
//! return 0 ok -1 err
//************************************************************************************************
#if DES_DECRYPT_EN == 1
int DES_encrypt(const uint8_t *plaintext,uint8_t *ciphertext,int *len,const uint8_t *des_key)
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
#endif
#if 0
int get_ip(const char*ifname,char *ip, int len)
{
    int sock;
    struct sockaddr_in sin;
    struct ifreq ifr;
    sock = socket(AF_INET, SOCK_DGRAM, 0);
    if(sock == -1)
    {
        perror("socket");
        return -1;
    }
    strncpy(ifr.ifr_name, ifname, IFNAMSIZ);
    ifr.ifr_name[IFNAMSIZ - 1] = 0;
    if(ioctl(sock, SIOCGIFADDR, &ifr) < 0)
    {
        perror("iotcl");
        return -1;
    }
    memcpy(&sin, &ifr.ifr_addr, sizeof(sin));
    strcpy(ip, inet_ntoa(sin.sin_addr));
    close(sock);
    printf("wlan0: %s", inet_ntoa(sin.sin_addr));
    return 0;
}
#endif
static void* udp_recv_cfg(void *arg)
{
    int i;
    int sockid = (int)arg;
    struct sockaddr_in recv_Addr;
    char recvbuf[MAX_RECV_SIZE];
    int recvbytes;
    int addrLen;
#if 0
    if ((sockid = socket(AF_INET, SOCK_DGRAM, 0)) == -1)
    {
        perror("Creating socket failed.");
        exit(1);
    }
    int opt = 1;
    setsockopt(sockid, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
#endif
    // Enable receive timeout
    struct timeval timeVal;
    timeVal.tv_sec =  2;             // Seconds
    timeVal.tv_usec = 0;             // Microseconds. 10000 microseconds resolution
    setsockopt(sockid,SOL_SOCKET,SO_RCVTIMEO, &timeVal, sizeof(timeVal));
#if 0
    bzero(&recv_Addr, sizeof(recv_Addr));
    recv_Addr.sin_family = AF_INET;
    recv_Addr.sin_port = htons(L_UDP_PORT);
    recv_Addr.sin_addr.s_addr = htonl(INADDR_ANY);
    if (bind(sockid, (struct sockaddr *)&recv_Addr, sizeof(struct sockaddr)) == -1)
    {
        perror("Bind error.");
        exit(1);
    }
#endif
    while(1)
    {
        addrLen = sizeof(struct sockaddr_in);
        if((recvbytes = recvfrom(sockid, recvbuf,MAX_RECV_SIZE, 0,
                                 (struct sockaddr *)&recv_Addr, &addrLen)) != -1)
        {
            recvbuf[recvbytes] = '\0';
            printf("recv:\n%s\n",recvbuf);
        }
        else
        {
            printf("recvfrom fail\n");
        }
    }
    close(sockid);
    return NULL;
}
int main (int argc, char **argv)
{
    struct sockaddr_in peeraddr, myaddr;
    int sockfd;
    int nOptval;
    char recmsg[4]={0x01,0x02,0x03,0x04};
    char ssid[BUFLEN + 1];
    char pwd[BUFLEN + 1];
    unsigned int socklen;
    Packet* Hpkt;
    pthread_t thread_id;
    pthread_attr_t attr;
    int err;
    char sendbuf[MAX_RECV_SIZE];
    /* Ω” ?”√a? ‰?? */
    printf("ssid:\r\n");
    bzero (ssid, BUFLEN + 1);
    if (fgets (ssid, BUFLEN, stdin) == (char *) EOF)
        exit (0);
    printf("pwd:\r\n");
    bzero (pwd, BUFLEN + 1);
    if (fgets (pwd, BUFLEN, stdin) == (char *) EOF)
        exit (0);
    //??μùaa––?÷∑?
    char *str = ssid;
    while(*str++) if(*str == 0x0a) *str = 0x00;
    str = pwd;
    while(*str++) if(*str == 0x0a) *str = 0x00;

    socklen = sizeof (struct sockaddr_in);
    /* ￥￥Ω? socket ”√”?UDP??—? */
    sockfd = socket (AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        printf ("socket creating error\n");
        exit (1);
    }
    nOptval = 1;
    setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR,(const void *)&nOptval , sizeof(int));
    int bbroadcast=1;
    err=setsockopt(sockfd, SOL_SOCKET, SO_BROADCAST,(char*)&bbroadcast,sizeof(int));
    /* …?÷√?‘∑Ωμ??à??∫?IP–≈?￠ */
    memset (&peeraddr, 0, socklen);
    peeraddr.sin_family = AF_INET;
    peeraddr.sin_port = htons (UDP_PORT);
    inet_pton (AF_INET, "224.0.1.2", &peeraddr.sin_addr);


    /* …?÷√?‘o∫μ??à??∫?IP–≈?￠ */
    memset (&myaddr, 0, socklen);
    myaddr.sin_family = AF_INET;
    myaddr.sin_port = htons (L_UDP_PORT);
    myaddr.sin_addr.s_addr = INADDR_ANY;

    /* ∞????‘o∫μ??à??∫?IP–≈?￠μΩsocket…? */
    if (bind (sockfd, (struct sockaddr *) &myaddr,     sizeof (struct sockaddr_in)) == -1)
    {
        printf ("Bind error\n");
        exit (0);
    }
    pthread_attr_init(&attr);
    pthread_attr_setstacksize(&attr, 1024*1024);
    err = pthread_create(&thread_id, &attr,&udp_recv_cfg,(void*)sockfd);
    printf("after pthread_create...\n");
    if (err != 0)
    {
        printf("\ncan't create thread :[%s]", strerror(err));
        exit (1);
    }
    else
    {
        printf("\n udp_recv_cfg Thread created successfully\n");
        pthread_detach(thread_id);
    }
    pthread_attr_destroy(&attr);
    /* —≠a∑Ω” ?”√a? ‰??μ????￠∑￠à??è≤????￠ */
    for (;;)
    {
        Hpkt = pkt_create("1c5aaad1c42047ebabf4cf6c2198cd3c",ssid,pwd,2);
        pkt_printf(Hpkt);
        //pkt_free(Hpkt);
        //exit(0);
        while(1)
        {
            int i,j;
            peeraddr.sin_addr.s_addr = 0xffffffff;
            memcpy(sendbuf,test_pak,sizeof(test_pak));
            if (sendto(sockfd, sendbuf,strlen(sendbuf)+1, 0, (struct sockaddr *) &peeraddr, sizeof (struct sockaddr_in)) < 0)
            {
                printf ("1sendto error!\n");
                exit (3);
            }
            usleep(10000);
            for(j=0;j<3;j++)
            {
                for(i=0;i<Hpkt->pkt_len;i++)
                {
                    /* ∑￠à????￠ */
                    peeraddr.sin_addr.s_addr = Hpkt->pkt[i].S_addr;
                    if (sendto(sockfd, recmsg, 4, 0, (struct sockaddr *) &peeraddr, sizeof (struct sockaddr_in)) < 0)
                    {
                        printf ("sendto error!\n");
                        exit (3);
                    }
                    usleep(1000);
                }
            }

        }
        printf ("'%s' send ok\n", recmsg);
    }
}
Packet* pkt_create(char*devid ,char*ssid,char*pwd,char pwdtype)
{
    Packet*Hpkt;
    unsigned char*pdata,*qdata,*Pdevid;
    int seq,i,j,pktlen,datalen;
    unsigned char hexid[16];
    unsigned int beacon_num;
    S_un beacon,temp,plen,*ppkt;

    if((pdata=pkt_encode(&datalen,ssid,pwd,pwdtype,devid)) == NULL) return NULL;
    printf("datalen = %d\r\n",datalen);
    for(i=0;i<datalen;i++)
    {
        if(pdata[i]==0xfa || pdata[i]==0xfb || pdata[i]==0xfc)
        {
            printf("%x",pdata[i]);
        }
        else
        {
            printf("%c",pdata[i]);
        }
    }
    printf("\r\n");
    datalen = datalen/2;
    if((strtohex(hexid,devid)) == NULL) return NULL;
    Pdevid= hexid;
    pktlen  = datalen +7;
    beacon_num = (pktlen%3) ? (1+pktlen/3) : (pktlen/3);
    printf("beacon_num = %d\r\n",beacon_num);
    if((Hpkt = (Packet*)malloc(sizeof(Packet))) == NULL) return NULL;
    memset(Hpkt,0,sizeof(Packet));
    Hpkt->pkt_len = pktlen+beacon_num+2;
    printf ("pkt_len=%d \r\n",Hpkt->pkt_len);
    if((Hpkt->pkt = (S_un*)malloc((Hpkt->pkt_len)*sizeof(S_un))) == NULL)
    {
        free(Hpkt);
        return NULL;
    }
    beacon.S_un_b.s_b1 = 0xe0;
    beacon.S_un_b.s_b2 = 0x78;
    beacon.S_un_b.s_b3 = *Pdevid++;
    beacon.S_un_b.s_b4 = *Pdevid++;
    temp = beacon;
    plen = beacon;
    ppkt = Hpkt->pkt;
    //Devid
    seq = 0x79;
    for(i=0;i< 7;i++)
    {
        if(i%3 == 0) *ppkt++ = beacon;
        temp.S_un_b.s_b2 = seq++;
        temp.S_un_b.s_b3 = *Pdevid++;
        temp.S_un_b.s_b4 = *Pdevid++;
        *ppkt++ = temp;
    }
    //datalen
    if(i++%3 == 0) *ppkt++ = beacon;
    plen.S_un_b.s_b2 = 0x77;
    plen.S_un_b.s_b3 = 0xff;
    plen.S_un_b.s_b4 = datalen;
    *ppkt++ = plen;
    // data
    seq = 0;
    qdata = pdata;
    for(j=0;j<datalen;j++,i++)
    {
        if(i%3 == 0) *ppkt++ = beacon;
        temp.S_un_b.s_b2 = seq++;
        temp.S_un_b.s_b3 = *qdata++;
        temp.S_un_b.s_b4 = *qdata++;
        *ppkt++ = temp;
    }
    //datalen
    if(i++%3 == 0) *ppkt++ = beacon;
    plen.S_un_b.s_b2 = 0x77;
    plen.S_un_b.s_b3 = 0xff;
    plen.S_un_b.s_b4 = datalen;
    *ppkt++ = plen;
    free(pdata);
    return Hpkt;
}
void pkt_free(Packet*Hpkt)
{
    if(Hpkt)
    {
        free(Hpkt->pkt);
        free(Hpkt);
    }
}
void pkt_printf(Packet*Hpkt)
{
    int i;
    if(Hpkt)
    {
        for(i=0;i<Hpkt->pkt_len;i++)
        {
            printf ("seq=%d addr = 0x%x\r\n",i,Hpkt->pkt[i].S_addr);
        }
    }
}
static unsigned char* pkt_encode(int *len,char*ssid,char*pwd,char pwdtype,char*devid)
{
    unsigned char*pkt,*pdata;
    int ssidlen,pwdlen;
    if(len==NULL && ssid == NULL) return NULL;
    if(pwdtype && pwd == NULL) return NULL;
    ssidlen = strlen(ssid);
    pwdlen = strlen(pwd);
    if(pwdtype)
    {
        *len = ssidlen+pwdlen+4;
    }
    else
    {
        *len = ssidlen+pwdlen+3;
    }
    *len = (*len%2) ? (1+*len) : (*len);
    pkt = malloc(*len);
    memset(pkt,0,*len);
    if(pkt == NULL) return NULL;
    pdata = pkt;
    *pdata++ = 0xfa;
    *pdata++ = pwdtype;
    if(pwdtype)
    {
        *pdata++ = 0xfb;
        memcpy(pdata,pwd,pwdlen);
        pdata+=pwdlen;
    }
    *pdata++ = 0xfc;
    memcpy(pdata,ssid,ssidlen);
#if DES_DECRYPT_EN == 1
    unsigned char KEY[DES_KEY_LEN];
    unsigned char *ciphertext;
    int i;
    for(i=0;i<DES_KEY_LEN;i++)
    {
        KEY[i] = devid[i<<2];
    }
    i = ((*len)/8)*8 + 8;
    ciphertext = malloc(i);
    if(DES_encrypt(pkt,ciphertext,len,KEY) < 0)
    {
        printf("encrypt err!\n");
        return NULL;
    }
    free(pkt);
    pkt = ciphertext;
#endif
    return pkt;
}
//************************************************************************************************
//! \brief Convert str to hex
//! \param[in] hex,Str,Strlen
//! \return dest.
//************************************************************************************************
static void *strtohex(void *hex, const void *Str)
{
    unsigned int charCnt;
    unsigned int flag = 0;
    if(hex == NULL || Str == NULL) return NULL;
    char *phex = hex;
    char *pStr = (char *)Str;
    unsigned int Strlen = strlen(Str);
    // Start from end
    pStr += Strlen;
    *phex = 0x00;
    for (charCnt = 0; charCnt < Strlen; charCnt++)
    {
        pStr--;
        switch(*pStr)
        {
            case '0':
                *phex |= 0x00;
                break;
            case '1':
                *phex |= 0x10;
                break;
            case '2':
                *phex |= 0x20;
                break;
            case '3':
                *phex |= 0x30;
                break;
            case '4':
                *phex |= 0x40;
                break;
            case '5':
                *phex |= 0x50;
                break;
            case '6':
                *phex |= 0x60;
                break;
            case '7':
                *phex |= 0x70;
                break;
            case '8':
                *phex |= 0x80;
                break;
            case '9':
                *phex |= 0x90;
                break;
            case 'A':
            case 'a':
                *phex |= 0xa0;
                break;
            case 'B':
            case 'b':
                *phex |= 0xb0;
                break;
            case 'C':
            case 'c':
                *phex |= 0xc0;
                break;
            case 'D':
            case 'd':
                *phex |= 0xd0;
                break;
            case 'E':
            case 'e':
                *phex |= 0xe0;
                break;
            case 'F':
            case 'f':
                *phex |= 0xf0;
                break;
            default:
                break;
        }
        if(flag)
        {
            *phex++;
            *phex = 0x00;
        }
        else
        {
            *phex = (*phex) >> 4;
            *phex &= 0x0000000f;
        }
        flag = 1 - flag;
    }
    return hex;
}