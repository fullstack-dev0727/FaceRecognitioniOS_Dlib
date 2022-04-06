//
//  ViewController.m
//  TestApp
//
//  Created by Administrator on 1/20/16.
//  Copyright © 2016 Manoj. All rights reserved.
//

#import "ViewController.h"
#include "dlib/image_processing/frontal_face_detector.h"
#include "dlib/image_processing/render_face_detections.h"
#include "dlib/image_processing.h"
#include "dlib/gui_widgets.h"
#include "dlib/image_io.h"
#include "iostream"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dlib::frontal_face_detector detector = dlib::get_frontal_face_detector();
    dlib::shape_predictor sp;
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *landmarksPath = [mainBundle pathForResource: @"shape_predictor_68_face_landmarks" ofType: @"dat"];
    const std::string FACE_LANDMARK_MODEL = *new std::string([landmarksPath UTF8String]);
    dlib::deserialize(FACE_LANDMARK_MODEL) >> sp;
    
    NSString *imagePath = [mainBundle pathForResource: @"test" ofType: @"bmp"];
    const std::string imageString = *new std::string([imagePath UTF8String]);
    dlib::array2d<dlib::rgb_pixel> img;
    
//    CMSampleBufferRef frame = nil;
//    dlib::assign_image(img, frame);
    
    dlib::load_image(img, imageString);
    dlib::pyramid_up(img);
    
    std::vector<dlib::rectangle> dets = detector(img);
    std::vector<dlib::full_object_detection> shapes;
    
    if (dets.size() > 0) {
        for (unsigned long j = 0; j < dets.size(); ++j) {
            dlib::full_object_detection shape = sp(img, dets[j]);
            shapes.push_back(shape);
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
@end
