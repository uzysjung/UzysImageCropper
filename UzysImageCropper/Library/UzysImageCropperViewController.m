//
//  UzysImageCropperViewController.m
//  UzysImageCropper
//
//  Created by Uzys on 11. 12. 13..
//

#import "UzysImageCropperViewController.h"
#import "UIImage-Extension.h"

@implementation UzysImageCropperViewController
@synthesize cropperView,delegate;

- (id)initWithImage:(UIImage*)newImage andframeSize:(CGSize)frameSize andcropSize:(CGSize)cropSize
{
    self = [super init];
	
	if (self) {
        
        if(newImage.size.width <= cropSize.width || newImage.size.height <= cropSize.height)
        {
            NSLog(@"Image Size is smaller than cropSize");
            newImage = [newImage resizedImageToFitInSize:CGSizeMake(cropSize.width*1.3, cropSize.height*1.3) scaleIfSmaller:YES];
            NSLog(@"newImage Size %@",NSStringFromCGSize(newImage.size));
        }
        self.view.backgroundColor = [UIColor blackColor];
        cropperView = [[UzysImageCropper alloc] 
                       initWithImage:newImage 
                       andframeSize:frameSize
                       andcropSize:cropSize];
        
        [self.view addSubview:cropperView];
        UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
        [navigationBar setBarStyle:UIBarStyleBlack];
        [navigationBar setTranslucent:YES];
        
        UINavigationItem *aNavigationItem = [[UINavigationItem alloc] initWithTitle:@"Image Crop"];
        [aNavigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelCropping)] autorelease]];
        [aNavigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishCropping)] autorelease]];
        
        [navigationBar setItems:[NSArray arrayWithObject:aNavigationItem]];
        
        [aNavigationItem release];
        
        [[self view] addSubview:navigationBar];
        
        [navigationBar release];
        
        UIButton *btn_rotation = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_rotation setFrame:CGRectMake(0 , cropperView.frame.size.height - 32 , 44, 32)];
        [btn_rotation addTarget:self action:@selector(actionRotation:) forControlEvents:UIControlEventTouchUpInside];
        [btn_rotation setImage:[UIImage imageNamed:@"nc_crop_rotate_btn.png"] forState:UIControlStateNormal];
        [btn_rotation setImage:[UIImage imageNamed:@"nc_crop_rotate_btn_h.png"] forState:UIControlStateHighlighted];
        btn_rotation.alpha = 0.7;
        [self.view addSubview:btn_rotation];

        UIButton *btn_restore = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_restore setFrame:CGRectMake(cropperView.frame.size.width -44 , cropperView.frame.size.height - 33 , 44, 33)];
        [btn_restore addTarget:self action:@selector(actionRestore:) forControlEvents:UIControlEventTouchUpInside];
        [btn_restore setImage:[UIImage imageNamed:@"nc_crop_reset_btn.png"] forState:UIControlStateNormal];
        [btn_restore setImage:[UIImage imageNamed:@"nc_crop_reset_btn_h.png"] forState:UIControlStateHighlighted];
        btn_restore.alpha = 0.7;
        [self.view addSubview:btn_restore];
    }
    
    return self;
    
}
-(void) actionRestore:(id) senders
{
    [cropperView actionRestore];
}
-(void) actionRotation:(id) senders
{
    [cropperView actionRotate];
}
- (void)cancelCropping
{
	[delegate imageCropperDidCancel:self]; 
}

- (void)finishCropping
{
	//NSLog(@"%@",@"ImageCropper finish cropping end");
    UIImage *cropped =[cropperView getCroppedImage];
	[delegate imageCropper:self didFinishCroppingWithImage:cropped];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView
//{
// 
//
//}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.cropperView = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [cropperView release];
    [super ah_dealloc];
}
@end
