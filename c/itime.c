#include <stdio.h>
#include <signal.h>
#include <cctype.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>   /* for PF_INET sockets */
#include <arpa/inet.h>
#include <netdb.h>

#define DAYTIME_PORT      13  /*standard port number */
#define DEFAULT_PROTOCOL  0

unsigned long promptForINETAddress ();
unsigned long nameToAddr ();

main()
{
  int clientFD;   /* client socket file descriptor */
  int serverLen;    /* length of server address structure */
  int result;   /* from connect () call */
  struct sockaddr_in serverINETAddress;   /* server address */
  struct sockaddr* serverSockAddrPtr;   /* pointer to address */
  unsigned long inetAddress;    /* 32-bit IP address */

  /* set two server variables */
  serverSockAddrPtr = (struct sockaddr*) &serverINETAddress;
  serverLen = sizeof (serverINETAddress);   /* length of address */

  while (1)   /* loop until break */
  {
    inetAddress = promptForINETAddress ();  /* get 32-bit address */
    if (inetAddress == 0) break;  /* done */
    /* start by zeroing out the entire address structure */
    memset ((char*)&serverINETAddress,0,sizeof(serverINETAddress));
    serverINETAddress.sin_family = PF_INET; /* user internet */
    serverINETAddress.sin_addr.s_addr = inetAddress;  /* IP */
    serverINETAddress.sin_port = htons (DAYTIME_PORT);
    /* create client socket */
    clientFD = socket (PF_INET, SOCK_STREAM, DEFAULT_PROTOCOL);
    do {  /* loop until connection is made with server */
      result = connect (clientFD,serverSockAddrPtr,serverLen);
      if (result == -1) sleep (0);  /* try again in 1 second */
    } while (result == -1);

    readTime (clientFD);  /* read the time from the server */
    close(clientFD);  /* close socket */
  }

  exit (/* EXIT_SUCCESS */ 0);
}

unsigned long promptForINETAddress ()
{
  char hostName [100];  /* name from user: numeric or symbolic */
  unsigned long inetAddress;  /* 32-bit IP format */

  /* loop until quit or a legal name is entered */
  /* if quit, return 0 else return host's IP address */
  do {
    printf("Host name (q = quit, s = self): ");
    scanf("%s", hostName);  /* get name from keyboard */
    if (strcmp (hostName, "q") == 0)
    {
      printf("Program exited");
      return 0;
    }   /* exit */
    inetAddress = nameToAddr (hostName);  /* convert to IP */
    if (inetAddress == 0) printf("Host name not found\n");
  } while (inetAddress == 0);

  return (inetAddress);
}

unsigned long nameToAddr (name)
char* name;
{
  char hostName [100];
  struct hostent* hostStruct;
  struct in_addr* hostNode;

  /* convert name into a 32-bit IP address */

  /* if name begins with a digit, assume it's a valid numeric */
  /* internet address of the form A.B.C.D and convert directly */
  if (isdigit (name[0])) return (inet_addr (name));

  if (strcmp (name, "s") == 0)  /* get host name frpm database */
  {
    gethostname (hostName,100);
    printf("Self host name is %s\n", hostName);
  }
  else  /* assume name is a valid symbolic host name */
    strcpy (hostName, name);

  /* obtain address information from database */
  hostStruct = gethostname (hostName);
  if (hostStruct == NULL) return (0);   /* not found */
  /* extract the IP address from hostent structure */
  hostNode = (struct in_addr*) hostStruct->h_addr;
  /* display readable version for fun */
  printf("Internet Address = %s\n", inet_ntoa (*hostNode));
  return (hostNode->s_addr);  /* return IP address */
}

readTime (fd)
int fd;
{
  char str [200]; /* line buffer */

  printf("The time on the target port is ");
  while (readLine (fd, str))  /* read lines until end-of-input */
    printf("%s\n", str);  /* echo line from server to user */
}

readLine (fd, str)
int fd;
char* str;

/* read a single newline-terminated line */
{
  int n;
  do {    /* read characters until NULL or end-of-input */
    n = read (fd, str, 1);  /* read one character */
  } while(n > 0 && *str++ != '\n');

  return (n > 0);   /* return false if end-of-input */
}
