//
//  Utils.m
//  WebViewIntegration
//
//  Created by Scott Chapman on 6/19/14.
//  Copyright (c) 2014 Scott Chapman. All rights reserved.
//

#import "Utils.h"

@implementation Utils



+(NSString *)documentsFolderPath{
    NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [pathsArray objectAtIndexedSubscript:0];
}


+(NSArray *)readFromFile:(NSString *)filePath{
    //check if file exists
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSArray *contentsArray = [[NSArray alloc] initWithContentsOfFile:filePath];
        
        return contentsArray;
    }
    else{
        return nil;
    }
    
    //NSLog(@"File Read: %@",filePath);
    
}

@end
