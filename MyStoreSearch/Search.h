//
//  Search.h
//  MyStoreSearch
//
//  Created by Xingyin Zhu on 12-12-11.
//  Copyright (c) 2012年 Xingyin Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>


//We can solve this by making SearchViewController a delegate of the Search object, but for situations like these, blocks are much more convenient. So let’s create our own blocks.

typedef void (^SearchBlock)(BOOL success);

@interface Search : NSObject

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, readonly, strong) NSMutableArray *searchResults;

//- (void)performSearchForText:(NSString *)text category:(NSInteger)category;

- (void)performSearchForText:(NSString *)text category:(NSInteger)category completion:(SearchBlock)block;

@end
