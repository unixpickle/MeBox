//
//  GLView.m
//  OpenGL Application
//
//  Created by Alex Nichol on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GLView.h"


@implementation GLView

#define DEGREES_TO_RADIANS(__ANGLE) ((__ANGLE) / 180.0 * M_PI)

- (void)timerTick {
	[self setNeedsDisplay:YES];
}

- (void)startAnimation {
	if (animationTimer) {
		[animationTimer invalidate];
	}
	animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
}
- (void)stopAnimation {
	if (animationTimer) [animationTimer invalidate];
	animationTimer = nil;
}

- (void)setAnimationInterval:(float)i {
	BOOL restart = NO;
	if (animationTimer) restart = YES;
	[self stopAnimation];
	animationInterval = i;
	if (restart)
		[self startAnimation];
}
- (float)animationInterval {
	return animationInterval;
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (BOOL)canBecomeKeyView {
	return YES;
}

- (void)keyUp:(NSEvent *)theEvent {
	started = !started;
}

- (void)setupView {
	started = NO;
    const GLfloat zNear = 0.01, fieldOfView = 200.0;
    GLfloat size;
	
    glEnable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);
    size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0);
	
    NSRect rect = [self frame];
    glViewport(0, 0, rect.size.width, rect.size.height);
	
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);	
	
	// magic shit
	//glShadeModel(GL_SMOOTH);							// Enable Smooth Shading
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);				// Black Background
	glClearDepth(1.0f);									// Depth Buffer Setup
	glEnable(GL_DEPTH_TEST);							// Enables Depth Testing
	glDepthFunc(GL_LEQUAL);								// The Type Of Depth Testing To Do
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);	// Really Nice Perspective Calculations
	
	animation = createIDAnimation();
	camera.location = point3dMake(0, 0, 5);
	camera.rotation = vector3dMake(0, 0, 0);
	camera.lookRotation = vector3dMake(0, 0, 0);
	
	glEnable(GL_LIGHT0);
	glEnable(GL_LIGHTING);
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_COLOR_MATERIAL);
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
    if (self) {
		NSOpenGLPixelFormatAttribute attrs[] = {
			NSOpenGLPFADoubleBuffer,
			NSOpenGLPFADepthSize, 32,
			0
		};
		NSOpenGLPixelFormat * format = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
		[self setPixelFormat:format];
		animationTimer = nil;
		animationInterval = 1.0 / 6.0;
		[self startAnimation];
		[self setupView];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		NSOpenGLPixelFormatAttribute attrs[] = {
			NSOpenGLPFADoubleBuffer,
			NSOpenGLPFADepthSize, 32,
			0
		};
		NSOpenGLPixelFormat * format = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
		[self setPixelFormat:format];
		animationTimer = nil;
		animationInterval = 1.0 / 24.0;
		[self startAnimation];
		[self setNeedsDisplay:YES];
		[self performSelector:@selector(setupView) withObject:nil afterDelay:0];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	static int animationStep = -1;
	
	glViewport(0, 0, [self frame].size.width, [self frame].size.height);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	// Calculate the aspect ratio of the view
	gluPerspective(75.0f, [self frame].size.width / [self frame].size.height, 0.1f, 60.0f);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	// lighting
	glLightModeli(GL_LIGHT_MODEL_TWO_SIDE, GL_TRUE);

	glRotatef(camera.lookRotation.x, 1, 0, 0);
	glRotatef(camera.lookRotation.y, 0, 1, 0);
	glRotatef(camera.lookRotation.z, 0, 0, 1);
	
	// Create light components
	GLfloat ambientLight[] = {0, 0, 0, 0.0f};
	GLfloat diffuseLight[] = {1, 1, 1, 1.0f};
	GLfloat specularLight[] = {1, 1, 1, 1.0f};
	GLfloat position[] = {lightOffset.x, lightOffset.y, lightOffset.z, 1};
	
	// Assign created components to GL_LIGHT0
	glLightfv(GL_LIGHT0, GL_AMBIENT, ambientLight);
	glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuseLight);
	glLightfv(GL_LIGHT0, GL_SPECULAR, specularLight);
	glLightfv(GL_LIGHT0, GL_POSITION, position);
	glLightf(GL_LIGHT0, GL_SPOT_CUTOFF, 360);
	
	glEnable(GL_LIGHT0);
	glDisable(GL_CULL_FACE);
	glEnable(GL_LIGHTING);
	glShadeModel(GL_FLAT);
	
	glEnable(GL_DEPTH_TEST);
	
	// draw code here
	
	rota += 1;
	
	[self loadTextures];
	
	
	float colorBlue[] = {0.0f, 0.0f, 1.0f, 1.0f};
	float colorRed[] = {1.0f, 0.0f, 0.0f, 1.0f};
	float colorYellow[] = {1.0f, 1.0f, 0.0f, 1.0f};
	float colorWhite[] = {1.0f, 1.0f, 1.0f, 1.0f};
	float colorGreen[] = {0.0f, 1.0f, 0.0f, 1.0f};
	
	glEnable(GL_BLEND);
	glEnable(GL_ALPHA);
	glEnable(GL_POLYGON_SMOOTH);

	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);
	
	//glTranslatef(0, 0, -5);
	//glRotatef(cos(rota * 0.0174532925) * 360, 1, sin(rota * 0.0174532925), 1);
	
	if (!applyCameraAnimationToCamera(&animation, &camera) && started) {
		if (animationStep == -1) {
			animationStep = 0;
			animation.destRotation = vector3dMake(0, 360, 0);
			animation.rotationMovement = vector3dMake(0, 5 * kAnimMultFactor, 0);
		} else if (animationStep == 0) {
			animationStep = 1;
			animation.destLocation = point3dMake(0, 5, kBoxZOffset);
			animation.locationMovement = vector3dMake(0.1 * kAnimMultFactor, 0.1 * kAnimMultFactor, 0.1 * kAnimMultFactor);
			animation.lookRotationMovement = vector3dMake(2 * kAnimMultFactor, 0, 0);
			animation.destLookRotation = vector3dMake(90, 0, 0);
		} else if (animationStep == 1) {
			animationStep = 2;
			animation.destLocation = point3dMake(0, 0, kBoxZOffset);
			animation.locationMovement = vector3dMake(0.1 * kAnimMultFactor, 0.1 * kAnimMultFactor, 0.1 * kAnimMultFactor);
			animation.lookRotationMovement = vector3dMake(1.7 * kAnimMultFactor, 0, 0);
			animation.destLookRotation = vector3dMake(0, 0, 0);
		} else if (animationStep == 2) {
			animationStep = 3;
			// rotate back to 0.
			animation.delay = 24*2;
			animation.rotationMovement = vector3dMake(0, 1.7 * kAnimMultFactor, 0);
			animation.destRotation = vector3dMake(0, 0, 0);
		} else if (animationStep == 3) {
			animationStep = 4;
			// move back to top, spinning box 180 degrees.
			animation.delay = 24;
			animation.destLocation = point3dMake(0, 5, kBoxZOffset);
			animation.locationMovement = vector3dMake(0.15 * kAnimMultFactor, 0.15 * kAnimMultFactor, 0.15 * kAnimMultFactor);
			animation.rotationMovement = vector3dMake(0, 4.2 * kAnimMultFactor, 0);
			animation.destRotation = vector3dMake(0, 180, 0);
			animation.lookRotationMovement = vector3dMake(2.6 * kAnimMultFactor, 0, 0);
			animation.destLookRotation = vector3dMake(90, 0, 0);
		} else if (animationStep == 4) {
			animationStep = 5;
			// go back to the front of the box.
			animation.destLocation = point3dMake(0, 0, 5);
			animation.locationMovement = vector3dMake(0.1 * kAnimMultFactor, 0.1 * kAnimMultFactor, 0.1 * kAnimMultFactor);
			animation.lookRotationMovement = vector3dMake(2 * kAnimMultFactor, 0, 0);
			animation.destLookRotation = vector3dMake(0, 0, 0);
		} else if (animationStep == 5) {
			animationStep = 6;
			// zoom in to the face of the box.
			animation.destLocation = point3dMake(0, 0, 1.1);
			animation.locationMovement = vector3dMake(0.1 * kAnimMultFactor, 0.1 * kAnimMultFactor, 0.1 * kAnimMultFactor);			
		} else {
			// reset.
			animation = createIDAnimation();
			camera.location = point3dMake(0, 0, 5);
			camera.rotation = vector3dMake(0, 0, 0);
			camera.lookRotation = vector3dMake(0, 0, 0);
			animationStep = -1;
		}
	} else if (!started) {
		animation = createIDAnimation();
		camera.location = point3dMake(0, 0, 5);
		camera.rotation = vector3dMake(0, 0, 0);
		camera.lookRotation = vector3dMake(0, 0, 0);
		animationStep = -1;
	}
	
	BOOL shouldDrawTextures = (animationStep == 3 && animation.incrCount > animation.delay / 2 || animationStep == 4 && animation.incrCount < 10);

	if (shouldDrawTextures) {
		lightOffset = vector3dMake(0, 0, 0);
	} else {
		lightOffset = vector3dMake(0, 0, 0);
	}
	
	glTranslatef(-camera.location.x, -camera.location.y, -camera.location.z);
	glRotatef(camera.rotation.x, 1, 0, 0);
	glRotatef(camera.rotation.y, 0, 1, 0);
	glRotatef(camera.rotation.z, 0, 0, 1);
	
	glEnable(GL_NORMALIZE);
	
	/* Back Face */
	glPushMatrix();
	if (!shouldDrawTextures)
		glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, colorRed);
	else {
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, textures.side1);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	}
	glBegin(GL_QUADS);
	glNormal3f(0, 0, 1);
	if (shouldDrawTextures) glTexCoord2f(1, 0);
	glVertex3d(-1, 0.5, -1);
	if (shouldDrawTextures) glTexCoord2f(1, 1);
	glVertex3d(-1, -0.5, -1);
	if (shouldDrawTextures) glTexCoord2f(0, 1);
	glVertex3d(1, -0.5, -1);
	if (shouldDrawTextures) glTexCoord2f(0, 0);
	glVertex3d(1, 0.5, -1);
	glEnd();
	glPopMatrix();
	
	/* Front Face */
	glPushMatrix();
	if (!shouldDrawTextures)
		glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, colorBlue);
	else {
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, textures.side3);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	}
	glBegin(GL_QUADS);
	glNormal3f(0, 0, 1);
	if (shouldDrawTextures) glTexCoord2f(1, 0);
	glVertex3d(-1, 0.5, 1);
	if (shouldDrawTextures) glTexCoord2f(1, 1);
	glVertex3d(-1, -0.5, 1);
	if (shouldDrawTextures) glTexCoord2f(0, 1);
	glVertex3d(1, -0.5, 1);
	if (shouldDrawTextures) glTexCoord2f(0, 0);
	glVertex3d(1, 0.5, 1);
	glEnd();
	glPopMatrix();
		
	/* Left Face */
	glPushMatrix();
	if (!shouldDrawTextures)
		glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, colorYellow);
	else {
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, textures.side2);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	}
	glBegin(GL_QUADS);
	glNormal3f(-1, 0, 0);
	if (shouldDrawTextures) glTexCoord2f(1, 0);
	glVertex3d(-1, 0.5, -1);
	if (shouldDrawTextures) glTexCoord2f(1, 1);
	glVertex3d(-1, -0.5, -1);
	if (shouldDrawTextures) glTexCoord2f(0, 1);
	glVertex3d(-1, -0.5, 1);
	if (shouldDrawTextures) glTexCoord2f(0, 0);
	glVertex3d(-1, 0.5, 1);
	glEnd();
	glPopMatrix();
	
	/* Right Face */
	glPushMatrix();
	if (!shouldDrawTextures)
		glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, colorGreen);
	else {
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, textures.side4);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	}
	glBegin(GL_QUADS);
	glNormal3f(-1, 0, 0);
	if (shouldDrawTextures) glTexCoord2f(0, 0);
	glVertex3d(1, 0.5, -1);
	if (shouldDrawTextures) glTexCoord2f(0, 1);
	glVertex3d(1, -0.5, -1);
	if (shouldDrawTextures) glTexCoord2f(1, 1);
	glVertex3d(1, -0.5, 1);
	if (shouldDrawTextures) glTexCoord2f(1, 0);
	glVertex3d(1, 0.5, 1);
	glEnd();
	glPopMatrix();
	
	/* Top Face */
	// glBegin(GL_QUADS);
	// glNormal3f(0, 1, 0);
	// glVertex3d(0.5, 0.5, -0.5);
	// glVertex3d(-0.5, 0.5, -0.5);
	// glVertex3d(-0.5, 0.5, 0.5);
	// glVertex3d(0.5, 0.5, 0.5);
	// glEnd();
	
	/* Bottom Face */
	
	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, colorWhite);
	
	glBegin(GL_QUADS);
	glNormal3f(0, 1, 0);
	glVertex3d(1, -0.5, -1);
	glVertex3d(-1, -0.5, -1);
	glVertex3d(-1, -0.5, 1);
	glVertex3d(1, -0.5, 1);
	glEnd();
	
    glFlush();
	[[self openGLContext] flushBuffer];
}

