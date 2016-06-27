#!/bin/gawk -f
func getstring(innum, t, retstr, i) {

        retstr = "";
        t=innum;
	      while( t )
        {
                if ( t%2==0 ) {
                        retstr = "0" retstr;
                } else {
                        retstr = "1" retstr;
                }
                t = int(t/2);
        }

        return retstr;
}


{
	print	getstring( $1 );
}
