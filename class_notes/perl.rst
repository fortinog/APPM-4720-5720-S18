.. -*- rst -*- -*- restructuredtext -*-

.. _PERL:

====
PERL
====

This section gives a bare bones description of some of the more basic elements of perl. Much more information can be found on the internet, `perl.org`_ is a good place to start (click on the learn link.)   

Perl scripts
============

A perl script is just a text file that usually has the extension .pl. A simple ``hello.pl`` would be

.. code-block:: none

  #!/usr/apps/bin/perl

  print "Hello World!\n";

The first line dictates which version of perl to use (this location is for Mac) but you could also write 

.. code-block:: none

  #!perl

  print "Hello World!\n";

if ``perl`` is in your search path, which it most likely is. 

To run the script you would simply go to a shell and type ``perl hello.pl``.


There are some fundamental building blocks in perl such as scalar data, arrays and lists, hashes, subroutines and regular expressions. Here we will just focus on scalar data, arrays and lists, regular expressions and how to work with files. 

Scalar data
===========

A scalar is the most fundamental type in perl and is typically a number, like ``12`` or ``13.1``, or a string, like ``Hello``. Internally stings and numbers are handled in the same way. Additionally, although perl distinguishes between integers and floats all operations with numbers are performed using double precision. 

There are literal scalar data and scalar variables. Literal numbers and strings are written directly into the code, e.g. ``Hello World!\n`` in the above example. Number literals can be integers: ``123``, ``12`` or floating point numbers: ``1.2``, ``-1.23e-3``.

The numeric operators are the usual: ``+ - / *``. and there is also exponentiation which is denoted as in Fortran, ``**``. For example ``2**3`` is the same as 8.  

Strings
=======

**Single Quotes**

A single quote string literal is just a collection of characters which mean exactly what they are except for the special cases ``\'`` and ``\\``.

.. code-block:: none

 print 'Apa' . "\n" ;
 print 'Apan\'s' . "\n" ;
 print 'Apan\\' . "\n" ;

 $ perl test.pl
 Apa
 Apan's
 Apan\
 $ 

**Double Quotes**

A double quote string literal a bit different in that it interpolates variables and supports backslash escapes 

.. code-block:: none

 $q = 123;
 print "A\tB\n\LBCDE\E\n$q\n";

 $ perl test.pl
 A       B
 bcde
 123
 $  
 
 Here \t is tab, \n is newline \LSTUFF\E forces lowercase in-between \L and \E 
 $n is a variable with a value 123


Honey Badger Don't Care, nor does Perl
======================================

Most of the time you don't have to worry about if a variable, say ``$a = 1``, should be used as a number or a string. Perl figures it out and automatically converts between numbers and strings depending on what operator is used. 

.. code-block:: none 
 
 print "A" . 3*2*1 . "\n";

 $ perl test.pl
 A6
 $

Note that * takes precedence of the concatenation operator . 

Scalar variables
================

A scalar variable is denoted by ``$name`` and holds a single scalar value. Scalar variables can be changed throughout the program. 

.. code-block:: none

 $number = 123;
 $name = 'Daniel'; 

They can also be modified with binary assignment operators like ``*=``, ``+=`` or  ``.=``, replacing the variable by itself multiplied by the right hand side, add something to itself and, in the case of a string, concatenates something to the end. 

.. code-block:: none

 $sum = 0; 
 $sum += $number;   # $sum is now  123
 $name .= 'Appelo'; # $name is now Daniel Appelo

Note that variable names are case sensitive. 


While and for loops 
===================
The while and for loops behave most like in any other language: 

.. code-block:: none

 $n = 5; $fact = 1; $i = 1;
 while ($i <= $n ) {
     $fact *= $i;
     $i += 1;
 }
 print "Computed $n! = $fact \n";

 $ Computed 5! = 120 

.. code-block:: none


 for ($i = 1; $i <= 1000; $i *= 2) {
     print "$i ";
 }
 print "\n";

 1 2 4 8 16 32 64 128 256 512 
 bash-3.2$ 


Lists and arrays
================

The distinction between lists and arrays are a bit subtle. A list is an ordered array of scalars and an array is a variable holding a list. In other words, the list is the data and the array is the variable. An array name starts with the @ sign, fr example ``@array_name``. Indexation of the elements in an array starts with 0 and is done via square brackets, []. As each element is a scalar, when indexing an array the array name is preceded by a $. For example:

.. code-block:: none
 

 @my_array = (1, 2, 3); 
 print $my_array[0] . "\n" ; 
 print $my_array[1] . "\n" ; 
 print $my_array[2] . "\n" ; 


Foreach
=======

