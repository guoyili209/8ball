package com
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class Ball extends Sprite
   {
       
      
      private var ballRotation:Array;
      
      private var rX:Number = 0;
      
      private var rY:Number = 0;
      
      private var rZ:Number = 0;
      
      private var circRad:Number = 0;
      
      private var ballCanvas:Sprite;
      
      private var ball:Sprite;
      
      private var canvas:*;
      
      private var spot:Sprite;
      
      private var spotHolder:Sprite;
      
      private var _mask:Sprite;
      
      private var shading:Sprite;
      
      private var highlightCanvas:Sprite;
      
      private var highlight:MovieClip;
      
      private var ballColor:int;
      
      private var ballType:uint;
      
      public function Ball(radius:Number, color:int, spotNumber:int)
      {
         this.ballRotation = new Array(1,0,0,0);
         super();
         this.circRad = radius;
         this.ballColor = color;
         if(spotNumber <= 8)
         {
            this.ballType = 0;
         }
         else
         {
            this.ballType = 1;
         }
         this.ballCanvas = new Sprite();
         this.addChild(this.ballCanvas);
         var base:* = new MovieClip();
         this.ballCanvas.addChild(base);
         if(this.ballType == 1)
         {
            base.graphics.beginFill(0xffffff);
            base.graphics.drawCircle(0,0,this.circRad);
            base.graphics.endFill();
         }
         else
         {
            base.graphics.beginFill(this.ballColor);
            base.graphics.drawCircle(0,0,this.circRad);
            base.graphics.endFill();
         }
         base = Rasterize.convertToRaster(base);
         this.ball = new Sprite();
         this.ballCanvas.addChild(this.ball);
         this.canvas = this.ball.graphics;
         this.spotHolder = new Sprite();
         this.ball.addChild(this.spotHolder);
         var spotSource:* = new spot_mc();
         spotSource.gotoAndStop(spotNumber + 1);
         this.spot = Rasterize.convertToRaster(spotSource);
         this.spot.alpha = 0.7;
         this.spotHolder.addChild(this.spot);
         var shade:* = new shading_mc();
         this.ballCanvas.addChild(shade);
         shade.width = this.circRad * 2.2;
         shade.height = this.circRad * 2.2;
         this._mask = new Sprite();
         this._mask.graphics.beginFill(0xff00ff);
         this._mask.graphics.drawCircle(0,0,this.circRad);
         this.ballCanvas.addChild(this._mask);
         this.ballCanvas.mask = this._mask;
         this.updateRotation(Math.random() * 10 - 5,Math.random() * 10 - 5,Math.random() * 10 - 5);
      }
      
      public function updateRotation(vx:Number, vy:Number, r:Number) : void
      {
         var dx:* = -vx;
         var dy:* = r;
         var dz:* = vy;
         var len:Number = Math.sqrt(dx * dx + dy * dy + dz * dz);
         if(len > 0.01)
         {
            this.rotateQuat(this.ballRotation,dy / len,dx / len,dz / len,len / this.circRad);
            this.normalize(this.ballRotation);
            this.renderBall(this.ballRotation);
         }
      }
      
      private function renderBall(q:Array) : void
      {
         var _y1a:Number = NaN;
         var _y2a:Number = NaN;
         var _ha:Number = NaN;
         var tangents:uint = 0;
         var _y1b:* = undefined;
         var _y2b:* = undefined;
         var _hb:* = undefined;
         var tangentA:Number = NaN;
         var tangentB:Number = NaN;
         var qy:* = q[0];
         var qx:* = q[1];
         var qz:* = q[2];
         var qw:* = q[3];
         var rotationY:* = Math.atan2(2 * qy * qw - 2 * qx * qz,1 - 2 * qy * qy - 2 * qz * qz) + Math.PI;
         var rotationX:* = Math.asin(2 * qx * qy + 2 * qz * qw) + Math.PI;
         var rotationZ:* = Math.atan2(2 * qx * qw - 2 * qy * qz,1 - 2 * qx * qx - 2 * qz * qz) + Math.PI;
         var test:* = qx * qy + qz * qw;
         if(test > 0.499)
         {
         }
         if(test < -0.499)
         {
            return;
         }
         this.ball.rotation = 180 / Math.PI * rotationY;
         this.canvas.clear();
         if(this.ballType == 1)
         {
            _y1a = this.circRad * Math.sin(rotationX + Math.PI / 4);
            _y2a = this.circRad * Math.sin(rotationX + 3 * Math.PI / 4);
            _ha = _y2a - _y1a;
            tangents = 0;
            if(_y1a > 0 && _y2a > 0 || _y1a < 0 && _y2a < 0)
            {
               tangentA = this.findTangent(this.circRad * 0.7,Math.abs(_ha / 2),_y1a + _ha / 2);
               if(tangentA < this.circRad)
               {
                  tangents++;
               }
            }
            _y1b = this.circRad * Math.sin(rotationX + 5 * Math.PI / 4);
            _y2b = this.circRad * Math.sin(rotationX + 7 * Math.PI / 4);
            _hb = _y2b - _y1b;
            if(_y1b > 0 && _y2b > 0 || _y1b < 0 && _y2b < 0)
            {
               tangentB = this.findTangent(this.circRad * 0.7,Math.abs(_hb / 2),_y1b + _hb / 2);
               if(tangentB > -100)
               {
                  tangents++;
               }
            }
            if(tangents == 2)
            {
               this.canvas.beginFill(this.ballColor);
               if(rotationX >= Math.PI)
               {
                  this.canvas.drawRect(-this.circRad,tangentA,this.circRad * 2,tangentB - tangentA);
               }
               else
               {
                  this.canvas.drawRect(-this.circRad,tangentB,this.circRad * 2,tangentA - tangentB);
               }
               this.canvas.endFill();
               if(rotationX >= Math.PI)
               {
                  this.canvas.beginFill(this.ballColor);
               }
               else
               {
                  this.canvas.beginFill(0xffffff);
               }
               this.canvas.drawEllipse(-this.circRad * 0.7,_y1a,this.circRad * 0.7 * 2,_ha);
               this.canvas.endFill();
               if(rotationX < Math.PI)
               {
                  this.canvas.beginFill(this.ballColor);
               }
               else
               {
                  this.canvas.beginFill(0xffffff);
               }
               this.canvas.drawEllipse(-this.circRad * 0.7,_y1b,this.circRad * 0.7 * 2,_hb);
               this.canvas.endFill();
            }
            else
            {
               this.canvas.beginFill(this.ballColor);
               this.canvas.drawCircle(0,0,this.circRad);
               this.canvas.endFill();
               this.canvas.beginFill(0xffffff);
               if(rotationX >= Math.PI)
               {
                  this.canvas.drawEllipse(-this.circRad * 0.7,_y1b,this.circRad * 0.7 * 2,_hb);
               }
               else
               {
                  this.canvas.drawEllipse(-this.circRad * 0.7,_y1a,this.circRad * 0.7 * 2,_ha);
               }
               this.canvas.endFill();
            }
         }
         this.spotHolder.x = 0;
         this.spotHolder.y = 0;
         this.spotHolder.rotation = 0;
         this.spot.x = 0;
         this.spot.y = 0;
         this.spot.rotation = 0;
         this.spot.width = 100 * this.circRad / 100;
         this.spot.height = 100 * this.circRad / 100;
         if(rotationX < Math.PI / 2 || rotationX > 3 * Math.PI / 2)
         {
            if(rotationZ > Math.PI / 2 && rotationZ < 3 * Math.PI / 2)
            {
               this.spotHolder.y = this.circRad * Math.cos(rotationZ) * Math.sin(rotationX);
               this.spotHolder.x = this.circRad * Math.sin(rotationZ);
            }
            else
            {
               this.spotHolder.y = -this.circRad * Math.cos(rotationZ) * Math.sin(rotationX);
               this.spotHolder.x = -this.circRad * Math.sin(rotationZ);
            }
         }
         else if(rotationZ > Math.PI / 2 && rotationZ < 3 * Math.PI / 2)
         {
            this.spotHolder.y = -this.circRad * Math.cos(rotationZ) * Math.sin(rotationX);
            this.spotHolder.x = -this.circRad * Math.sin(rotationZ);
         }
         else
         {
            this.spotHolder.y = this.circRad * Math.cos(rotationZ) * Math.sin(rotationX);
            this.spotHolder.x = this.circRad * Math.sin(rotationZ);
         }
         var dist:* = Math.sqrt(this.spotHolder.x * this.spotHolder.x + this.spotHolder.y * this.spotHolder.y);
         var distRatio:* = dist / this.circRad;
         var scaleY:* = Math.cos(distRatio * Math.PI / 2);
         var spotDir:* = Math.atan2(this.spotHolder.y,this.spotHolder.x);
         this.spotHolder.scaleX = 1;
         this.spotHolder.scaleY = scaleY;
         this.spotHolder.rotation = 180 / Math.PI * spotDir + 90;
         this.spot.rotation = -this.spotHolder.rotation;
      }
      
      private function findTangent(a:Number, b:Number, w:Number) : Number
      {
         return w / (1 - b * b / (a * a));
      }
      
      private function rotateQuat(q:Array, _x:Number, _y:Number, _z:Number, angle:Number) : *
      {
         var n:Number = Math.sqrt(_x * _x + _y * _y + _z * _z);
         var nx:Number = _x / n;
         var ny:Number = _y / n;
         var nz:Number = _z / n;
         var s:Number = Math.sin(0.5 * angle);
         var q2x:Number = nx * s;
         var q2y:Number = ny * s;
         var q2z:Number = nz * s;
         var q2w:Number = Math.cos(0.5 * angle);
         var q1x:Number = q[0];
         var q1y:Number = q[1];
         var q1z:Number = q[2];
         var q1w:Number = q[3];
         var dx:Number = q1x * q2w + q1y * q2z - q1z * q2y + q1w * q2x;
         var dy:Number = -q1x * q2z + q1y * q2w + q1z * q2x + q1w * q2y;
         var dz:Number = q1x * q2y - q1y * q2x + q1z * q2w + q1w * q2z;
         var dw:Number = -q1x * q2x - q1y * q2y - q1z * q2z + q1w * q2w;
         q[0] = dx;
         q[1] = dy;
         q[2] = dz;
         q[3] = dw;
      }
      
      private function normalize(q:Array) : *
      {
         var len:Number = Math.sqrt(q[0] * q[0] + q[1] * q[1] + q[2] * q[2] + q[3] * q[3]);
         q[0] /= len;
         q[1] /= len;
         q[2] /= len;
         q[3] /= len;
      }
   }
}
