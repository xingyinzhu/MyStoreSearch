//
//  SearchResultCell.h
//  MyStoreSearch
//
//  Created by Xingyin Zhu on 12-12-8.
//  Copyright (c) 2012年 Xingyin Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchResult;

@interface SearchResultCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *artworkImageView;

- (void)configureForSearchResult:(SearchResult *)searchResult;
@end
