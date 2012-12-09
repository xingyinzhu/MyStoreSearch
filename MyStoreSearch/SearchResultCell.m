//
//  SearchResultCell.m
//  MyStoreSearch
//
//  Created by Xingyin Zhu on 12-12-8.
//  Copyright (c) 2012年 Xingyin Zhu. All rights reserved.
//

#import "SearchResultCell.h"
#import "SearchResult.h"
#import "UIImageView+AFNetworking.h"

@implementation SearchResultCell

@synthesize nameLabel = _nameLabel;
@synthesize artistNameLabel = _artistNameLabel;
@synthesize artworkImageView = _artworkImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//Gradients in the background
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIImage *image = [UIImage imageNamed:@"TableCellGradient"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
    self.backgroundView = backgroundImageView;
    
    UIImage *selectedImage = [UIImage imageNamed:@"SelectedTableCellGradient"];
    UIImageView *selectedBackgroundImageView = [[UIImageView alloc] initWithImage:selectedImage];
    self.selectedBackgroundView = selectedBackgroundImageView;
}

- (NSString *)kindForDisplay:(NSString *)kind
{
    if ([kind isEqualToString:@"album"])
    {
        return @"Album";
    }
    else if ([kind isEqualToString:@"audiobook"])
    {
        return @"Audio Book";
    }
    else if ([kind isEqualToString:@"book"])
    {
        return @"Book";
    }
    else if ([kind isEqualToString:@"ebook"])
    {
        return @"E-Book";
    }
    else if ([kind isEqualToString:@"feature-movie"])
    {
        return @"Movie";
    }
    else if ([kind isEqualToString:@"music-video"])
    {
        return @"Music Video";
    }
    else if ([kind isEqualToString:@"podcast"])
    {
        return @"Podcast";
    }
    else if ([kind isEqualToString:@"software"])
    {
        return @"App";
    }
    else if ([kind isEqualToString:@"song"])
    {
        return @"Song";
    }
    else if ([kind isEqualToString:@"tv-episode"])
    {
        return @"TV Episode";
    }
    else
    {
        return kind;
    }
}


- (void)configureForSearchResult:(SearchResult *)searchResult
{
    self.nameLabel.text = searchResult.name;
    NSString *artistName = searchResult.artistName;
    if (artistName == nil)
    {
        artistName = @"Unknown";
    }
    
    NSString *kind = [self kindForDisplay:searchResult.kind];
    self.artistNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", artistName, kind];
    [self.artworkImageView setImageWithURL:[NSURL URLWithString:searchResult.artworkURL60] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
}

//We no longer need that image so we should really cancel that download. Table view cells have a special method named prepareForReuse that is ideal for this.
- (void)prepareForReuse
{
    //NSLog(@"now cancel...");
    [super prepareForReuse];
    [self.artworkImageView cancelImageRequestOperation]; self.nameLabel.text = nil;
    self.artistNameLabel.text = nil;
}
@end
