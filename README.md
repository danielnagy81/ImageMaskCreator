# ImageMaskCreator

A basic command line tool for creating image masks based on one color.

### You can make it work by:
  * open terminal
  * navigate to the folder which contains the main.swift file
  * type: swift main.swift *arguments*
  * insert the proper arguments to *arguments*
  * the mask image will be created in the same directory where to original image is stored,
		with a *original_image_name*_blackAndWhite.tiff name modification.
	
### The arguments can be:
  * **the first argument** is the path of the image which you want to edit, I suggest to 
		drag and drop it to the terminal in order to get its path.
  * from **2-4 are optional parameters** for the color which should be masked. Give the red, green, 
		blue and alpha component of the color from 0-255. The default search color is black.
  * the **5. is an optional parameter**: the threshold for the search color, give it with the format 
		like "0.2". It can be between 0.0 and 1.0. The default value is 0.1.
		

