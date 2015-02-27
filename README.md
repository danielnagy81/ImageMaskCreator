# ImageMaskCreator

A basic command line tool for creating image masks based on one color.

### You can make it work by:
  1. open terminal
  2. navigate to the folder which contains the main.swift file
  3. type: swift main.swift *arguments*
  4. insert the proper arguments to *arguments*
  5. the mask image will be created in the same directory where to original image is stored,
		with a *original_image_name*_blackAndWhite.tiff name modification.
	
### The arguments can be:
  * **the first argument** is the path of the image which you want to edit, I suggest to 
		drag and drop it to the terminal in order to get its path.
  * from **2-4 are optional parameters** for the color which should be masked. Give the red, green, 
		blue and alpha component of the color from 0-255. The default search color is black.
  * the **5. is an optional parameter**: the threshold for the search color, give it with the format 
		like "0.2". It can be between 0.0 and 1.0. The default value is 0.1.
		


## Example

**Original image:**
![Alt text](https://raw.githubusercontent.com/danielnagy81/ImageMaskCreator/master/Example/1.png "Original image")

**Calling ImageMaskCreator:** swift main.swift /my_path_to_the_image/1.png 251 202 175 255

**Output image:**
![Alt text](https://raw.githubusercontent.com/danielnagy81/ImageMaskCreator/master/Example/1_blackAndWhite.png "Mask image")
