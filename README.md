BeanMove
========

iOS program to demonstrate how to use the LightBlue Bean's accelerometer to register movement.

The Bean should be oriented so that the battery is towards the back, and the long axis
of the bean is up/down, with the holes at the bottom:

~~~~
 ---------------
/          --   \
|   ---------   |
|   :       :   |
| | :       :   |
|   :       :   |
|   ---------   |
|       --      |
|o              |
|o o o         o|
|A0A10 1 2 3 4 5|
|o o o o o o o o|
|o o o o o o o o|
|o o o o o o o o|
|o o o o o o o o|
|  o o o o o o  |
\   o o o o     /
 ---------------
~~~~ 
 
When you first run the program, click on the "i" at the bottom right corner, which will
allow you to choose a Bean.

Once back in the main window, if you connected to a Bean, the x-axis acceleration
will be listed in the text box, and will change due to the Bean's movement.

If the bean moves significantly left or right, an arrow should swish left or right,
respectively.

* The LightBlue Bean can be found here: [http://punchthrough.com/bean/](http://punchthrough.com/bean/)). 
* The libBean SDK can be found here: [https://github.com/PunchThrough/Bean-iOS-OSX-SDK](https://github.com/PunchThrough/Bean-iOS-OSX-SDK).


# Known bugs:

- Occasionally, the program will crash -- unsure why.

- Because the program is basing its left/right announcement on a simple
acceleration measurement, slowing the bean down in the opposite direction can
also trigger it. E.g., if the bean is on a sliding door, it will report when the door
opens in one direction, and then as it stops (as the acceleration is in the
opposite direction, and significant).

# Licensing

This SDK is covered under **The MIT License**. See `LICENSE.txt` for more details.
