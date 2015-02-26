# ImageMaskCreator

A basic command line tool for creating image masks based on one color.

<h6>You can make it work by</h6>
	1: open terminal
	2: navigate to the folder which contains the main.swift file
	3: type: swift main.swift *arguments*
	4: insert the proper arguments to *arguments*
	5: the mask image will be created in the same directory where to original image is stored,
		with a _blackAndWhite name modification.
	
<h6>The *arguments* can be:</h6>
	1: the first argument is the path of the image which you want to edit, I suggest to 
		drag and drop it to the terminal in order to get its path.
	2 - 4: optional parameters for the color which should be masked. Give the red, green, 
		blue and alpha component of the color from 0-255. De default search color is black.
	5: optional parameter: the threshold for the search color, give it with the format 
		like "0.2". It can be between 0.0 and 1.0. The default value is 0.1.
		
