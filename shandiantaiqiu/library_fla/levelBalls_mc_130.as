package library_fla
{
   import adobe.utils.*;
   import fl.motion.AnimatorFactory3D;
   import fl.motion.MotionBase;
   import fl.motion.motion_internal;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   public dynamic class levelBalls_mc_130 extends MovieClip
   {
       
      
      public var _00:MovieClip;
      
      public var _10:MovieClip;
      
      public var _01:MovieClip;
      
      public var _11:MovieClip;
      
      public var _02:MovieClip;
      
      public var _12:MovieClip;
      
      public var _03:MovieClip;
      
      public var _13:MovieClip;
      
      public var _04:MovieClip;
      
      public var _14:MovieClip;
      
      public var _05:MovieClip;
      
      public var _15:MovieClip;
      
      public var _06:MovieClip;
      
      public var _07:MovieClip;
      
      public var _08:MovieClip;
      
      public var _09:MovieClip;
      
      public var __animFactory__00af1:AnimatorFactory3D;
      
      public var __animArray__00af1:Array;
      
      public var ____motion__00af1_mat3DVec__:Vector.<Number>;
      
      public var ____motion__00af1_matArray__:Array;
      
      public var __motion__00af1:MotionBase;
      
      public function levelBalls_mc_130()
      {
         super();
         if(this.__animFactory__00af1 == null)
         {
            this.__animArray__00af1 = new Array();
            this.__motion__00af1 = new MotionBase();
            this.__motion__00af1.duration = 20;
            this.__motion__00af1.overrideTargetTransform();
            this.__motion__00af1.addPropertyArray("cacheAsBitmap",[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]);
            this.__motion__00af1.addPropertyArray("blendMode",["normal","normal","normal","normal","normal","normal","normal","normal","normal","normal","normal","normal","normal","normal","normal","normal","normal","normal","normal","normal"]);
            this.__motion__00af1.is3D = true;
            this.__motion__00af1.motion_internal::spanStart = 0;
            this.____motion__00af1_matArray__ = new Array();
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = -226.949997;
            this.____motion__00af1_mat3DVec__[13] = 241.899994;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = -164.949997;
            this.____motion__00af1_mat3DVec__[13] = -24.049999;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = -39;
            this.____motion__00af1_mat3DVec__[13] = -11.05;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = -137.949997;
            this.____motion__00af1_mat3DVec__[13] = 3.95;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = 141;
            this.____motion__00af1_mat3DVec__[13] = 21.950001;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = 47;
            this.____motion__00af1_mat3DVec__[13] = 89.949997;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = 40;
            this.____motion__00af1_mat3DVec__[13] = -19.049999;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = -230.949997;
            this.____motion__00af1_mat3DVec__[13] = 242.899994;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = -215.949997;
            this.____motion__00af1_mat3DVec__[13] = 242.899994;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = -16;
            this.____motion__00af1_mat3DVec__[13] = 3.95;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = -51;
            this.____motion__00af1_mat3DVec__[13] = 66.949997;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = 193;
            this.____motion__00af1_mat3DVec__[13] = -2.05;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = -107.949997;
            this.____motion__00af1_mat3DVec__[13] = -21.049999;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = 92;
            this.____motion__00af1_mat3DVec__[13] = 38.950001;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = 83;
            this.____motion__00af1_mat3DVec__[13] = -13.05;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = -226.949997;
            this.____motion__00af1_mat3DVec__[13] = 241.899994;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = 139;
            this.____motion__00af1_mat3DVec__[13] = 98.900002;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = -226.949997;
            this.____motion__00af1_mat3DVec__[13] = 241.899994;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = -150.949997;
            this.____motion__00af1_mat3DVec__[13] = 63.950001;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.____motion__00af1_mat3DVec__ = new Vector.<Number>(16);
            this.____motion__00af1_mat3DVec__[0] = 1;
            this.____motion__00af1_mat3DVec__[1] = 0;
            this.____motion__00af1_mat3DVec__[2] = 0;
            this.____motion__00af1_mat3DVec__[3] = 0;
            this.____motion__00af1_mat3DVec__[4] = 0;
            this.____motion__00af1_mat3DVec__[5] = 1;
            this.____motion__00af1_mat3DVec__[6] = 0;
            this.____motion__00af1_mat3DVec__[7] = 0;
            this.____motion__00af1_mat3DVec__[8] = 0;
            this.____motion__00af1_mat3DVec__[9] = 0;
            this.____motion__00af1_mat3DVec__[10] = 1;
            this.____motion__00af1_mat3DVec__[11] = 0;
            this.____motion__00af1_mat3DVec__[12] = -226.949997;
            this.____motion__00af1_mat3DVec__[13] = 241.899994;
            this.____motion__00af1_mat3DVec__[14] = 0;
            this.____motion__00af1_mat3DVec__[15] = 1;
            this.____motion__00af1_matArray__.push(new Matrix3D(this.____motion__00af1_mat3DVec__));
            this.__motion__00af1.addPropertyArray("matrix3D",this.____motion__00af1_matArray__);
            this.__animArray__00af1.push(this.__motion__00af1);
            this.__animFactory__00af1 = new AnimatorFactory3D(null,this.__animArray__00af1);
            this.__animFactory__00af1.sceneName = "levelBalls_mc";
            this.__animFactory__00af1.addTargetInfo(this,"_00",0,true,0,true,null,-1);
         }
      }
   }
}