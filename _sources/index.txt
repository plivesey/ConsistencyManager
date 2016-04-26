.. Consistency Manager documentation master file, created by
   sphinx-quickstart on Fri Nov 14 09:43:05 2014.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to Consistency Manager's documentation!
===========================================================

Contents:

.. toctree::
   :maxdepth: 1
   :glob:

   pages/*

Overview
========

This library manages the consistency of immutable models. So, if a model changes, it will automatically generate a new model with the diff and return this model to whoever is listening for changes. It is an asynchronous, decentralized model store. This means that it will never block the main thread even for large models. Also, it doesn't actually store the models themselves, so you do not need to worry about duplicate storage, increased memory footprint, or model memory management.

Immutability
------------

Using immutable models has many advantages including thread-safety, easy debugging of code, no need for KVO (key-value observing), and code understandability. For a full discussion, see: :doc:`pages/150_immutability`.

However, the first question asked when proposing immutable models is: 'How do I keep my models in sync?'. This library attempts to answer that question by providing a scalable, intuitive and performant method for keeping immutable models consistent.

Models
------

Specifically, this library deals with in-memory, denormalized models. This maps well to many popular data formats such as JSON. What model you choose to use is up to you. They just need to adhere to a protocol provided by this library (possibly with an extension).

Swift
-----

The library is written in Swift, but it works with Objective-C models. See :doc:`pages/140_swift`.

Docs
----

These docs attempt to give a high level overview of what this library does, how it does it, and why we wrote it. It does not attempt to give API level documentation on every function in the library. For these docs, you should see the documentation in the code.
