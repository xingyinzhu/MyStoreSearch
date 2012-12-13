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



- (void)configureForSearchResult:(SearchResult *)searchResult
{
    self.nameLabel.text = searchResult.name;
    NSString *artistName = searchResult.artistName;
    if (artistName == nil)
    {
        artistName = NSLocalizedString(@"Unknown", @"Unknown artist name");
    }
    
    NSString *kind = [searchResult kindForDisplay];
    self.artistNameLabel.text = [NSString stringWithFormat:NSLocalizedString(@"ARTIST_NAME_LABEL_FORMAT", @"Format for artist name label"), artistName, kind];
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
