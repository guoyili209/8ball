package com
{
   import com.greensock.OverwriteManager;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class billiardPhysics extends Sprite
   {
       
      
      public var frictionFast:Number;
      
      public var frictionSlow:Number;
      
      public var frictionSpeedThreshold:Number;
      
      public var ballRadius:Number;
      
      public var pocketRadius:Number;
      
      public var physScale:Number;
      
      public var minVelocity:Number;
      
      public var cushionRestitution:Number;
      
      public var ballRestitution:Number;
      
      private var simType:uint = 0;
      
      private var ballArray:Array;
      
      private var lineArray:Array;
      
      private var vertexArray:Array;
      
      private var pocketArray:Array;
      
      private var omissionArray:Array;
      
      public var targetID:int = -1;
      
      public function billiardPhysics(balls:Array, lines:Array, vertices:Array, pockets:Array, sim:uint = 0)
      {
         this.omissionArray = new Array();
         super();
         this.ballArray = balls;
         this.lineArray = lines;
         this.vertexArray = vertices;
         this.pocketArray = pockets;
         this.simType = sim;
         OverwriteManager.init(OverwriteManager.NONE);
      }
      
      public function set ballData(array:Array) : void
      {
         this.ballArray = array;
      }
      
      public function updatePhysics() : void
      {
         this.predictCollisions();
         this.updateFriction();
      }
      
      private function predictCollisions() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:Number = NaN;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:* = undefined;
         var _loc9_:Boolean = false;
         var _loc10_:Object = null;
         var _loc11_:Vector2D = null;
         var _loc12_:* = undefined;
         var _loc13_:uint = 0;
         var _loc14_:Object = null;
         var _loc15_:* = undefined;
         var _loc16_:Vector2D = null;
         var _loc17_:Vector2D = null;
         var _loc18_:Point = null;
         var _loc19_:Point = null;
         var _loc20_:Point = null;
         var _loc21_:Number = NaN;
         var _loc22_:Object = null;
         var _loc23_:Point = null;
         var _loc24_:* = undefined;
         var _loc25_:* = undefined;
         var _loc26_:* = undefined;
         var _loc27_:* = undefined;
         var _loc28_:uint = 0;
         var _loc29_:uint = 0;
         var _loc30_:uint = 0;
         var _loc31_:Object = null;
         var _loc32_:Point = null;
         var _loc33_:Vector2D = null;
         var _loc34_:* = undefined;
         var _loc35_:* = undefined;
         var _loc36_:* = undefined;
         var _loc37_:Object = null;
         var _loc38_:Point = null;
         var _loc39_:Point = null;
         var _loc40_:Point = null;
         var _loc41_:Number = NaN;
         var _loc42_:Object = null;
         var _loc43_:Point = null;
         var _loc44_:* = undefined;
         var _loc45_:* = undefined;
         var _loc46_:* = undefined;
         var _loc47_:* = undefined;
         var _loc48_:Object = null;
         var _loc49_:Point = null;
         var _loc50_:Point = null;
         var _loc51_:Point = null;
         var _loc52_:Number = NaN;
         var _loc53_:Object = null;
         var _loc54_:Point = null;
         var _loc55_:* = undefined;
         var _loc56_:* = undefined;
         var _loc57_:* = undefined;
         var _loc58_:* = undefined;
         var _loc1_:* = 0;
         do
         {
            _loc2_ = 1;
            _loc4_ = new Array();
            _loc5_ = Maths.fixNumber(1 - _loc1_);
            _loc6_ = 0;
            if(this.simType == 0)
            {
               _loc6_ = this.ballArray.length;
            }
            if(this.simType == 1)
            {
               _loc6_ = 1;
            }
            if(this.simType == 2)
            {
               if(this.targetID == -1)
               {
                  _loc6_ = 1;
               }
               else
               {
                  _loc6_ = this.ballArray.length;
               }
            }
            for(_loc7_ = 0; _loc7_ < _loc6_; _loc7_++)
            {
               _loc9_ = false;
               if(this.simType == 2 && this.targetID != -1 && _loc7_ != this.targetID && _loc7_ != 0)
               {
                  _loc9_ = true;
               }
               _loc10_ = this.ballArray[_loc7_];
               if(_loc10_.active == true && _loc9_ == false)
               {
                  _loc11_ = _loc10_.position.plus(_loc10_.velocity.times(_loc5_));
                  if(this.simType == 2)
                  {
                     _loc12_ = 0;
                  }
                  else
                  {
                     _loc12_ = _loc7_;
                  }
                  for(_loc13_ = _loc12_; _loc13_ < this.ballArray.length; _loc13_++)
                  {
                     _loc14_ = this.ballArray[_loc13_];
                     if(_loc10_.velocity.magnitudeSquared != 0 || _loc14_.velocity.magnitudeSquared != 0)
                     {
                        _loc15_ = true;
                        if(this.simType != 1)
                        {
                           if(Math.abs(_loc10_.position.x - _loc14_.position.x) < 8000 && Math.abs(_loc10_.position.y - _loc14_.position.y) < 8000)
                           {
                              _loc15_ = true;
                           }
                           else
                           {
                              _loc15_ = false;
                           }
                        }
                        if(_loc14_ != _loc10_ && _loc14_.active == true && _loc15_ == true)
                        {
                           _loc16_ = _loc10_.velocity.minus(_loc14_.velocity);
                           _loc17_ = _loc10_.position.plus(_loc16_.times(_loc5_));
                           _loc18_ = new Point(_loc10_.position.x,_loc10_.position.y);
                           _loc19_ = new Point(_loc17_.x,_loc17_.y);
                           _loc20_ = new Point(_loc14_.position.x,_loc14_.position.y);
                           _loc21_ = 2 * this.ballRadius;
                           _loc22_ = Maths.lineIntersectCircle(_loc18_,_loc19_,_loc20_,_loc21_);
                           if(_loc22_.enter != null)
                           {
                              _loc23_ = _loc22_.enter;
                              _loc24_ = new Vector2D(_loc23_.x,_loc23_.y);
                              _loc25_ = Maths.createVectorFrom2Points(_loc18_,_loc19_);
                              _loc26_ = Maths.createVectorFrom2Points(_loc18_,_loc23_);
                              _loc27_ = Maths.fixNumber(_loc1_ + _loc26_.magnitude / _loc25_.magnitude * _loc5_);
                              if(_loc27_ < _loc2_)
                              {
                                 _loc3_ = new Object();
                                 _loc2_ = _loc27_;
                                 _loc3_.type = "ball";
                                 _loc3_.object = _loc10_;
                                 _loc3_.objectIntersectPoint = _loc10_.position.plus(_loc10_.velocity.times(_loc2_ - _loc1_));
                                 _loc3_.target = _loc14_;
                                 _loc3_.targetIntersectPoint = _loc14_.position.plus(_loc14_.velocity.times(_loc2_ - _loc1_));
                                 _loc4_ = new Array();
                                 _loc4_.push(_loc3_);
                              }
                              else if(_loc27_ == _loc2_)
                              {
                                 if(_loc27_ != 1)
                                 {
                                    _loc3_ = new Object();
                                    _loc2_ = _loc27_;
                                    _loc3_.type = "ball";
                                    _loc3_.object = _loc10_;
                                    _loc3_.objectIntersectPoint = _loc10_.position.plus(_loc10_.velocity.times(_loc2_ - _loc1_));
                                    _loc3_.target = _loc14_;
                                    _loc3_.targetIntersectPoint = _loc14_.position.plus(_loc14_.velocity.times(_loc2_ - _loc1_));
                                    _loc4_.push(_loc3_);
                                 }
                              }
                           }
                        }
                     }
                  }
                  if(_loc10_.velocity.magnitudeSquared != 0)
                  {
                     for(_loc28_ = 0; _loc28_ < this.lineArray.length; _loc28_++)
                     {
                        _loc31_ = this.lineArray[_loc28_];
                        _loc32_ = Maths.lineIntersectLine(new Point(_loc10_.position.x,_loc10_.position.y),new Point(_loc11_.x,_loc11_.y),new Point(_loc31_.p3.x,_loc31_.p3.y),new Point(_loc31_.p4.x,_loc31_.p4.y));
                        if(_loc32_ != null)
                        {
                           _loc33_ = new Vector2D(_loc32_.x,_loc32_.y);
                           if(_loc10_.id != 5)
                           {
                           }
                           _loc34_ = Maths.createVectorFrom2Points(_loc10_.position,_loc11_);
                           _loc35_ = Maths.createVectorFrom2Points(_loc10_.position,_loc33_);
                           _loc36_ = Maths.fixNumber(_loc1_ + _loc35_.magnitude / _loc34_.magnitude * _loc5_);
                           if(_loc36_ < _loc2_)
                           {
                              _loc3_ = new Object();
                              _loc2_ = _loc36_;
                              _loc3_.type = "line";
                              _loc3_.object = _loc10_;
                              _loc3_.objectIntersectPoint = _loc33_;
                              _loc3_.target = _loc31_;
                              _loc4_ = new Array();
                              _loc4_.push(_loc3_);
                           }
                           else if(_loc36_ == _loc2_)
                           {
                              if(_loc36_ != 1)
                              {
                                 _loc3_ = new Object();
                                 _loc2_ = _loc36_;
                                 _loc3_.type = "line";
                                 _loc3_.object = _loc10_;
                                 _loc3_.objectIntersectPoint = _loc33_;
                                 _loc3_.target = _loc31_;
                                 _loc4_.push(_loc3_);
                              }
                           }
                        }
                     }
                     for(_loc29_ = 0; _loc29_ < this.vertexArray.length; _loc29_++)
                     {
                        _loc37_ = this.vertexArray[_loc29_];
                        _loc15_ = true;
                        if(this.simType != 1)
                        {
                           if(Math.abs(_loc10_.position.x - _loc37_.position.x) < 8000 && Math.abs(_loc10_.position.y - _loc37_.position.y) < 8000)
                           {
                              _loc15_ = true;
                           }
                           else
                           {
                              _loc15_ = false;
                           }
                        }
                        if(_loc15_ == true)
                        {
                           _loc38_ = new Point(_loc10_.position.x,_loc10_.position.y);
                           _loc39_ = new Point(_loc11_.x,_loc11_.y);
                           _loc40_ = new Point(_loc37_.position.x,_loc37_.position.y);
                           _loc41_ = this.ballRadius;
                           _loc42_ = Maths.lineIntersectCircle(_loc38_,_loc39_,_loc40_,_loc41_);
                           if(_loc42_.enter != null)
                           {
                              _loc43_ = _loc42_.enter;
                              _loc44_ = new Vector2D(_loc43_.x,_loc43_.y);
                              _loc45_ = Maths.createVectorFrom2Points(_loc38_,_loc39_);
                              _loc46_ = Maths.createVectorFrom2Points(_loc38_,_loc43_);
                              _loc47_ = Maths.fixNumber(_loc1_ + _loc46_.magnitude / _loc45_.magnitude * _loc5_);
                              if(_loc47_ < _loc2_)
                              {
                                 _loc3_ = new Object();
                                 _loc2_ = _loc47_;
                                 _loc3_.type = "vertex";
                                 _loc3_.object = _loc10_;
                                 _loc3_.objectIntersectPoint = new Vector2D(_loc43_.x,_loc43_.y);
                                 _loc3_.target = _loc37_;
                                 _loc4_ = new Array();
                                 _loc4_.push(_loc3_);
                              }
                              else if(_loc47_ == _loc2_)
                              {
                                 if(_loc47_ != 1)
                                 {
                                    _loc3_ = new Object();
                                    _loc2_ = _loc47_;
                                    _loc3_.type = "vertex";
                                    _loc3_.object = _loc10_;
                                    _loc3_.objectIntersectPoint = new Vector2D(_loc43_.x,_loc43_.y);
                                    _loc3_.target = _loc37_;
                                    _loc4_ = new Array();
                                    _loc4_.push(_loc3_);
                                    _loc4_.push(_loc3_);
                                 }
                              }
                           }
                        }
                     }
                     for(_loc30_ = 0; _loc30_ < this.pocketArray.length; _loc30_++)
                     {
                        _loc48_ = this.pocketArray[_loc30_];
                        _loc15_ = true;
                        if(this.simType != 1)
                        {
                           if(Math.abs(_loc10_.position.x - _loc48_.position.x) < 8000 && Math.abs(_loc10_.position.y - _loc48_.position.y) < 8000)
                           {
                              _loc15_ = true;
                           }
                           else
                           {
                              _loc15_ = false;
                           }
                        }
                        if(_loc15_ == true)
                        {
                           _loc49_ = new Point(_loc10_.position.x,_loc10_.position.y);
                           _loc50_ = new Point(_loc11_.x,_loc11_.y);
                           _loc51_ = new Point(_loc48_.position.x,_loc48_.position.y);
                           _loc52_ = this.pocketRadius;
                           _loc53_ = Maths.lineIntersectCircle(_loc49_,_loc50_,_loc51_,_loc52_);
                           if(_loc53_.enter != null)
                           {
                              _loc54_ = _loc53_.enter;
                              _loc55_ = new Vector2D(_loc54_.x,_loc54_.y);
                              _loc56_ = Maths.createVectorFrom2Points(_loc49_,_loc50_);
                              _loc57_ = Maths.createVectorFrom2Points(_loc49_,_loc54_);
                              _loc58_ = Maths.fixNumber(_loc1_ + _loc57_.magnitude / _loc56_.magnitude * _loc5_);
                              if(_loc58_ < _loc2_)
                              {
                                 _loc3_ = new Object();
                                 _loc2_ = _loc58_;
                                 _loc3_.type = "pocket";
                                 _loc3_.object = _loc10_;
                                 _loc3_.objectIntersectPoint = new Vector2D(_loc54_.x,_loc54_.y);
                                 _loc3_.target = _loc48_;
                                 _loc4_ = new Array();
                                 _loc4_.push(_loc3_);
                              }
                              else if(_loc58_ == _loc2_)
                              {
                                 if(_loc58_ != 1)
                                 {
                                    _loc3_ = new Object();
                                    _loc2_ = _loc58_;
                                    _loc3_.type = "pocket";
                                    _loc3_.object = _loc10_;
                                    _loc3_.objectIntersectPoint = new Vector2D(_loc54_.x,_loc54_.y);
                                    _loc3_.target = _loc48_;
                                    _loc4_ = new Array();
                                    _loc4_.push(_loc3_);
                                    _loc4_.push(_loc3_);
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
            if(_loc4_.length > 0)
            {
               this.resolveCollision(_loc4_);
            }
            _loc8_ = Maths.fixNumber(_loc2_ - _loc1_);
            if(this.simType != 1)
            {
               this.moveBalls(_loc8_);
            }
            _loc1_ = _loc2_;
         }
         while(_loc4_.length > 0);
         
      }
      
      private function resolveCollision(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Vector2D = null;
         var _loc8_:Vector2D = null;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:Object = null;
         var _loc16_:Object = null;
         var _loc17_:Object = null;
         var _loc18_:* = undefined;
         this.omissionArray = new Array();
         if(param1.length <= 1)
         {
         }
         for(var _loc2_:uint = 0; _loc2_ < param1.length; _loc2_++)
         {
            _loc3_ = param1[_loc2_];
            if(_loc3_.type == "ball")
            {
               _loc5_ = _loc3_.object;
               _loc5_.position = _loc3_.objectIntersectPoint;
               _loc6_ = _loc3_.target;
               if(this.targetID == -1)
               {
                  this.targetID = _loc6_.id;
               }
               _loc6_.position = _loc3_.targetIntersectPoint;
               this.omissionArray.push(_loc5_);
               this.omissionArray.push(_loc6_);
               _loc7_ = new Vector2D(_loc6_.position.minus(_loc5_.position).normalize());
               _loc8_ = _loc7_.getRightNormal();
               _loc9_ = _loc7_.times(_loc5_.velocity.dot(_loc7_));
               _loc10_ = _loc8_.times(_loc5_.velocity.dot(_loc8_));
               _loc11_ = _loc7_.times(_loc6_.velocity.dot(_loc7_));
               _loc12_ = _loc8_.times(_loc6_.velocity.dot(_loc8_));
               if(Math.abs(_loc6_.ySpin) < Math.abs(_loc5_.ySpin))
               {
                  _loc6_.ySpin = _loc5_.ySpin * -0.5;
               }
               if(_loc5_.id == 0 && _loc5_.firstContact == false)
               {
                  _loc5_.deltaScrew = _loc9_.times(-_loc5_.screw * 0.17);
                  if(_loc5_.type != "real")
                  {
                  }
               }
               _loc13_ = _loc11_.times(this.ballRestitution).plus(_loc9_.times(1 - this.ballRestitution));
               _loc14_ = _loc9_.times(this.ballRestitution).plus(_loc11_.times(1 - this.ballRestitution));
               _loc5_.velocity = _loc10_.plus(_loc13_);
               _loc6_.velocity = _loc12_.plus(_loc14_);
               if(this.simType == 0)
               {
                  if(_loc14_.magnitude > 450)
                  {
                     _loc6_.grip = 0;
                  }
               }
               _loc5_.lastCollisionObject = _loc6_;
               _loc6_.lastCollisionObject = _loc5_;
            }
            if(_loc3_.type == "line")
            {
               _loc5_ = _loc3_.object;
               _loc5_.position = _loc3_.objectIntersectPoint;
               _loc15_ = _loc3_.target;
               this.omissionArray.push(_loc5_);
               _loc5_.ySpin += -_loc5_.velocity.dot(_loc15_.direction) / 300;
               if(_loc5_.ySpin > 20)
               {
                  _loc5_.ySpin = 20;
               }
               if(_loc5_.ySpin < -20)
               {
                  _loc5_.ySpin = -20;
               }
               _loc9_ = _loc15_.normal.times(_loc5_.velocity.dot(_loc15_.normal));
               _loc10_ = _loc15_.direction.times(_loc5_.velocity.dot(_loc15_.direction));
               if(_loc5_.id == 0)
               {
                  _loc10_ = _loc10_.plus(_loc15_.direction.times(Maths.fixNumber(_loc5_.english * 0.2 * _loc5_.velocity.magnitude)));
                  _loc5_.english = Maths.fixNumber(_loc5_.english * 0.5);
                  if(_loc5_.english > -0.1 && _loc5_.english < 0.1)
                  {
                     _loc5_.english = 0;
                  }
               }
               _loc5_.velocity = _loc9_.times(-this.cushionRestitution).plus(_loc10_);
               if(this.simType == 0)
               {
                  if(_loc9_.magnitude > 700)
                  {
                     _loc5_.grip = 0;
                  }
               }
               _loc5_.lastCollisionObject = _loc15_;
               _loc5_.position = _loc5_.position.plus(_loc5_.velocity.normalize());
               if(_loc5_.id == 0)
               {
                  _loc5_.deltaScrew = _loc5_.deltaScrew.times(0.8);
               }
            }
            if(_loc3_.type == "vertex")
            {
               _loc5_ = _loc3_.object;
               _loc5_.position = _loc3_.objectIntersectPoint;
               _loc16_ = _loc3_.target;
               this.omissionArray.push(_loc5_);
               _loc7_ = new Vector2D(_loc16_.position.minus(_loc5_.position).normalize());
               _loc8_ = _loc7_.getRightNormal();
               _loc9_ = _loc7_.times(_loc5_.velocity.dot(_loc7_));
               _loc10_ = _loc8_.times(_loc5_.velocity.dot(_loc8_));
               if(_loc5_.lastCollisionObject != _loc16_)
               {
                  _loc5_.velocity = _loc9_.times(-this.cushionRestitution).plus(_loc10_);
               }
               _loc5_.lastCollisionObject = _loc16_;
               _loc5_.position = _loc5_.position.plus(_loc5_.velocity.normalize());
               if(_loc5_.id == 0)
               {
                  _loc5_.deltaScrew = new Vector2D(0,0);
               }
            }
            if(_loc3_.type == "pocket")
            {
               _loc5_ = _loc3_.object;
               _loc5_.position = _loc3_.objectIntersectPoint;
               _loc17_ = _loc3_.target;
               this.omissionArray.push(_loc5_);
               _loc5_.active = false;
               _loc18_ = _loc5_.velocity.magnitude;
               _loc5_.velocity = new Vector2D(0,0);
               if(_loc5_.hasOwnProperty("mc"))
               {
               }
            }
            _loc4_ = new Object();
            _loc4_.collisionType = _loc3_.type;
            _loc4_.ball = _loc5_;
            _loc4_.target = _loc3_.target;
            _loc4_.ballVelocity = _loc5_.velocity;
            if(_loc3_.type == "ball")
            {
               _loc4_.targetVelocity = _loc6_.velocity;
               if(_loc5_.id == 0)
               {
                  _loc4_.deltaScrew = _loc5_.deltaScrew;
               }
            }
            if(_loc3_.type == "line" || _loc3_.type == "vertex")
            {
               _loc4_.normalVelocity = _loc9_;
            }
            if(_loc3_.type == "pocket")
            {
               _loc4_.speed = _loc18_;
            }
            this.sendContactEvent(_loc4_);
            if(_loc3_.type == "ball")
            {
               _loc4_ = new Object();
               _loc4_.collisionType = _loc3_.type;
               _loc4_.ball = _loc3_.target;
               _loc4_.target = _loc5_;
               _loc4_.ballVelocity = _loc3_.target.velocity;
               _loc4_.targetVelocity = _loc5_.velocity;
               if(_loc6_.id == 0)
               {
                  _loc4_.deltaScrew = _loc3_.target.deltaScrew;
               }
               this.sendContactEvent(_loc4_);
            }
         }
      }
      
      private function sendContactEvent(data:Object) : void
      {
         Dispatcher.GetInstance().dispatchEvent(new CustomEvent(CustomEvent.EVENT,data));
      }
      
      private function moveBalls(delta:Number) : void
      {
         var ball:Object = null;
         for(var n:uint = 0; n < this.ballArray.length; n++)
         {
            ball = this.ballArray[n];
            if(this.omissionArray.length == 0 || this.omissionArray.indexOf(ball) == -1)
            {
               if(ball.active == true)
               {
                  ball.position = ball.position.plus(ball.velocity.times(delta));
               }
            }
         }
         this.omissionArray = new Array();
      }
      
      private function updateFriction() : void
      {
         var ball:Object = null;
         var friction:Number = NaN;
         var normal:* = undefined;
         var swerve:* = undefined;
         for(var b:uint = 0; b < this.ballArray.length; b++)
         {
            ball = this.ballArray[b];
            if(ball.id == 0)
            {
               ball.velocity = ball.velocity.plus(ball.deltaScrew);
               if(ball.deltaScrew.magnitude > 0)
               {
                  ball.deltaScrew = ball.deltaScrew.times(0.8);
                  if(ball.deltaScrew.magnitude < 1)
                  {
                     ball.deltaScrew = new Vector2D(0,0);
                  }
               }
            }
            if(ball.velocity.magnitude >= this.minVelocity * 4)
            {
               friction = this.frictionFast;
            }
            else
            {
               friction = this.frictionSlow;
            }
            ball.velocity = ball.velocity.times(friction);
            if(ball.velocity.magnitude < this.minVelocity)
            {
               ball.velocity = new Vector2D(0,0);
            }
            if(ball.grip < 1)
            {
               ball.grip += 0.03;
            }
            if(ball.ySpin >= 0.2)
            {
               ball.ySpin -= 0.2;
            }
            if(ball.ySpin <= -0.2)
            {
               ball.ySpin += 0.2;
            }
            if(ball.ySpin >= -0.2 && ball.ySpin <= 0.2)
            {
               ball.ySpin = 0;
            }
            if(ball.ySpin != 0)
            {
               normal = ball.velocity.getLeftNormal().normalize();
               swerve = normal.times(0.5 * ball.ySpin * ball.velocity.magnitude / 500);
               ball.velocity = ball.velocity.plus(swerve);
            }
         }
      }
   }
}