#pragma mark mark Textures

- (int)textureForImage:(NSString *)imageFile {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	unsigned int tex = 0;
	NSImage * texImg = [NSImage imageNamed:imageFile];
	NSImage * resized = [[NSImage alloc] initWithSize:NSMakeSize(1024, 1024)];
	[resized lockFocus];
	[texImg drawInRect:NSMakeRect(0, 0, 1024, 1024) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	[resized unlockFocus];
	NSBitmapImageRep * bitmap = [NSBitmapImageRep imageRepWithData:[resized TIFFRepresentation]];
	glGenTextures(1, &tex);
	glBindTexture(GL_TEXTURE_2D, tex);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, [bitmap pixelsWide], [bitmap pixelsHigh], 0, GL_RGBA, GL_UNSIGNED_BYTE, [bitmap bitmapData]);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); // Linear Filtering
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR); // Linear Filtering
	[resized release];
	[pool drain];
	return tex;
}

- (void)loadTextures {
	if (textures.hasLoaded) return;
	textures.side1 = [self textureForImage:@"side1.png"];
	textures.side2 = [self textureForImage:@"side2.png"];
	textures.side3 = [self textureForImage:@"side3.png"];
	textures.side4 = [self textureForImage:@"side4.png"];
	textures.hasLoaded = YES;
}

@end
