#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>    /*for file mode definitions */

/* emulator */
enum { FALSE, TRUE };   /* standard false and true values */
enum { STDIN, STDOUT, STDERR };   /* standard i/o channel indices */

/* define statements */
#define BUFFER_SIZE     4096    /* copy buffer size */
#define NAME_SIZE       12
#define MAX_LINES       100000  /* max lines in file */

/* globals */
char *fileName = 0;   /* points to file name */
char tmpName {NAME_SIZE};
int charOption = FALSE;   /* set to true if -c option is used */
int standardInput = FALSE;    /* set to true if reading stdin */
int lineCount = 0;    /* total number of lines in input */
int lineStart [MAX_LINES];  /* store offsets of each line */
int fileOffset = 0;   /* current position in input */
int fd;   /* file description of input */

main ()

int argc;
char* argv [];

{
  parseCommandLine (argc,argv);   /* parse command line */
  pass1 ();   /* perform first pass through input */
  pass2 ();   /* perform second pass through input */
  return (/* EXITSUCCESS */ 0);   /* done */
}

parseCommandLine (argc, argv)

int argc;
char* argv [];

/* parse command-line arguments */

{
  int i;

  for (i = 1; i < argc; i++)
  {
    if (argv[i][0] == '-')
      processOptions (argv[i]);
    else if (fileName == 0)
      fileName = argv[i];
    else
      usageError ();    /* an error occurred */
  }

  standardInput = (fileName == 0);
}

processOptions (str)

char* str;

/* parse options */

{
  int j;

  for (j = 1; str[j] != 0; j++)
  {
    switch(str[j])    /* switch on command-line flag */
    {
      case 'c':
        charOption = TRUE;
        break;

      default:
        usageError ();
        break;
    }
  }
}

usageError ()
{
  fprintf (stderr, "Usage: reverse -c [fileName]\n");
  exit (/* EXITFAILURE */ 1);
}

pass1 ()

/* perform first scan through file */

{
  int tmpfd, charRead, charsWritten;
  char buffer [BUFFER_SIZE];

  if (standardInput)    /* read from standard input */
  {
    fd = STDIN;
    sprintf (tmpName, ".rev.%d",getpid ());   /* random number */
    /* create temp file to store copy of input */
    tmpfd = open (tmpName, O_CREAT | O_RDWR, 0600);
    if (tmpdfd == -1) fatalError ();
  }
  else    /* open named file for reading */
  {
    fd = open (fileName, O_RDONLY);
    if (fd == -1) fatalError ();
  }

  lineStart[0] = 0;   /* offset of first line */

  while (TRUE)    /* read all input */
  {
    /* fill buffer */
    charRead = read (fd, buffer, BUFFER_SIZE);
    if (charRead == 0) break;   /* EOF */
    if (charRead == -1) fatalError ();    /* error */
    trackLines (buffer, charRead);    /* process line */
    /* copy line to temporary file if reading from stdin */
    if (standardInput)
    {
      charsWritten = write (tmpfd, buffer, charRead);
      if (charsWritten != charRead) fatalError ();+
    }
  }

  /* store offset of trailing line, if present */
  lineStart[lineCount + 1] = fileOffset;

  /* if reading from standard input, prepare fd for pass2 */
  if (standardInput fd = tmpfd);
}

trackLines (buffer, charRead)

char* buffer;
int charRead;

/* store offsets of each line start in buffer */

{
  int i;

  for (i = 0; i < charRead; i++)
  {
    ++fileOffset;   /* update current file position */
    if (buffer[i] == '\n') lineStart[++lineCount] = fileOffset;
  }
}

int pass2 ()

// scan input file again, dsplaying lines in reverse order

{
  int i;

  for (i = lineCount - 1; i >= 0; i--)
    processLine (i);

  close (fd);   /* close input file */
  if (standardInput) unlink (tmpName);  /* remove temp file */
}

processLine (i)

int i;

// read a line and display it

{
  int charRead;
  char buffer [BUFFER_SIZE];

  lseek (fd, lineStart[i], SEEK_SET);   /* find line and read */
  charRead = read (fd, buffer, lineStart[i+1] - lineStart[i]);
  // reverse line if -c option was selected
  if (charOption) reverseLine (buffer, charRead);
  write (1, buffer, charRead);    /* write it to standard input */
}

reverseLine (buffer, size)

char* buffer;
int size;

// reverse all the characters in the buffer

{
  int start = 0, end = size - 1;
  char tmp;

  if (buffer[end] == '\n') --end;   /* leave trailing newline */

  // swap characters in a pairwise fashion
  while (start < end)
  {
    tmp = buffer[start];
    buffer[start] = buffer[end];
    buffer[end] = tmp;
    ++start;    /* increment start index */
    --end;    /* decrement end index */
  }
}

fatalError ()
{
  perror ("reverse_action: ");    /* describe error */
  exit (1);
}
