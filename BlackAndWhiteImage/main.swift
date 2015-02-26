//
//  main.swift
//  BlackAndWhiteImage
//
//  Created by Daniel_Nagy on 26/02/15.
//  Copyright (c) 2015 NDani. All rights reserved.
//

import Cocoa

let inputArguments = Process.arguments
var threshold: CGFloat = 0.1
var searchColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1)

if inputArguments.count == 2 || inputArguments.count == 6 || inputArguments.count == 7 {
    let pathURL =  NSURL(fileURLWithPath: inputArguments[1])
    
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
    
    if let validURL = pathURL {
        let image = NSImage(contentsOfURL: validURL)
        
        if let foundImage = image {

            if let tiffData = foundImage.TIFFRepresentation {
                
                if let imageRepresentation = NSBitmapImageRep(data: tiffData) {
                    println("\nProcessing image started! Please wait, this might take a while...\n")

                    let pixelHigh = imageRepresentation.pixelsHigh - 1
                    let loadingPercentage = pixelHigh / 10
                    var nextStep = loadingPercentage
                    
                    for y in 0...pixelHigh {
                        
                        for x in 0...imageRepresentation.pixelsWide - 1 {
                        
                            let colorAtPixel = imageRepresentation.colorAtX(x, y: y)!
                            let isSameColor = (abs(colorAtPixel.redComponent - searchColor.redComponent) < threshold) && (abs(colorAtPixel.greenComponent - searchColor.greenComponent) < threshold) && (abs(colorAtPixel.blueComponent - searchColor.blueComponent) < threshold)
                            
                            if isSameColor {
                                let p = UnsafeMutablePointer<Int>.alloc(4)
                                p.initialize(0)
                                p.successor().initialize(0)
                                p.successor().successor().initialize(0)
                                p.successor().successor().successor().initialize(255)
                                imageRepresentation.setPixel(p, atX: x, y: y)
                            } else {
                                let p = UnsafeMutablePointer<Int>.alloc(4)
                                p.initialize(255)
                                p.successor().initialize(255)
                                p.successor().successor().initialize(255)
                                p.successor().successor().successor().initialize(255)
                                imageRepresentation.setPixel(p, atX: x, y: y)
                            }
                        }
                    }
                    
                    let newFileName = inputArguments[1].componentsSeparatedByString(".")[0] + "_blackAndWhite" + ".tiff"
                    let saveSuccess = imageRepresentation.TIFFRepresentation!.writeToFile(newFileName, atomically: false)
                    
                    if saveSuccess {
                        println("SUCCESS!\n\nNew black and white image created at \(newFileName)\n")
                    } else {
                        println("\nThere was an error at saving, new file cannot be created :'(\n")
                    }
                } else {
                    println("\nImage representation cannot be created :'(\n")
                }
            } else {
                println("\nTiff data could not be created :'(\n")
            }
        } else {
            println("\nImage not found :'(\n")
        }
    } else {
        println("\nThe given path is not valid :'(\n")
    }
} else {
    println("\nToo many/not enough input arguments given :'(\n")
}