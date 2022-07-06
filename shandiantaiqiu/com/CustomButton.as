package com
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   
   public dynamic class CustomButton extends MovieClip
   {
       
      
      public var bt:SimpleButton;
      
      public var hitzone:MovieClip;
      
      public var buttonText:MovieClip;
      
      public var w:Number;
      
      public var h:Number;
      
      public var w2:Number;
      
      public var h2:Number;
      
      public var wt:Number;
      
      public var ht:Number;
      
      public var w2t:Number;
      
      public var h2t:Number;
      
      public var txt:String;
      
      public var newText:String;
      
      public var n:uint;
      
      public var char:String;
      
      public function CustomButton()
      {
         super();
      }
      
      public function enlarge(param1:MouseEvent) : void
      {
         this.parent.setChildIndex(this,this.parent.numChildren - 1);
         this.filters = [new GlowFilter(16777215,0.25,25,25,2,2,false,false)];
         this.enlarging = true;
         this.reducing = false;
         this.addEventListener(Event.ENTER_FRAME,this.modifyButton);
      }
      
      public function reduce(param1:MouseEvent) : void
      {
         this.enlarging = false;
         this.reducing = true;
         this.addEventListener(Event.ENTER_FRAME,this.modifyButton);
         this.filters = [];
      }
      
      function modifyButton(param1:Event) : void
      {
         if(this.enlarging == true)
         {
            this.bt.width += Math.ceil(this.w2 - this.bt.width) / 10;
            this.bt.height += Math.ceil(this.h2 - this.bt.height) / 10;
            this.buttonText.width += Math.ceil(this.w2t - this.buttonText.width) / 10;
            this.buttonText.height += Math.ceil(this.h2t - this.buttonText.height) / 10;
            if(this.bt.width >= this.w2)
            {
               this.bt.width = this.w2;
               this.bt.height = this.h2;
               this.buttonText.width = this.w2t;
               this.buttonText.height = this.h2t;
               this.enlarging = false;
               this.removeEventListener(Event.ENTER_FRAME,this.modifyButton);
            }
         }
         if(this.reducing == true)
         {
            this.bt.width -= Math.ceil(this.bt.width - this.w) / 10;
            this.bt.height -= Math.ceil(this.bt.height - this.h) / 10;
            this.buttonText.width -= Math.ceil(this.buttonText.width - this.wt) / 10;
            this.buttonText.height -= Math.ceil(this.buttonText.height - this.ht) / 10;
            if(this.bt.width <= this.w)
            {
               this.bt.width = this.w;
               this.bt.height = this.h;
               this.buttonText.width = this.wt;
               this.buttonText.height = this.ht;
               this.reducing = false;
               this.removeEventListener(Event.ENTER_FRAME,this.modifyButton);
            }
         }
      }
   }
}
