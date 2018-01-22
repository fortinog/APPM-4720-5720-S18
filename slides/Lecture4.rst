+++++++++
Lecture 4
+++++++++
 
**Basic Perl**


Outline
=======

0. Perl scripts
1. Scalar Data
2. Lists and arrays
3. Input Output
4. Regular Expressions


Perl scripts
============

A simple ``hello.pl`` would be

.. code-block:: none

  #!/usr/apps/bin/perl

  print "Hello World!\n";

The first line dictates which version of perl to use (this location is for Mac) but you could also write 

.. code-block:: none

  #!perl

  print "Hello World!\n";

if ``perl`` is in your search path.

Run it with ``$ perl hello.pl``

Scalar data
===========

* A scalar is the most fundamental type in perl and is typically a number, like ``12`` or ``13.1``, or a string, like ``Hello``.

* Internally these are the same and a number is always a double precision floating point number. 

* Literal numbers and strings are written directly into the code, e.g. ``Hello World!\n`` in the above example. 

* Number literals can be integers: ``123``, ``12`` or floating point numbers: ``1.2``, ``-1.23e-3``.
 
* The numeric operators are the usual: ``+ - / *``. Exponentiation is by ``**``. 
  
* For example ``2**3`` is the same as 8.  



Strings
=======

**Single Quotes**

A single quote string literal is just a collection of characters which mean exactly what they are except for ``\'`` and ``\\``.

.. code-block:: none

 print 'Apa' . "\n" ;
 print 'Apan\'s' . "\n" ;
 print 'Apan\\' . "\n" ;

 $ perl test.pl
 Apa
 Apan's
 Apan\
 $ 

Strings
=======

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
 
 Here \t is tab, \n is newline \LSTUFF\E forces lowercase 
 $n is a variable with a value 123


Honey Badger Don't Care, nor does Perl
======================================

Perl automatically converts between numbers and strings depending on what operator is used.

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

They can also be modified with binary assignment operators like ``*=``, ``=+`` or  ``.=``

.. code-block:: none

 $sum = 0; 
 $sum += $number;   # $sum is now  123
 $name .= 'Appelo'; # $name is now Daniel Appelo

Note that variable names are case sensitive. 


While and for loops 
===================

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

* A list is an ordered array of scalars.
* An array is a variable holding a list.
* The list is the data the array the variable. 
* An array is named ``@array_name``.

.. code-block:: none
 

 @my_array = (1, 2, 3); 
 print $my_array[0] . "\n" ; 
 print $my_array[1] . "\n" ; 
 print $my_array[2] . "\n" ; 

Note that you access the elements in the array with $ and [ ] (starting at 0.)

Foreach
=======

You can loop over all the elements in the array using ``foreach``

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

Form many control structures you may leave out ``$elem``, then perl uses the default variable ``$_``

.. code-block:: none

 @my_array = qw/ spam sausage ham/ ;  
 foreach (@my_array) { 
   print "We have ";
   print ;
   print " for lunch \n";
 }
 
Here both ``foreach`` and ``print`` use ``$_``.


Input-Output
============

* Filehandles are usually ALLCAPS. 
* To read from a file use "<", to write ">" and to append ">>".


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

The regex ``\re\`` is not very advanced. This is not typical ;-) Usually regexs can be very hard to read due to all the different options that can be used to construct them. A couple of options are:

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


Homework 2
==========