You can loop over all the elements in the array using ``foreach`` statement.

.. code-block:: none

 @my_array = qw/ spam sausage ham/ ;  
 foreach $elem (@my_array) { 
   print "We have $elem for lunch \n";
 }
 
 >>> 
 We have spam for lunch 
 We have sausage for lunch 
 We have ham for lunch 


The default variable $_
=======================

For many control structures you may leave out "``$elem``", then perl uses the default variable ``$_``

.. code-block:: none

 @my_array = qw/ spam sausage ham/ ;  
 foreach (@my_array) { 
   print "We have ";
   print ;
   print " for lunch \n";
 }
 
Here both ``foreach`` and ``print`` use ``$_``. The output is the same as above.


Input-Output
============

Input and output are rather easy in perl to open a file just type ``open FILE, "<", "file.txt";`` if you want to read, ``open FILE, ">", "file.txt";``, if you want to write and ``open FILE, ">>", "file.txt";``, if you want to append. Filehandles (FILE above) are usually ALLCAPS. 

Here is an example of how to open a file to read and open another one to write to

.. code-block:: none

 $cmdFile="./newtonS.f90.Template";
 $outFile="./newtonS.f90";
 open FILE, "$cmdFile";     
 open OUTFILE, ">", "$outFile";     

Slightly different version halting the program if the file failed to open. 

.. code-block:: none

 $cmdFile="./newtonS.f90.Template";
 $outFile="./newtonS.f90";
 open(FILE,"$cmdFile") || die "cannot open file $cmdFile!" ;
 open(OUTFILE,"> $outFile") || die "cannot open file!" ;

Reading and writing to file
===========================

This snippet copies the file ``$cmdFile`` to ``$outFile``.

.. code-block:: none

    open(FILE,"$cmdFile") || die "cannot open file $cmdFile!" ;
    open(OUTFILE,"> $outFile") || die "cannot open file!" ;
    while( $line = <FILE> )  # read one line at a time until EOF
    {
	print OUTFILE $line;
	print $line;
    }
    close( OUTFILE );
    close( FILE );


Regular Expressions
===================

A typical thing to do is to search a file for some pattern and then do something (e.g. replace it with something else.) This is what perl is really good at, mainly due to it's strong support for **regular expressions** or **regex** for short.

In short a **regex** is just a pattern that can be used to match a string against. Either it matches or it does not. 

For example if the default ``$_ = "The grass is green" `` is set then if we match against the regex ``/re/`` 

.. code-block:: none

 if(/re/){ 
   print "Found it!\n";
 }

would print ``Found it!``.


Regular Expressions
===================

The regex ``/re/`` is not very advanced. This is not typical. Usually regexs can be very hard to read due to all the different options that can be used to construct them. A couple of useful options are:

  * ``/./`` - Any single character except newline.
  * ``/X*/`` - Match the preceding item X **zero** or more times. Thus ``.*`` matches any old junk. 
  * ``/X+/`` - Match the preceding item X **one** or more times. E.g. ``/Q+/`` matches ``Q``, ``QQ`` etc. 
  * Parenthesis (grouping) can be used if you want to construct an item longer than one character, e.g. ``/(OMG)+/`` would match ``OMGOMGOMG`` while ``/OMG+/`` would match ``OMGGGGGGGGG``.



More useful options
===================

 * Modifiers can be placed after the regex to modify the pattern, ``/(OMG)+/i`` would make the match case-insensitive so that it would also match ``oMgomGomg``.There are more of these, you can find info online. 
 * Anchors ``\b`` can be very useful, they ensure you "match whole word only", e.g. ``/\bOMG\b/`` only matches ``OMG`` and not ``ROMG``.


The binding operator, ``=~``
============================

You don't have to match against the default variable just use the binding operator ``=~`` to match against the sting on the left

.. code-block:: none
 
 $str = 'A cat in a hat';
 if($str =~ /cat/){ 
   print "Found a cat!\n";
 }



Substitution 
============

Often you want to find a pattern in a string and change it. The substitution, ``s///``, is very useful for this! You can of course do this for the default or by using binding.

.. code-block:: none

 $_ = "A red rose.\n"; 
 s/red/RED/;
 print ;

 >> A RED rose.

.. code-block:: none

  $str = "Sju skonsjungande sjukskoterskor skotte sjuttiosju 
  sjosjuka sjoman pa skeppet.\n"; 
  $str =~ s/sjo/lake/g;
  $str =~ s/sjuk/sick/g;
  print $str;

  >> Sju skonsjungande sickskoterskor skotte sjuttiosju lakesicka 
  lakeman pa skeppet.


.. _perl.org: http://www.perl.org

