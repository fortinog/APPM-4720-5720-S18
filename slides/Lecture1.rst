+++++++++
Lecture 1
+++++++++
 
**Math/CS 471: Introduction to Scientific Computing, Fall 2014.**


Outline
=======

* Goals of the class
* What we will cover 
* Computer requirements
* Syllabus
* Linux/Unix Git demo

Goals of the Class
==================

* The goals of this class are modest in terms of depth but ambitious in terms of breadth. 
* The class will contain topics from computer science as well as from applied mathematics. 
* At the end of the class you should be familiar with some new tools allowing you to better tackle future projects involving scientific computing. 


Basic topics we will cover: 
===========================

* Basic Linux / Unix 
* Version control - GIT
* Basic scripting - Perl / Python 
* Fortran 
* Hardware and programming models

The topics may not be covered in order or in a ''two steps forward one step backward fashion'' 


We will also discuss
====================

* Parallel programming 
* Associated metrics - scaling - efficiency 
* OpenMP - shared memory
* MPI - distributed memory 
* Time permitting we will do a little bit of CUDA


Examples from applied math / engineering
========================================

* How to numerically solve ODEs / PDEs
* ODE solvers: Runge Kutta - multistep methods
* Evolution equations
* Wave propagation problems (acoustics, Electro-magnetics)  
* Finite difference methods
* Discretization on curvilinear grids 


Tools from mathematics 
======================

* Basic calculus, chain-rule, Taylor-expansion
* Manipulate logarithms and exponential (order of accuracy / convergence) 
* Basic ODE, make sure you can solve :math:`y'= \lambda y, \, y(0) = y_0` 

Tools from ''computer science''
===============================

* Basic programming skills
* Programming experience in some language (Matlab, Fortran, C, C++, etc.)
* Understand the structure of a program
* Subdivision into smaller problems
* Understand and use do and while loops and conditional statements


Computer requirements
=====================

* You will need access to a computer with a Linux/Unix operating system 
* You will also need to be able to install software on that system (if it does not have it already)
* linux.unm.edu is one option, a personal computer with some Linux distribution or a Mac with the developer tools installed are two other options.
* For the parallel computing projects we will use XSEDE resources (Stampede at TACC) 


Baby demo
=========

1. ssh into linux.unm.edu 
2. Get the class repository
3. Correct the first page using an editor
4. Compile and check the results
5. Commit 
6. Push
