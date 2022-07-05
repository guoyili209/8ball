package view
{
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import sound.SoundContain;
   
   public class StartTimePlay extends MovieClip
   {
      
      public static const START_PLAY:String = "start play";
       
      
      private var _numSp:Sprite;
      
      private var _tipTF:TextField;
      
      private var _leftTime:int;
      
      private var _numTF:TextField;
      
      private var _line:TimelineLite;
      
      public function StartTimePlay()
      {
         super();
         this.drawBack();
         this.setTip();
         this.creatTimeSp();
      }
      
      private function setTip() : void
      {
         this._tipTF = new TextField();
         var textFormat:TextFormat = new TextFormat();
         textFormat.size = 18;
         textFormat.font = "Arial";
         textFormat.color = 16777113;
         this._tipTF.defaultTextFormat = textFormat;
         this._tipTF.selectable = false;
         this._tipTF.x = (this.width - this._tipTF.width) / 2;
         this._tipTF.y = 10;
         this._tipTF.text = "Shot the balls as soon as posssible before the time is invalid!";
         this._tipTF.autoSize = "center";
         this._tipTF.filters = [new GlowFilter(0,1,5,5,1)];
         addChild(this._tipTF);
      }
      
      public function start() : void
      {
         this._leftTime = 1;
         this.setTime();
      }
      
      private function drawBack() : void
      {
         var grap:Graphics = this.graphics;
         grap.lineStyle(1,16777215,0.8);
         grap.beginFill(0,0.29);
         grap.drawRoundRect(0,0,500,100,10);
      }
      
      private function setTime() : void
      {
         if(this._leftTime > 0)
         {
            this._numTF.text = "Ready";
         }
         else
         {
            if(this._leftTime != 0)
            {
               TweenLite.to(this,0.2,{
                  "y":this.y - 30,
                  "x":x - 40,
                  "scaleX":1.2,
                  "scaleY":1.2,
                  "alpha":0,
                  "onComplete":this.removeHandler
               });
               return;
            }
            this._numTF.text = "Go!";
         }
         this._numTF.x = -this._numTF.width / 2;
         this._numSp.alpha = 1;
         this._numSp.scaleX = 1;
         this._numSp.scaleY = 1;
         this._numSp.x = 250;
         this._numSp.y = 40;
         --this._leftTime;
         if(this._line && this._line.active)
         {
            this._line.kill();
            this._line.clear();
         }
         this._line = new TimelineLite();
         this._line.append(TweenLite.from(this._numSp,0.5,{"onComplete":this.setTime}),0.3);
         this._line.insert(TweenLite.from(this._numSp,0.5,{
            "y":10,
            "scaleX":2,
            "scaleY":2,
            "alpha":0
         }));
         SoundContain.playSound(SoundContain.COUNT_DOWN);
      }
      
      private function creatTimeSp() : void
      {
         this._numSp = new Sprite();
         this._numTF = new TextField();
         this._numTF.autoSize = "center";
         var textFormat:TextFormat = new TextFormat();
         textFormat.font = "Arial";
         textFormat.size = 40;
         textFormat.color = 16777215;
         this._numTF.defaultTextFormat = textFormat;
         this._numTF.selectable = false;
         this._numSp.addChild(this._numTF);
         addChild(this._numSp);
         this._numSp.x = 250;
         this._numSp.y = 40;
      }
      
      public function pause(value:Boolean = true) : void
      {
         if(this._line)
         {
            if(value)
            {
               this._line.pause();
            }
            else
            {
               this._line.play();
            }
         }
      }
      
      public function kill() : void
      {
         this._line.kill();
      }
      
      private function removeHandler() : void
      {
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         dispatchEvent(new Event(START_PLAY));
         this.x += 40;
         this.y += 30;
         this.alpha = 1;
         this.scaleX = 1;
         this.scaleY = 1;
      }
   }
}
