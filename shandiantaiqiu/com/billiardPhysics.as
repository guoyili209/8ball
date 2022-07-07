package com
{
   import com.greensock.OverwriteManager;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Vector3D;

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

      public function set ballData(array:Array):void
      {
         this.ballArray = array;
      }

      public function updatePhysics():void
      {
         this.predictCollisions();
         this.updateFriction();
      }

      private function predictCollisions():void
      {
         var compare_nu:Number = 0;
         var compare_obj:Object = null;
         var collision_arr:Array = null;
         var times_nu:Number = NaN;
         var ball_arr_len:uint = 0;
         var logic_ball:Object = null;
         var logic_ball_pos_plus_velocity_vec2:Vector2D = null;
         var other_logic_ball:Object = null;
         var fix_nu:Number = 0;
         do
         {
            compare_nu = 1;
            collision_arr = new Array();
            times_nu = Maths.fixNumber(1 - fix_nu);
            ball_arr_len = 0;
            if (this.simType == 0)
            {
               ball_arr_len = this.ballArray.length;
            }
            if (this.simType == 1)
            {
               ball_arr_len = 1;
            }
            if (this.simType == 2)
            {
               if (this.targetID == -1)
               {
                  ball_arr_len = 1;
               }
               else
               {
                  ball_arr_len = this.ballArray.length;
               }
            }
            for (var i:uint = 0; i < ball_arr_len; i++)
            {
               var bool:Boolean = false;
               if (this.simType == 2 && this.targetID != -1 && i != this.targetID && i != 0)
               {
                  bool = true;
               }
               logic_ball = this.ballArray[i];
               if (logic_ball.active == true && bool == false)
               {
                  logic_ball_pos_plus_velocity_vec2 = logic_ball.position.plus(logic_ball.velocity.times(times_nu));
                  var index:uint = 0;
                  if (this.simType == 2)
                  {
                     index = 0;
                  }
                  else
                  {
                     index = i;
                  }
                  var bool_1:Boolean = false;
                  for (var j:uint = index; j < this.ballArray.length; j++)
                  {
                     other_logic_ball = this.ballArray[j];

                     if (logic_ball.velocity.magnitudeSquared != 0 || other_logic_ball.velocity.magnitudeSquared != 0)
                     {
                        bool_1 = true;
                        if (this.simType != 1)
                        {
                           if (Math.abs(logic_ball.position.x - other_logic_ball.position.x) < 8000 && Math.abs(logic_ball.position.y - other_logic_ball.position.y) < 8000)
                           {
                              bool_1 = true;
                           }
                           else
                           {
                              bool_1 = false;
                           }
                        }
                        if (other_logic_ball != logic_ball && other_logic_ball.active == true && bool_1 == true)
                        {
                           var minus_velocity_vec2:Vector2D = logic_ball.velocity.minus(other_logic_ball.velocity);
                           var times_velocity_vec2:Vector2D = logic_ball.position.plus(minus_velocity_vec2.times(times_nu));
                           var logic_ball_pos_pt:Point = new Point(logic_ball.position.x, logic_ball.position.y);
                           var times_velocity_pt:Point = new Point(times_velocity_vec2.x, times_velocity_vec2.y);
                           var other_logic_ball_pos_pt:Point = new Point(other_logic_ball.position.x, other_logic_ball.position.y);
                           var ball_radius:Number = 2 * this.ballRadius;
                           var line_intersect_circle:Object = Maths.lineIntersectCircle(logic_ball_pos_pt, times_velocity_pt, other_logic_ball_pos_pt, ball_radius);
                           if (line_intersect_circle.enter != null)
                           {
                              var enter_point:Point = line_intersect_circle.enter;
                              var enter_vec2:Vector2D = new Vector2D(enter_point.x, enter_point.y);
                              var logic_ball_to_times_velocity_vec2:Vector2D = Maths.createVectorFrom2Points(logic_ball_pos_pt, times_velocity_pt);
                              var logic_ball_to_enter_vec2:Vector2D = Maths.createVectorFrom2Points(logic_ball_pos_pt, enter_point);
                              var new_fix_nu:Number = Maths.fixNumber(fix_nu + logic_ball_to_enter_vec2.magnitude / logic_ball_to_times_velocity_vec2.magnitude * times_nu);
                              if (new_fix_nu < compare_nu)
                              {
                                 compare_obj = new Object();
                                 compare_nu = new_fix_nu;
                                 compare_obj.type = "ball";
                                 compare_obj.object = logic_ball;
                                 compare_obj.objectIntersectPoint = logic_ball.position.plus(logic_ball.velocity.times(compare_nu - fix_nu));
                                 compare_obj.target = other_logic_ball;
                                 compare_obj.targetIntersectPoint = other_logic_ball.position.plus(other_logic_ball.velocity.times(compare_nu - fix_nu));
                                 collision_arr = new Array();
                                 collision_arr.push(compare_obj);
                              }
                              else if (new_fix_nu == compare_nu)
                              {
                                 if (new_fix_nu != 1)
                                 {
                                    compare_obj = new Object();
                                    compare_nu = new_fix_nu;
                                    compare_obj.type = "ball";
                                    compare_obj.object = logic_ball;
                                    compare_obj.objectIntersectPoint = logic_ball.position.plus(logic_ball.velocity.times(compare_nu - fix_nu));
                                    compare_obj.target = other_logic_ball;
                                    compare_obj.targetIntersectPoint = other_logic_ball.position.plus(other_logic_ball.velocity.times(compare_nu - fix_nu));
                                    collision_arr.push(compare_obj);
                                 }
                              }
                           }
                        }
                     }
                  }
                  if (logic_ball.velocity.magnitudeSquared != 0)
                  {
                     for (var k:uint = 0; k < this.lineArray.length; k++)
                     {
                        var line_obj:Object = this.lineArray[k];
                        var line_intersect_pt:Point = Maths.lineIntersectLine(new Point(logic_ball.position.x, logic_ball.position.y), new Point(logic_ball_pos_plus_velocity_vec2.x, logic_ball_pos_plus_velocity_vec2.y), new Point(line_obj.p3.x, line_obj.p3.y), new Point(line_obj.p4.x, line_obj.p4.y));
                        if (line_intersect_pt != null)
                        {
                           var line_intersect_vec2:Vector2D = new Vector2D(line_intersect_pt.x, line_intersect_pt.y);
                           if (logic_ball.id != 5)
                           {
                           }
                           var logic_ball_pos_to_velocity_vec2:Vector2D = Maths.createVectorFrom2Points(logic_ball.position, logic_ball_pos_plus_velocity_vec2);
                           var logic_ball_pos_to_intersect_vec2:Vector2D = Maths.createVectorFrom2Points(logic_ball.position, line_intersect_vec2);
                           var new_fix_nu_line:Number = Maths.fixNumber(fix_nu + logic_ball_pos_to_intersect_vec2.magnitude / logic_ball_pos_to_velocity_vec2.magnitude * times_nu);
                           if (new_fix_nu_line < compare_nu)
                           {
                              compare_obj = new Object();
                              compare_nu = new_fix_nu_line;
                              compare_obj.type = "line";
                              compare_obj.object = logic_ball;
                              compare_obj.objectIntersectPoint = line_intersect_vec2;
                              compare_obj.target = line_obj;
                              collision_arr = new Array();
                              collision_arr.push(compare_obj);
                           }
                           else if (new_fix_nu_line == compare_nu)
                           {
                              if (new_fix_nu_line != 1)
                              {
                                 compare_obj = new Object();
                                 compare_nu = new_fix_nu_line;
                                 compare_obj.type = "line";
                                 compare_obj.object = logic_ball;
                                 compare_obj.objectIntersectPoint = line_intersect_vec2;
                                 compare_obj.target = line_obj;
                                 collision_arr.push(compare_obj);
                              }
                           }
                        }
                     }
                     for (var m:int = 0; m < this.vertexArray.length; m++)
                     {
                        var vertex_obj:Object = this.vertexArray[m];
                        bool_1 = true;
                        if (this.simType != 1)
                        {
                           if (Math.abs(logic_ball.position.x - vertex_obj.position.x) < 8000 && Math.abs(logic_ball.position.y - vertex_obj.position.y) < 8000)
                           {
                              bool_1 = true;
                           }
                           else
                           {
                              bool_1 = false;
                           }
                        }
                        if (bool_1 == true)
                        {
                           var logic_ball_pos_pt_1:Point = new Point(logic_ball.position.x, logic_ball.position.y);
                           var logic_ball_pos_plus_velocity_pt:Point = new Point(logic_ball_pos_plus_velocity_vec2.x, logic_ball_pos_plus_velocity_vec2.y);
                           var vertex_obj_pos_pt:Point = new Point(vertex_obj.position.x, vertex_obj.position.y);
                           var ball_radius_vertex:Number = this.ballRadius;
                           var line_intersect_circle_vertex:Object = Maths.lineIntersectCircle(logic_ball_pos_pt_1, logic_ball_pos_plus_velocity_pt, vertex_obj_pos_pt, ball_radius_vertex);
                           if (line_intersect_circle_vertex.enter != null)
                           {
                              var enter_vertex_pt:Point = line_intersect_circle_vertex.enter;
                              var enter_vertex_vec2:Vector2D = new Vector2D(enter_vertex_pt.x, enter_vertex_pt.y);
                              var logic_ball_pos_to_velocity_vertex_vec2:Vector2D = Maths.createVectorFrom2Points(logic_ball_pos_pt_1, logic_ball_pos_plus_velocity_pt);
                              var logic_ball_to_enter_vertex_vec2:Vector2D = Maths.createVectorFrom2Points(logic_ball_pos_pt_1, enter_vertex_pt);
                              var new_fix_nu_vertex:Number = Maths.fixNumber(fix_nu + logic_ball_to_enter_vertex_vec2.magnitude / logic_ball_pos_to_velocity_vertex_vec2.magnitude * times_nu);
                              if (new_fix_nu_vertex < compare_nu)
                              {
                                 compare_obj = new Object();
                                 compare_nu = new_fix_nu_vertex;
                                 compare_obj.type = "vertex";
                                 compare_obj.object = logic_ball;
                                 compare_obj.objectIntersectPoint = new Vector2D(enter_vertex_pt.x, enter_vertex_pt.y);
                                 compare_obj.target = vertex_obj;
                                 collision_arr = new Array();
                                 collision_arr.push(compare_obj);
                              }
                              else if (new_fix_nu_vertex == compare_nu)
                              {
                                 if (new_fix_nu_vertex != 1)
                                 {
                                    compare_obj = new Object();
                                    compare_nu = new_fix_nu_vertex;
                                    compare_obj.type = "vertex";
                                    compare_obj.object = logic_ball;
                                    compare_obj.objectIntersectPoint = new Vector2D(enter_vertex_pt.x, enter_vertex_pt.y);
                                    compare_obj.target = vertex_obj;
                                    collision_arr = new Array();
                                    collision_arr.push(compare_obj);
                                    collision_arr.push(compare_obj);
                                 }
                              }
                           }
                        }
                     }
                     for (var n:int = 0; n < this.pocketArray.length; n++)
                     {
                        var pocket_obj:Object = this.pocketArray[n];
                        bool_1 = true;
                        if (this.simType != 1)
                        {
                           if (Math.abs(logic_ball.position.x - pocket_obj.position.x) < 8000 && Math.abs(logic_ball.position.y - pocket_obj.position.y) < 8000)
                           {
                              bool_1 = true;
                           }
                           else
                           {
                              bool_1 = false;
                           }
                        }
                        if (bool_1 == true)
                        {
                           var logic_ball_pos_pt_packet:Point = new Point(logic_ball.position.x, logic_ball.position.y);
                           var pos_plus_velocity_pt:Point = new Point(logic_ball_pos_plus_velocity_vec2.x, logic_ball_pos_plus_velocity_vec2.y);
                           var pocket_pos_pt:Point = new Point(pocket_obj.position.x, pocket_obj.position.y);
                           var packetRadius:Number = this.pocketRadius;
                           var line_intersect_circle_packet_obj:Object = Maths.lineIntersectCircle(logic_ball_pos_pt_packet, pos_plus_velocity_pt, pocket_pos_pt, packetRadius);
                           if (line_intersect_circle_packet_obj.enter != null)
                           {
                              var enter_pocket_pt:Point = line_intersect_circle_packet_obj.enter;
                              var enter_pocket_vec2:Vector2D = new Vector2D(enter_pocket_pt.x, enter_pocket_pt.y);
                              var pos_to_velocity_vec2:Vector2D = Maths.createVectorFrom2Points(logic_ball_pos_pt_packet, pos_plus_velocity_pt);
                              var ball_pos_to_enter_vec2:Vector2D = Maths.createVectorFrom2Points(logic_ball_pos_pt_packet, enter_pocket_pt);
                              var new_fix_nu_packet:Number = Maths.fixNumber(fix_nu + ball_pos_to_enter_vec2.magnitude / pos_to_velocity_vec2.magnitude * times_nu);
                              if (new_fix_nu_packet < compare_nu)
                              {
                                 compare_obj = new Object();
                                 compare_nu = new_fix_nu_packet;
                                 compare_obj.type = "pocket";
                                 compare_obj.object = logic_ball;
                                 compare_obj.objectIntersectPoint = new Vector2D(enter_pocket_pt.x, enter_pocket_pt.y);
                                 compare_obj.target = pocket_obj;
                                 collision_arr = new Array();
                                 collision_arr.push(compare_obj);
                              }
                              else if (new_fix_nu_packet == compare_nu)
                              {
                                 if (new_fix_nu_packet != 1)
                                 {
                                    compare_obj = new Object();
                                    compare_nu = new_fix_nu_packet;
                                    compare_obj.type = "pocket";
                                    compare_obj.object = logic_ball;
                                    compare_obj.objectIntersectPoint = new Vector2D(enter_pocket_pt.x, enter_pocket_pt.y);
                                    compare_obj.target = pocket_obj;
                                    collision_arr = new Array();
                                    collision_arr.push(compare_obj);
                                    collision_arr.push(compare_obj);
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
            if (collision_arr.length > 0)
            {
               this.resolveCollision(collision_arr);
            }
            var move_nu:Number = Maths.fixNumber(compare_nu - fix_nu);
            if (this.simType != 1)
            {
               this.moveBalls(move_nu);
            }
            fix_nu = compare_nu;
         }
         while (collision_arr.length > 0);
      }

      private function resolveCollision(resoleveArr:Array):void
      {
         var resoleveObj:Object = null;
         // var _loc4_:Object = null;
         var obj:Object = null;
         var target_obj:Object = null;
         var normalize_vec2:Vector2D = null;
         var right_normal_vec2:Vector2D = null;
         var normalize_times_obj_vec2:* = undefined;
         var right_normal_times_obj_vec2:* = undefined;
         var normalize_times_target_vec2:* = undefined;
         var right_normal_times_target_vec2:* = undefined;
         // var _loc13_:* = undefined;
         // var _loc14_:* = undefined;
         var _loc15_:Object = null;
         // var _loc16_:Object = null;
         // var _loc17_:Object = null;
         var _loc18_:* = undefined;
         this.omissionArray = new Array();
         if (resoleveArr.length <= 1)
         {
         }
         for (var i:uint = 0; i < resoleveArr.length; i++)
         {
            resoleveObj = resoleveArr[i];
            if (resoleveObj.type == "ball")
            {
               obj = resoleveObj.object;
               obj.position = resoleveObj.objectIntersectPoint;
               target_obj = resoleveObj.target;
               if (this.targetID == -1)
               {
                  this.targetID = target_obj.id;
               }
               target_obj.position = resoleveObj.targetIntersectPoint;
               this.omissionArray.push(obj);
               this.omissionArray.push(target_obj);
               normalize_vec2 = new Vector2D(target_obj.position.minus(obj.position).normalize());
               right_normal_vec2 = normalize_vec2.getRightNormal();
               normalize_times_obj_vec2 = normalize_vec2.times(obj.velocity.dot(normalize_vec2));
               right_normal_times_obj_vec2 = right_normal_vec2.times(obj.velocity.dot(right_normal_vec2));
               normalize_times_target_vec2 = normalize_vec2.times(target_obj.velocity.dot(normalize_vec2));
               right_normal_times_target_vec2 = right_normal_vec2.times(target_obj.velocity.dot(right_normal_vec2));
               if (Math.abs(target_obj.ySpin) < Math.abs(obj.ySpin))
               {
                  target_obj.ySpin = obj.ySpin * -0.5;
               }
               if (obj.id == 0 && obj.firstContact == false)
               {
                  obj.deltaScrew = normalize_times_obj_vec2.times(-obj.screw * 0.17);
                  if (obj.type != "real")
                  {
                  }
               }
               var target_plus_obj:Vector2D = normalize_times_target_vec2.times(this.ballRestitution).plus(normalize_times_obj_vec2.times(1 - this.ballRestitution));
               var obj_plus_target:Vector2D = normalize_times_obj_vec2.times(this.ballRestitution).plus(normalize_times_target_vec2.times(1 - this.ballRestitution));
               obj.velocity = right_normal_times_obj_vec2.plus(target_plus_obj);
               target_obj.velocity = right_normal_times_target_vec2.plus(obj_plus_target);
               if (this.simType == 0)
               {
                  if (obj_plus_target.magnitude > 450)
                  {
                     target_obj.grip = 0;
                  }
               }
               obj.lastCollisionObject = target_obj;
               target_obj.lastCollisionObject = obj;
            }
            if (resoleveObj.type == "line")
            {
               obj = resoleveObj.object;
               obj.position = resoleveObj.objectIntersectPoint;
               _loc15_ = resoleveObj.target;
               this.omissionArray.push(obj);
               obj.ySpin += -obj.velocity.dot(_loc15_.direction) / 300;
               if (obj.ySpin > 20)
               {
                  obj.ySpin = 20;
               }
               if (obj.ySpin < -20)
               {
                  obj.ySpin = -20;
               }
               normalize_times_obj_vec2 = _loc15_.normal.times(obj.velocity.dot(_loc15_.normal));
               right_normal_times_obj_vec2 = _loc15_.direction.times(obj.velocity.dot(_loc15_.direction));
               if (obj.id == 0)
               {
                  right_normal_times_obj_vec2 = right_normal_times_obj_vec2.plus(_loc15_.direction.times(Maths.fixNumber(obj.english * 0.2 * obj.velocity.magnitude)));
                  obj.english = Maths.fixNumber(obj.english * 0.5);
                  if (obj.english > -0.1 && obj.english < 0.1)
                  {
                     obj.english = 0;
                  }
               }
               obj.velocity = normalize_times_obj_vec2.times(-this.cushionRestitution).plus(right_normal_times_obj_vec2);
               if (this.simType == 0)
               {
                  if (normalize_times_obj_vec2.magnitude > 700)
                  {
                     obj.grip = 0;
                  }
               }
               obj.lastCollisionObject = _loc15_;
               obj.position = obj.position.plus(obj.velocity.normalize());
               if (obj.id == 0)
               {
                  obj.deltaScrew = obj.deltaScrew.times(0.8);
               }
            }
            if (resoleveObj.type == "vertex")
            {
               obj = resoleveObj.object;
               obj.position = resoleveObj.objectIntersectPoint;
               var target:Object = resoleveObj.target;
               this.omissionArray.push(obj);
               normalize_vec2 = new Vector2D(target.position.minus(obj.position).normalize());
               right_normal_vec2 = normalize_vec2.getRightNormal();
               normalize_times_obj_vec2 = normalize_vec2.times(obj.velocity.dot(normalize_vec2));
               right_normal_times_obj_vec2 = right_normal_vec2.times(obj.velocity.dot(right_normal_vec2));
               if (obj.lastCollisionObject != target)
               {
                  obj.velocity = normalize_times_obj_vec2.times(-this.cushionRestitution).plus(right_normal_times_obj_vec2);
               }
               obj.lastCollisionObject = target;
               obj.position = obj.position.plus(obj.velocity.normalize());
               if (obj.id == 0)
               {
                  obj.deltaScrew = new Vector2D(0, 0);
               }
            }
            if (resoleveObj.type == "pocket")
            {
               obj = resoleveObj.object;
               obj.position = resoleveObj.objectIntersectPoint;
               // _loc17_ = resoleveObj.target;
               this.omissionArray.push(obj);
               obj.active = false;
               _loc18_ = obj.velocity.magnitude;
               obj.velocity = new Vector2D(0, 0);
               if (obj.hasOwnProperty("mc"))
               {
               }
            }
            var contact_obj:Object = new Object();
            contact_obj.collisionType = resoleveObj.type;
            contact_obj.ball = obj;
            contact_obj.target = resoleveObj.target;
            contact_obj.ballVelocity = obj.velocity;
            if (resoleveObj.type == "ball")
            {
               contact_obj.targetVelocity = target_obj.velocity;
               if (obj.id == 0)
               {
                  contact_obj.deltaScrew = obj.deltaScrew;
               }
            }
            if (resoleveObj.type == "line" || resoleveObj.type == "vertex")
            {
               contact_obj.normalVelocity = normalize_times_obj_vec2;
            }
            if (resoleveObj.type == "pocket")
            {
               contact_obj.speed = _loc18_;
            }
            this.sendContactEvent(contact_obj);
            if (resoleveObj.type == "ball")
            {
               contact_obj = new Object();
               contact_obj.collisionType = resoleveObj.type;
               contact_obj.ball = resoleveObj.target;
               contact_obj.target = obj;
               contact_obj.ballVelocity = resoleveObj.target.velocity;
               contact_obj.targetVelocity = obj.velocity;
               if (target_obj.id == 0)
               {
                  contact_obj.deltaScrew = resoleveObj.target.deltaScrew;
               }
               this.sendContactEvent(contact_obj);
            }
         }
      }

      private function sendContactEvent(data:Object):void
      {
         Dispatcher.GetInstance().dispatchEvent(new CustomEvent(CustomEvent.EVENT, data));
      }

      private function moveBalls(delta:Number):void
      {
         var ball:Object = null;
         for (var n:uint = 0; n < this.ballArray.length; n++)
         {
            ball = this.ballArray[n];
            if (this.omissionArray.length == 0 || this.omissionArray.indexOf(ball) == -1)
            {
               if (ball.active == true)
               {
                  ball.position = ball.position.plus(ball.velocity.times(delta));
               }
            }
         }
         this.omissionArray = new Array();
      }

      private function updateFriction():void
      {
         var ball:Object = null;
         var friction:Number = NaN;
         var normal:* = undefined;
         var swerve:* = undefined;
         for (var b:uint = 0; b < this.ballArray.length; b++)
         {
            ball = this.ballArray[b];
            if (ball.id == 0)
            {
               ball.velocity = ball.velocity.plus(ball.deltaScrew);
               if (ball.deltaScrew.magnitude > 0)
               {
                  ball.deltaScrew = ball.deltaScrew.times(0.8);
                  if (ball.deltaScrew.magnitude < 1)
                  {
                     ball.deltaScrew = new Vector2D(0, 0);
                  }
               }
            }
            if (ball.velocity.magnitude >= this.minVelocity * 4)
            {
               friction = this.frictionFast;
            }
            else
            {
               friction = this.frictionSlow;
            }
            ball.velocity = ball.velocity.times(friction);
            if (ball.velocity.magnitude < this.minVelocity)
            {
               ball.velocity = new Vector2D(0, 0);
            }
            if (ball.grip < 1)
            {
               ball.grip += 0.03;
            }
            if (ball.ySpin >= 0.2)
            {
               ball.ySpin -= 0.2;
            }
            if (ball.ySpin <= -0.2)
            {
               ball.ySpin += 0.2;
            }
            if (ball.ySpin >= -0.2 && ball.ySpin <= 0.2)
            {
               ball.ySpin = 0;
            }
            if (ball.ySpin != 0)
            {
               normal = ball.velocity.getLeftNormal().normalize();
               swerve = normal.times(0.5 * ball.ySpin * ball.velocity.magnitude / 500);
               ball.velocity = ball.velocity.plus(swerve);
            }
         }
      }
   }
}


