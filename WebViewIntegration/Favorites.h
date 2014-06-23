//
//  Favorites.h
//  WebViewIntegration
//
//  Created by Scott Chapman on 6/18/14.
//  Copyright (c) 2014 Scott Chapman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Favorites : NSObject

@property (nonatomic) NSMutableArray *userFavorites;

-(void)addFavorite:(NSString *)favorite;
-(void)removeFavorite:(NSString *)favorite;
-(BOOL)isFavorite:(NSString *)favorite;


@end
