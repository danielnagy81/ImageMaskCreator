//
//  main.swift
//  BlackAndWhiteImage
//
//  Created by Daniel_Nagy on 26/02/15.
//  Copyright (c) 2015 NDani. All rights reserved.
//

import Cocoa

class ImageMaskCreator {
    
    private var searchColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1)
    private var threshold: CGFloat = 0.1
    private let inputArguments: [String]
    
    private let foundColorPointer: UnsafeMutablePointer<Int>
    private let otherColorsPointer: UnsafeMutablePointer<Int>
    
    init(inputArguments: [String]) {
        self.inputArguments = inputArguments
        foundColorPointer = UnsafeMutablePointer<Int>.alloc(4)
        foundColorPointer.initialize(0)
        foundColorPointer.successor().initialize(0)
        foundColorPointer.successor().successor().initialize(0)
        foundColorPointer.successor().successor().successor().initialize(255)
        otherColorsPointer = UnsafeMutablePointer<Int>.alloc(4)
        otherColorsPointer.initialize(255)
        otherColorsPointer.successor().initialize(255)
        otherColorsPointer.successor().successor().initialize(255)
        otherColorsPointer.successor().successor().successor().initialize(255)
    }
    
    func createImageMask() {
        setupInputArguments()
        createImageFromPath(inputArguments[1])
    }
    
    private func setupInputArguments() {
        if inputArguments.count == 2 || inputArguments.count == 6 || inputArguments.count == 7 {
            
            if inputArguments.count == 6 || inputArguments.count == 7 {
                let red = inputArguments[2].toInt()
                let green = inputArguments[3].toInt()
                let blue = inputArguments[4].toInt()
                let alpha = inputArguments[5].toInt()
                
                if red != nil && green != nil && blue != nil && alpha != nil {
                    searchColor = NSColor(red: CGFloat(red!) / 255, green: CGFloat(green!) / 255, blue: CGFloat(blue!) / 255, alpha: CGFloat(alpha!) / 255)
                }
            }
            
            if inputArguments.count == 7 {
                threshold = CGFloat((inputArguments[6] as NSString).floatValue)
            }
        } else {
            println("\nToo many/not enough input arguments given :'(\n")
        }
    }
    
    private func createImageFromPath(path: String) {
        let pathURL =  NSURL(fileURLWithPath: path)
        if let validURL = pathURL {
            let image = NSImage(contentsOfURL: validURL)
            
            if let foundImage = image {
                createImageDataFromImage(foundImage)
            } else {
                println("\nImage not found :'(\n")
            }
        } else {
            println("\nThe given path is not valid :'(\n")
        }
    }
    
    private func createImageDataFromImage(image: NSImage) {
        if let tiffData = image.TIFFRepresentation {
            let imageRepresentation = startProcessWithData(tiffData)
            saveImageRepresentation(imageRepresentation)
        } else {
            println("\nTiff data could not be created :'(\n")
        }
    }
    
    private func startProcessWithData(tiffData: NSData) -> NSBitmapImageRep? {
        if let imageRepresentation = NSBitmapImageRep(data: tiffData) {
            println("\nProcessing image started! Please wait, this might take a while...\n")
            return iterateThroughPixelsOfImageRepresentation(imageRepresentation)
        } else {
            println("\nImage representation cannot be created :'(\n")
            return nil
        }
    }
    
    private func saveImageRepresentation(imageRepresentation: NSBitmapImageRep?) {
        let newFileName = inputArguments[1].componentsSeparatedByString(".")[0] + "_blackAndWhite" + ".tiff"
        let saveSuccess = imageRepresentation?.TIFFRepresentation!.writeToFile(newFileName, atomically: false)
        
        if saveSuccess != nil && saveSuccess == true {
            println("SUCCESS!\n\nNew black and white image created at \(newFileName)\n")
        } else {
            println("\nThere was an error at saving, new file cannot be created :'(\n")
        }
    }
    
    private func iterateThroughPixelsOfImageRepresentation(imageRepresentation: NSBitmapImageRep) -> NSBitmapImageRep {
        for y in 0...imageRepresentation.pixelsHigh - 1 {
            for x in 0...imageRepresentation.pixelsWide - 1 {
                setBlackOrWhitePixelOfImageRepresentation(imageRepresentation, x: x, atY: y)
            }
        }
        cleanUpPointers()
        return imageRepresentation
    }
    
    private func setBlackOrWhitePixelOfImageRepresentation(imageRepresentation: NSBitmapImageRep, x: Int, atY y: Int) -> NSBitmapImageRep {
        let colorAtPixel = imageRepresentation.colorAtX(x, y: y)!
        let isSameColor = (abs(colorAtPixel.redComponent - searchColor.redComponent) < threshold) && (abs(colorAtPixel.greenComponent - searchColor.greenComponent) < threshold) && (abs(colorAtPixel.blueComponent - searchColor.blueComponent) < threshold)
        isSameColor ? imageRepresentation.setPixel(foundColorPointer, atX: x, y: y) : imageRepresentation.setPixel(otherColorsPointer, atX: x, y: y)
        return imageRepresentation
    }
    
    private func cleanUpPointers() {
        foundColorPointer.destroy(4)
        foundColorPointer.dealloc(4)
        otherColorsPointer.destroy(4)
        otherColorsPointer.dealloc(4)
    }
}

let inputArguments = Process.arguments
let maskCreator = ImageMaskCreator(inputArguments: inputArguments)
maskCreator.createImageMask()
