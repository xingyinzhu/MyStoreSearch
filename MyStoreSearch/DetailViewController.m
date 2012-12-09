//
//  DetailViewController.m
//  MyStoreSearch
//
//  Created by Xingyin Zhu on 12-12-9.
//  Copyright (c) 2012年 Xingyin Zhu. All rights reserved.
//

#import "DetailViewController.h"
//the pop- up view had a white rounded border
#import "QuartzCore/QuartzCore.h"
#import "SearchResult.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *artworkImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *kindLabel;
@property (nonatomic, weak) IBOutlet UILabel *genreLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UIButton *storeButton;

@property (nonatomic, weak) IBOutlet UIView *backgroundView;

- (IBAction)close:(id)sender;
- (IBAction)openInStore:(id)sender;

@end



@implementation DetailViewController

@synthesize artworkImageView = _artworkImageView;
@synthesize nameLabel = _nameLabel;
@synthesize artistNameLabel = _artistNameLabel;
@synthesize kindLabel = _kindLabel;
@synthesize genreLabel = _genreLabel;
@synthesize priceLabel = _priceLabel;
@synthesize storeButton = _storeButton;

@synthesize backgroundView = _backgroundView;

@synthesize searchResult = _searchResult;

- (IBAction)openInStore:(id)sender
{
    NSLog(@"%@",self.searchResult.storeURL);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.searchResult.storeURL]];
}

- (IBAction)close:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    //Using the view controller containment APIs
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [[UIImage imageNamed:@"StoreButton"]stretchableImageWithLeftCapWidth:6 topCapHeight:0];
    [self.storeButton setBackgroundImage:image forState:UIControlStateNormal];
    
    //the pop- up view had a white rounded border    
    self.backgroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backgroundView.layer.borderWidth = 3.0f;
    self.backgroundView.layer.cornerRadius = 10.0f;
    
    self.nameLabel.text = self.searchResult.name;
    NSString *artistName = self.searchResult.artistName;
    if (artistName == nil)
    {
        artistName = @"Unknown";
    }
    
    self.artistNameLabel.text = artistName;
    self.kindLabel.text = [self.searchResult kindForDisplay];
    self.genreLabel.text = self.searchResult.genre;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencyCode:self.searchResult.currency];
    self.priceLabel.text = [formatter stringFromNumber:self.searchResult.price];
    
    [self.artworkImageView setImageWithURL:[NSURL URLWithString:self.searchResult.artworkURL100] placeholderImage:[UIImage imageNamed:@"DetailPlaceholder"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
    [self.artworkImageView cancelImageRequestOperation];
}

@end