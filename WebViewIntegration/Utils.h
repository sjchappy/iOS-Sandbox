//
//  Utils.h
//  WebViewIntegration
//
//  Created by Scott Chapman on 6/19/14.
//  Copyright (c) 2014 Scott Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(NSString *)documentsFolderPath;
+(NSArray *)readFromFile:(NSString *)filePath;

@end
