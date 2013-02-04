//
//  ViewController.m
//  UzysImageCropper
//
//  Created by Uzys on 11. 12. 13..
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void) cropButton
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self presentModalViewController:_imgCropperViewController animated:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view setFrame:[UIScreen mainScreen].applicationFrame];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _imgCropperViewController = [[UzysImageCropperViewController alloc] initWithImage:[UIImage imageNamed:@"Hyuna.jpg"] andframeSize:[UIScreen mainScreen].bounds.size andcropSize:CGSizeMake(1024, 580)];
    _imgCropperViewController.delegate = self;
    _imgCropperViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    UIButton *cropper = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cropper setFrame:CGRectMake(0, 0, 100, 30)];
    cropper.center = self.view.center;
    [cropper setTitle:@"Crop" forState:UIControlStateNormal];
    [cropper addTarget:self action:@selector(cropButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cropper];
}

- (void)viewDidUnload
{
    self.resultImgView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [_resultImgView release];
    [_imgCropperViewController release];
    [super ah_dealloc];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UzysImageCropperDelegate

- (void)imageCropper:(UzysImageCropperViewController *)cropper didFinishCroppingWithImage:(UIImage *)image {
    
    if(self.resultImgView)
        [self.resultImgView removeFromSuperview];
    
    self.resultImgView = [[[UIImageView alloc]  initWithImage:image] autorelease];
    self.resultImgView.layer.borderWidth =1;
    self.resultImgView.layer.borderColor = [UIColor orangeColor].CGColor;
    
    [self.resultImgView setFrame:CGRectMake(2, 5, self.view.frame.size.width-4, (self.view.frame.size.width-4)*(image.size.height/image.size.width))];
    [self.view addSubview:self.resultImgView];
    [self dismissModalViewControllerAnimated:YES];

}

- (void)imageCropperDidCancel:(UzysImageCropperViewController *)cropper {
    [self dismissModalViewControllerAnimated:YES];
}
@end
