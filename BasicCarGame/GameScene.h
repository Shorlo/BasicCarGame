//
//  GameScene.h
//  T11E1Jasaba
//

//  Copyright (c) 2015 Shorlo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameController/GameController.h>
@interface GameScene : SKScene

@property BOOL cargarEscena;
@property SKSpriteNode *coche;
@property SKSpriteNode *circuito;
@property SKSpriteNode *fondoPad;
@property SKSpriteNode *pad;
@property GCController *controller;
@property CGPoint moverDireccion;


-(void)configureGameControllers;

@end
