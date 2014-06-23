//
//  Favorites.m
//  WebViewIntegration
//
//  Created by Scott Chapman on 6/18/14.
//  Copyright (c) 2014 Scott Chapman. All rights reserved.
//

#import "Favorites.h"
#import "Utils.h"

@implementation Favorites

NSString *fileName;
@synthesize userFavorites = _userFavorites;


-(void) setuserFavorites:(NSMutableArray *)f{
    _userFavorites = f;
}

-(NSMutableArray*)userFavorites{
    if ([_userFavorites count] == 0) {

        self.userFavorites = [[NSMutableArray alloc] initWithArray:[Utils readFromFile:fileName]];
    }
    return _userFavorites;
}


+ (void)initialize
{
    if(self == [Favorites class])
    {
        fileName = [[Utils documentsFolderPath] stringByAppendingPathComponent:@"favorites.txt"];
               
    }
}


-(BOOL)isFavorite:(NSString *)favorite{
    NSUInteger indexOfTheObject = [self.userFavorites indexOfObject: favorite];
    if (indexOfTheObject == NSNotFound){
        return FALSE;
    }
    else{
        return TRUE;
    }

}


-(void)addFavorite:(NSString *)favorite{
    [self.userFavorites addObject:favorite];
    [self writeFavoritesToFile:fileName];
}



-(void)removeFavorite:(NSString *)favorite{
    
    NSUInteger indexOfTheObject = [self.userFavorites indexOfObject: favorite];
    if (indexOfTheObject != NSNotFound && indexOfTheObject != 0){
        [self.userFavorites removeObjectAtIndex:indexOfTheObject];
        [self writeFavoritesToFile:fileName];
    }
    else if(indexOfTheObject == 0){
        [self.userFavorites removeObjectAtIndex:indexOfTheObject];
        [[NSFileManager defaultManager] createFileAtPath:fileName contents:[NSData data] attributes:nil];
    }
    
}


-(void)writeFavoritesToFile:(NSString *)filePath{
        
    Boolean updated = [self.userFavorites writeToFile:filePath atomically:YES];
    NSLog(@"File Written: %hhu",updated);
    
}







@end
