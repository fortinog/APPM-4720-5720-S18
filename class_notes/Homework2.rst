.. -*- rst -*- -*- restructuredtext -*-

===============================
Homework 2, due 08.00, 5/9-2014
===============================

Managing your computations through scripting
--------------------------------------------

In this homework you will try out some very basic perl scripting to automate computations to find the roots of the equation :math:`f(x)=0` for different functions, :math:`f(x)`.. 

Start by pulling the latest version of our repo where you should find the two files ``newtonS.f90.Template`` and ``newtonS.p`` in the ``/codes/fortran/newton/`` directory. The file ``newtonS.p`` contains a basic perl script which reads the template file one line at a time and replaces the strings ``FFFF`` and ``FPFP`` with "functions'' and "derivatives'' (defined inside ``newtonS.p``.)

1. Run the script by typing ``$ perl newtonS.p`` and inspect the output.  
2. Currently the implementation of Newton's method iterates 10 times which is too much for some functions and too little for others. Modify the program so that it iterates until the quantity :math:`(E_{\rm abs.})_{n+1} = |x_{n+1}-x_n|`, approximating the absolute error, is less then :math:`10^{-15}`. It is probably easiest to do this by changing the do loop to a `do-while loop`__. 
3. Linear and quadratic convergence means that the errors in subsequent iterations satisfy the relations :math:`(E_{\rm abs.})_{n+1} \approx {\rm Const.} \times (E_{\rm abs.})_{n}` and :math:`(E_{\rm abs.})_{n+1} \approx {\rm Const.} \times (E_{\rm abs.})_{n}^2` respectively. To determine the rate of convergence for Newton's method modify the ``write`` statement to include the ratios :math:`(E_{\rm abs.})_{n+1} / (E_{\rm abs.})_{n}` and :math:`(E_{\rm abs.})_{n+1} / (E_{\rm abs.})_{n}^2`.  
4. Determine the rate of convergence for the three different functions and try to explain. The key here is to understand what is happening to :math:`f'(x)` close to the root. Is it possible to come up with a **modified Newton's method** to regain the quadratic convergence for the problematic function?  
5. Modify the script ``newtonS.p`` so that the standard output from your Newton code gets redirected into a file ``tmp.txt`` by changing ``system("./a.out ");`` to ``system("./a.out > tmp.txt");``. 
6. After each execution open the file ``tmp.txt`` and replace the blank spaces in between the results on each line by a comma with a single space on each side.  Print the resulting string to the screen. There are infinitely many ways to do this in perl, here is a step by step approach:

  .. code-block:: none

    $line =~ s/\s+/ , /g;  # Globally replace chunks of whitespace with a " , " 
    $line =  $line . "\n"; # Add a newline as the above removes it. 
    $line =~ s/ , $/ /;    # Remove the last " , "
    $line =~ s/ , / /;     # Remove the first " , "
    print $line;           # Print to screen
 
  Can you find a more elegant (less readable) way to do this? This kind of operation can be good if you need to reformat your output to conform with some particular table format, for example in :math:`\LaTeX`. 

7. Summarize your findings in a report where you use your tabulated data. Make sure to check the report and codes into your repository and to add a description in the README file where I find the report and codes and how I could go about running your code. 

__ http://en.wikipedia.org/wiki/Do_while_loop#Fortran

