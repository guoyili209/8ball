package com
{
   public class Vector2D
   {
       
      
      private var xValue:Number = 0;
      
      private var yValue:Number = 0;
      
      public function Vector2D(... args)
      {
         super();
         this.xValue = 0;
         this.yValue = 0;
         if(2 == args.length)
         {
            this.xValue = this.fixNumber(args[0]);
            this.yValue = this.fixNumber(args[1]);
         }
         else if(1 == args.length)
         {
            if(args[0] is Vector2D)
            {
               this.xValue = args[0].x;
               this.yValue = args[0].y;
            }
         }
      }
      
      public function set(... args) : Vector2D
      {
         this.xValue = 0;
         this.yValue = 0;
         if(2 == args.length)
         {
            this.xValue = this.fixNumber(args[0]);
            this.yValue = this.fixNumber(args[1]);
         }
         else if(1 == args.length)
         {
            if(args[0] is Vector2D)
            {
               this.xValue = args[0].x;
               this.yValue = args[0].y;
            }
         }
         return this;
      }
      
      public function plus(... args) : Vector2D
      {
         var v:* = new Vector2D(this);
         for(var i:* = 0; i < args.length; i++)
         {
            if(args[i] is Vector2D)
            {
               v.xValue += args[i].xValue;
               v.yValue += args[i].yValue;
            }
         }
         v.xValue = v.fixNumber(v.xValue);
         v.yValue = v.fixNumber(v.yValue);
         return v;
      }
      
      public function minus(... args) : Vector2D
      {
         var v:* = new Vector2D(this);
         for(var i:* = 0; i < args.length; i++)
         {
            if(args[i] is Vector2D)
            {
               v.xValue -= args[i].xValue;
               v.yValue -= args[i].yValue;
            }
         }
         v.xValue = v.fixNumber(v.xValue);
         v.yValue = v.fixNumber(v.yValue);
         return v;
      }
      
      public function times(... args) : Vector2D
      {
         var v:* = new Vector2D(this);
         if(1 == args.length)
         {
            if(args[0] is Vector2D)
            {
               v.xValue *= args[0].xValue;
               v.yValue *= args[0].yValue;
            }
            else if(isNaN(Number(args[0])))
            {
               v.xValue = v.yValue = 0;
            }
            else
            {
               v.xValue *= Number(args[0]);
               v.yValue *= Number(args[0]);
            }
         }
         else if(2 == args.length)
         {
            if(isNaN(Number(args[0])))
            {
               v.xValue = 0;
            }
            else
            {
               v.xValue *= Number(args[0]);
            }
            if(isNaN(Number(args[1])))
            {
               v.yValue = 0;
            }
            else
            {
               v.yValue *= Number(args[1]);
            }
         }
         v.xValue = v.fixNumber(v.xValue);
         v.yValue = v.fixNumber(v.yValue);
         return v;
      }
      
      public function rotate(rotationAngle:Number) : Vector2D
      {
         var v:* = new Vector2D(this);
         if(isNaN(Number(rotationAngle)))
         {
            return v;
         }
         var currentMagnitude:Number = Math.sqrt(Math.pow(v.xValue,2) + Math.pow(v.yValue,2));
         var newAngleRadians:Number = (Math.atan2(v.yValue,v.xValue) * (180 / Math.PI) + Number(rotationAngle)) * (Math.PI / 180);
         v.xValue = v.fixNumber(currentMagnitude * Math.cos(newAngleRadians));
         v.yValue = v.fixNumber(currentMagnitude * Math.sin(newAngleRadians));
         return v;
      }
      
      public function invert() : Vector2D
      {
         var v:* = new Vector2D(this);
         v.xValue *= -1;
         v.yValue *= -1;
         return v;
      }
      
      public function normalize() : Vector2D
      {
         var v:* = new Vector2D(this);
         return v.times(1 / v.magnitude);
      }
      
      public function project(v:Vector2D) : Vector2D
      {
         var scalar:Number = NaN;
         var n:* = new Vector2D(this);
         if(v is Vector2D)
         {
            scalar = n.dot(v) / Math.pow(v.magnitude,2);
            n.set(v);
            n = n.times(scalar);
         }
         return n;
      }
      
      public function reflect(v:Vector2D) : Vector2D
      {
         var vAfterHorizReflect:Vector2D = null;
         var rotationAngle:Number = NaN;
         var n:* = new Vector2D(this);
         if(v is Vector2D)
         {
            vAfterHorizReflect = new Vector2D(v.yValue,-v.xValue);
            rotationAngle = 2 * n.angleBetween(v);
            if(0 >= n.angleBetweenCos(vAfterHorizReflect))
            {
               rotationAngle *= -1;
            }
            n = n.rotate(rotationAngle);
         }
         return n;
      }
      
      public function dot(v:Vector2D) : Number
      {
         if(v is Vector2D)
         {
            return this.fixNumber(this.xValue * v.xValue + this.yValue * v.yValue);
         }
         return 0;
      }
      
      public function cross(v:Vector2D) : Number
      {
         if(v is Vector2D)
         {
            return Math.abs(this.fixNumber(this.xValue * v.yValue - this.yValue * v.xValue));
         }
         return 0;
      }
      
      public function angleBetween(v:Vector2D) : Number
      {
         if(v is Vector2D)
         {
            return this.fixNumber(Math.acos(this.dot(v) / (this.magnitude * v.magnitude)) * (180 / Math.PI));
         }
         return 0;
      }
      
      public function angleBetweenSin(v:Vector2D) : Number
      {
         if(v is Vector2D)
         {
            return this.fixNumber(this.cross(v) / (this.magnitude * v.magnitude));
         }
         return 0;
      }
      
      public function angleBetweenCos(v:Vector2D) : Number
      {
         if(v is Vector2D)
         {
            return this.fixNumber(this.dot(v) / (this.magnitude * v.magnitude));
         }
         return 0;
      }
      
      public function swap(v:Vector2D) : Vector2D
      {
         var tempX:Number = NaN;
         var tempY:Number = NaN;
         if(v is Vector2D)
         {
            tempX = this.xValue;
            tempY = this.yValue;
            this.xValue = v.xValue;
            this.yValue = v.yValue;
            v.xValue = tempX;
            v.yValue = tempY;
         }
         return this;
      }
      
      public function getRightNormal() : Vector2D
      {
         return new Vector2D(this.yValue,-this.xValue);
      }
      
      public function getLeftNormal() : Vector2D
      {
         return new Vector2D(-this.yValue,this.xValue);
      }
      
      public function isNormalTo(v:Vector2D) : Boolean
      {
         if(v is Vector2D)
         {
            return this.dot(v) === 0;
         }
         return false;
      }
      
      public function isEqualTo(v:Vector2D) : Boolean
      {
         if(v is Vector2D)
         {
            if(this.xValue === v.xValue && this.yValue === v.yValue)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get x() : Number
      {
         return this.xValue;
      }
      
      public function set x(newX:Number) : void
      {
         this.xValue = this.fixNumber(newX);
      }
      
      public function get y() : Number
      {
         return this.yValue;
      }
      
      public function set y(newY:Number) : void
      {
         this.yValue = this.fixNumber(newY);
      }
      
      public function get angle() : Number
      {
         return this.fixNumber(Math.atan2(this.yValue,this.xValue) * (180 / Math.PI));
      }
      
      public function set angle(newAngle:Number) : void
      {
         var angleRadians:Number = 0;
         if(!isNaN(Number(newAngle)))
         {
            angleRadians = Number(newAngle) * (Math.PI / 180);
         }
         var currentMagnitude:Number = Math.sqrt(Math.pow(this.xValue,2) + Math.pow(this.yValue,2));
         this.xValue = this.fixNumber(currentMagnitude * Math.cos(angleRadians));
         this.yValue = this.fixNumber(currentMagnitude * Math.sin(angleRadians));
      }
      
      public function get magnitude() : Number
      {
         return this.fixNumber(Math.sqrt(this.xValue * this.xValue + this.yValue * this.yValue));
      }
      
      public function get magnitudeSquared() : Number
      {
         return this.fixNumber(this.xValue * this.xValue + this.yValue * this.yValue);
      }
      
      public function set magnitude(newMagnitude:Number) : void
      {
         if(isNaN(Number(newMagnitude)))
         {
            this.xValue = this.yValue = 0;
         }
         var currentMagnitude:Number = Math.sqrt(Math.pow(this.xValue,2) + Math.pow(this.yValue,2));
         if(0 < currentMagnitude)
         {
            this.times(Number(newMagnitude) / currentMagnitude);
         }
         else
         {
            this.yValue = 0;
            this.xValue = this.fixNumber(newMagnitude);
         }
      }
      
      public function paint(mc:Object, color:Number, scale:Number) : *
      {
         mc.graphics.lineStyle(0,color);
         mc.graphics.moveTo(0,0);
         mc.graphics.lineTo(this.xValue * scale,this.yValue * scale);
      }
      
      private function fixNumber(numberValue:Number) : Number
      {
         return !!isNaN(Number(numberValue)) ? Number(0) : Number(Math.round(Number(numberValue) * 10000) / 10000);
      }
      
      public function toString() : String
      {
         return "[" + this.xValue + "," + this.yValue + "]";
      }
   }
}
