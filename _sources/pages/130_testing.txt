Testing
=======

This library is fully tested with every edge case I could think of. It is mainly tested with property-based tests (http://blog.jessitron.com/2013/04/property-based-testing-what-is-it.html). This means that each test is tested on many inputs. Most of the tests start with a nested for loop running over 10’s or 100’s of inputs.

This means that the library is not just tested for correctness with normal input, but also large, deep and wide input.

At LinkedIn, we've been running the consistency manager in production on two applications and haven't seen any crashes caused by the consistency manager.
