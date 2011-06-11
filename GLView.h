//
//  GLView.h
//  OpenGL Application
//
//  Created by Alex Nichol on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <GLUT/glut.h>
#import "MeBoxCamera.h"

#define kBoxZOffset 0.2
#define kAnimMultFactor 1

struct boxTextures {
	int side1;
	int side2;
	int side3;
	int side4;
	int frontLogo;
	int gradient;
	int floor;
	BOOL hasLoaded;
};

@interface GLView : NSOpenGLView {
	NSTimer * animationTimer;
	anCamera camera;
	anCameraAnimation animation;
	float animationInterval;
	float rota;
	BOOL started;
	struct boxTextures textures;
	vector3d lightOffset;
}

- (void)startAnimation;
- (void)stopAnimation;

- (void)setupView;
- (int)textureForImage:(NSString *)imageFile;
- (void)loadTextures;

- (void)setAnimationInterval:(float)i;
- (float)animationInterval;

@end
