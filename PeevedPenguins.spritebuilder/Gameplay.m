//
//  Gameplay.m
//  PeevedPenguins
//
//  Created by Stella Mao on 10/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay {
    CCPhysicsNode* _physicsNode;
    CCNode* _catapultArm;
    CCNode* _levelNode;
    CCNode* _contentNode;
    CCNode* _pullbackNode;
    CCNode *_mouseJointNode;
    CCPhysicsJoint *_mouseJoint;
}

-(void) didLoadFromCCB
{
    self.userInteractionEnabled = YES;
    CCScene *level = [CCBReader loadAsScene:@"Level/Level1"];
    [_levelNode addChild:level];
    // visualize physics bodies & joints
    //_physicsNode.debugDraw = TRUE;
    _pullbackNode.physicsBody.collisionMask = @[];
    _mouseJointNode.physicsBody.collisionMask = @[];
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //[self launchPenguin];
    CGPoint touchPosition = [touch locationInNode:_contentNode];
    if (CGRectContainsPoint([_catapultArm boundingBox], touchPosition)) {
        _mouseJointNode.position = touchPosition;
        _mouseJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:_mouseJointNode.physicsBody bodyB:_catapultArm.physicsBody anchorA:ccp(0, 0) anchorB:ccp(34, 138) restLength:0.f stiffness:3000.f damping:150.f];
    }
}

-(void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPosition = [touch locationInNode:_contentNode];
    _mouseJointNode.position = touchPosition;
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self releaseCatapult];
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self releaseCatapult];
}

- (void)releaseCatapult {
    if (_mouseJoint != nil)
    {
        // releases the joint and lets the catapult snap back
        [_mouseJoint invalidate];
        _mouseJoint = nil;
    }
}

-(void) launchPenguin
{
    CCNode* penguin = [CCBReader load:@"Penguin"];
    penguin.position = ccpAdd(_catapultArm.position, ccp(16, 50));
    [_physicsNode addChild:penguin];
    CGPoint launchDirection = ccp(1, 0);
    CGPoint force = ccpMult(launchDirection, 8000);
    [penguin.physicsBody applyForce:force];
    self.position = ccp(0, 0);
    CCActionFollow *follow = [CCActionFollow actionWithTarget:penguin worldBoundary:self.boundingBox];
    [_contentNode runAction:follow];
}

-(void) retry
{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"Gameplay"]];
}


@end
