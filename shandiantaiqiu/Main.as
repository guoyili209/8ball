package
{
   import com.Ball;
   import com.CustomEvent;
   import com.Dispatcher;
   import com.Maths;
   import com.ParticleExplosion;
   import com.Sound;
   import com.SuperGlobals;
   import com.Vector2D;
   import com.billiardPhysics;
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.core.SFSEvent;
   import com.smartfoxserver.v2.entities.User;
   import com.smartfoxserver.v2.entities.data.ISFSObject;
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import com.smartfoxserver.v2.requests.CreateRoomRequest;
   import com.smartfoxserver.v2.requests.JoinRoomRequest;
   import com.smartfoxserver.v2.requests.LoginRequest;
   import com.smartfoxserver.v2.requests.ObjectMessageRequest;
   import com.smartfoxserver.v2.requests.RoomSettings;
   import com.smartfoxserver.v2.requests.SubscribeRoomGroupRequest;
   import fl.events.ListEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.ui.Keyboard;
   import flash.utils.setTimeout;
   import mochi.as3.MochiScores;
   
   [Frame(factoryClass="Preloader")]
   public class Main extends Sprite
   {
       
      
      public function Main()
      {
         super();
         if(stage)
         {
            this.init();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.init);
         }
      }
      
      private function init(e:Event = null) : void
      {
         var gameMode:uint = 0;
         var stageWidth:* = undefined;
         var stageHeight:* = undefined;
         var numBalls:uint = 0;
         var shotNum:uint = 0;
         var power:Number = NaN;
         var aimSpeed:Number = NaN;
         var aimAcc:Number = NaN;
         var score:int = 0;
         var bonus:int = 0;
         var currentLevel:uint = 0;
         var shotsRemaining:int = 0;
         var ballsRemaining:int = 0;
         var timeRemaining:int = 0;
         var countdownCounter:int = 0;
         var currentTarget:int = 0;
         var nextTarget:int = 0;
         var cannonsRequired:int = 0;
         var banksRequired:int = 0;
         var kicksRequired:int = 0;
         var kissesRequired:int = 0;
         var combosRequired:int = 0;
         var aimDirectionVector:Vector2D = null;
         var online:Boolean = false;
         var shotRunning:Boolean = false;
         var myGame:Boolean = false;
         var myTurn:Boolean = false;
         var receivedCoinToss:Boolean = false;
         var verificationReceived:Boolean = false;
         var receivedVerificationValue:int = 0;
         var mouseIsDown:Boolean = false;
         var settingPower:Boolean = false;
         var upKeyDown:Boolean = false;
         var downKeyDown:Boolean = false;
         var leftKeyDown:Boolean = false;
         var rightKeyDown:Boolean = false;
         var upKey2Down:Boolean = false;
         var downKey2Down:Boolean = false;
         var leftKey2Down:Boolean = false;
         var rightKey2Down:Boolean = false;
         var spaceKeyDown:Boolean = false;
         var shiftKeyDown:Boolean = false;
         var rKeyDown:Boolean = false;
         var gameRunning:Boolean = false;
         var mouseOverStrike:Boolean = false;
         var tuningLeft:Boolean = false;
         var tuningRight:Boolean = false;
         var cueBallInHand:Boolean = false;
         var pocketTweenComplete:Boolean = false;
         var cueTweenComplete:Boolean = false;
         var preventAim:Boolean = false;
         var fouled:Boolean = false;
         var hintShown:Boolean = false;
         var gameRunningStopped:Boolean = false;
         var cueCanvasHidden:Boolean = false;
         var guideCanvasHidden:Boolean = false;
         var tuningHidden:Boolean = false;
         var setupPaused:Boolean = false;
         var preventQuit:Boolean = false;
         var shotsRemainingOn:Boolean = false;
         var timeRemainingOn:Boolean = false;
         var pauseCountdown:Boolean = false;
         var bonusBallOn:Boolean = false;
         var requiredBallOn:Boolean = false;
         var foulsProhibited:Boolean = false;
         var hintOn:Boolean = false;
         var cannonsRequiredOn:Boolean = false;
         var banksRequiredOn:Boolean = false;
         var kicksRequiredOn:Boolean = false;
         var kissesRequiredOn:Boolean = false;
         var combosRequiredOn:Boolean = false;
         var showNextTarget:Boolean = false;
         var countdownWasRunning:Boolean = false;
         var phys:billiardPhysics = null;
         var preSim:billiardPhysics = null;
         var preSim2:billiardPhysics = null;
         var frictionFast:Number = NaN;
         var frictionSlow:Number = NaN;
         var frictionSpeedThreshold:Number = NaN;
         var ballRadius:Number = NaN;
         var pocketRadius:Number = NaN;
         var physScale:Number = NaN;
         var minVelocity:Number = NaN;
         var cushionRestitution:Number = NaN;
         var ballRestitution:Number = NaN;
         var shadowRadius:Number = NaN;
         var credits:MovieClip = null;
         var splash:MovieClip = null;
         var projectCanvas:Sprite = null;
         var gameCanvas:Sprite = null;
         var ballCanvas:Sprite = null;
         var ballCanvasLower:Sprite = null;
         var ballShadowCanvas:Sprite = null;
         var tableCanvas:Sprite = null;
         var tableBG:MovieClip = null;
         var currentScreen:MovieClip = null;
         var connectionScreen:MovieClip = null;
         var lobby:MovieClip = null;
         var debug:MovieClip = null;
         var gui:MovieClip = null;
         var cueCanvas:Sprite = null;
         var cue:MovieClip = null;
         var powerMeter:MovieClip = null;
         var guideCanvas:Sprite = null;
         var guideCanvas2:Sprite = null;
         var background:MovieClip = null;
         var tablePockets:MovieClip = null;
         var tableCloth:MovieClip = null;
         var tableTop:MovieClip = null;
         var tuning:MovieClip = null;
         var mainMenu:MovieClip = null;
         var levelSelect:MovieClip = null;
         var levelComplete:MovieClip = null;
         var levelFailed:MovieClip = null;
         var marker:MovieClip = null;
         var marker2:MovieClip = null;
         var challenge:MovieClip = null;
         var challengeComplete:MovieClip = null;
         var soundToggle:MovieClip = null;
         var musicToggle:MovieClip = null;
         var musicChannel:SoundChannel = null;
         var musicTransform:SoundTransform = null;
         var musicVolume:Number = NaN;
         var musicOn:Boolean = false;
         var message:String = null;
         var ballArray:Array = null;
         var lineArray:Array = null;
         var vertexArray:Array = null;
         var pocketArray:Array = null;
         var ballArraySim:Array = null;
         var ballArraySim2:Array = null;
         var thisURL:String = null;
         var oldAim:Vector2D = null;
         var tracker:* = undefined;
         var initMenus2:Function = null;
         var gotoSponsor:Function = null;
         var gotoAndromedus:Function = null;
         var connectionScreenToPracticeGame:Function = null;
         var menuToCredits:Function = null;
         var creditsToMenu:Function = null;
         var mainMenuToLevelSelect:Function = null;
         var levelSelectToMenu:Function = null;
         var levelSelectToGame:Function = null;
         var challengeToGame:Function = null;
         var challengeToLevelSelect:Function = null;
         var showScores:Function = null;
         var showLobby:Function = null;
         var lobbyToMenu:Function = null;
         var lobbyToGameRoom:Function = null;
         var soundOver:Function = null;
         var soundUp:Function = null;
         var toggleSound:Function = null;
         var musicOver:Function = null;
         var musicUp:Function = null;
         var toggleMusic:Function = null;
         var sfs:SmartFox = null;
         var connectToServer:Function = null;
         var onConnection:Function = null;
         var onConnectionLost:Function = null;
         var onLogin:Function = null;
         var onLoginError:Function = null;
         var onGroupSubscribed:Function = null;
         var onGroupSubscribeError:Function = null;
         var createRoom:Function = null;
         var onRoomAdded:Function = null;
         var onRoomCreationError:Function = null;
         var onRoomJoin:Function = null;
         var onRoomJoinError:Function = null;
         var onOpponentEnterRoom:Function = null;
         var onUserExitRoom:Function = null;
         var receiveData:Function = null;
         var fadeMusicOut:Function = null;
         var fadeMusicIn:Function = null;
         var onCoinTossReceived:Function = null;
         var gotoWalkthrough:Function = null;
         var showHint:Function = null;
         var nextHint:Function = null;
         var hideHint:Function = null;
         var onMouseDown:Function = null;
         var onMouseUp:Function = null;
         var onKeyDown:Function = null;
         var onKeyUp:Function = null;
         var onContact:Function = null;
         var gameLoop:Function = null;
         var resetShotVars:Function = null;
         var prepareStrike:Function = null;
         var cancelPrepareStrike:Function = null;
         var fineTuneLeft:Function = null;
         var fineTuneRight:Function = null;
         var strikeMyBall:Function = null;
         var transferBonus:Function = null;
         var verifyYourPositions:Function = null;
         var reRack:Function = null;
         var quit:Function = null;
         var onSPKeyDown:Function = null;
         var levelCompleteToLevelSelect:Function = null;
         var levelCompleteToNextLevel:Function = null;
         var onRKeyDown:Function = null;
         var levelFailedToLevelSelect:Function = null;
         var levelFailedToSameLevel:Function = null;
         var challengeCompleteToLevelSelect:Function = null;
         var challengeCompleteToSameLevel:Function = null;
         var submitScore:Function = null;
         var initMenus:Function = function():void
         {
            tracker = SuperGlobals.tracker;
            projectCanvas = new Sprite();
            stage.addChild(projectCanvas);
            debug = new debug_mc();
            stage.addChild(debug);
            debug.mouseEnabled = false;
            debug.mouseChildren = false;
            debug.visible = false;
            stage.frameRate = 70;
            splash = new splash_mc();
            stage.addChild(splash);
            splash.hotspot.addEventListener(MouseEvent.CLICK,gotoSponsor);
            stage.addEventListener("LAST_FRAME",initMenus2);
         };
         initMenus2 = function(e:*):*
         {
            stage.removeChild(splash);
            splash = null;
            stage.frameRate = 30;
            showMainMenu();
            Sound.on = true;
            soundToggle = new soundToggle_mc();
            soundToggle.stop();
            stage.addChild(soundToggle);
            musicToggle = new musicToggle_mc();
            musicToggle.stop();
            stage.addChild(musicToggle);
            initialiseSoundToggle();
            initialiseMusicToggle();
            var musicSound:* = new music();
            musicChannel = musicSound.play(0,100);
            soundToggle.x = 22;
            soundToggle.y = 563;
            musicToggle.x = 58;
            musicToggle.y = 557;
         };
         var showMainMenu:Function = function():void
         {
            mainMenu = new mainMenu_mc();
            projectCanvas.addChild(mainMenu);
            var securityOn:Boolean = false;
            var urlAllowed:* = false;
            var currentURL:String = stage.loaderInfo.url;
            var allowedURLs:* = new Array();
            allowedURLs.push("andromedus.com");
            allowedURLs.push("Richard/Documents/");
            allowedURLs.push("flashgamelicense.com");
            if(currentURL.indexOf(allowedURLs[0],0) != -1 || currentURL.indexOf(allowedURLs[1],0) != -1 || currentURL.indexOf(allowedURLs[2],0) != -1)
            {
               urlAllowed = true;
            }
            if(securityOn == false || urlAllowed == true)
            {
               mainMenu._PLAY_.addEventListener(MouseEvent.CLICK,mainMenuToLevelSelect);
            }
            mainMenu._MORE_GAMES_.addEventListener(MouseEvent.CLICK,gotoSponsor);
            mainMenu._CREDITS_.addEventListener(MouseEvent.CLICK,menuToCredits);
            mainMenu.sponsorLogo.addEventListener(MouseEvent.CLICK,gotoSponsor);
         };
         var removeMainMenu:Function = function():void
         {
            mainMenu._PLAY_.removeEventListener(MouseEvent.CLICK,mainMenuToLevelSelect);
            mainMenu._MORE_GAMES_.removeEventListener(MouseEvent.CLICK,gotoSponsor);
            mainMenu._CREDITS_.removeEventListener(MouseEvent.CLICK,menuToCredits);
            mainMenu.sponsorLogo.removeEventListener(MouseEvent.CLICK,gotoSponsor);
            projectCanvas.removeChild(mainMenu);
            mainMenu = null;
         };
         var gotoHostGame:Function = function(e:MouseEvent):void
         {
            tracker.trackEvent("Events","clicked host game");
            var url:URLRequest = new URLRequest("http://zayplay.com/page/games-for-your-website.html?utm_source=" + thisURL + "&utm_medium=flashgame&utm_campaign=Billard-Blitz-Pool-Skool");
            navigateToURL(url,"_blank");
         };
         gotoSponsor = function(e:MouseEvent):void
         {
            tracker.trackEvent("Events","clicked sponsor link");
            var url:URLRequest = new URLRequest("http://zayplay.com?utm_source=" + thisURL + "&utm_medium=flashgame&utm_campaign=Billard-Blitz-Pool-Skool");
            navigateToURL(url,"_blank");
         };
         gotoAndromedus = function(e:MouseEvent):void
         {
            tracker.trackEvent("Events","clicked dev page");
            var url:URLRequest = new URLRequest("http://andromedus.com");
            navigateToURL(url,"_blank");
         };
         var showConnectionScreen:Function = function():void
         {
            connectionScreen = new connectionScreen_mc();
            projectCanvas.addChild(connectionScreen);
            connectionScreen._PLAY_ONLINE_.addEventListener(MouseEvent.CLICK,connectToServer);
            connectionScreen._PRACTICE_.addEventListener(MouseEvent.CLICK,connectionScreenToPracticeGame);
         };
         var removeConnectionScreen:Function = function():void
         {
            connectionScreen._PLAY_ONLINE_.removeEventListener(MouseEvent.CLICK,connectToServer);
            connectionScreen._PRACTICE_.removeEventListener(MouseEvent.CLICK,connectionScreenToPracticeGame);
            projectCanvas.removeChild(connectionScreen);
            connectionScreen = null;
         };
         connectionScreenToPracticeGame = function(e:MouseEvent):void
         {
            online = false;
            removeConnectionScreen();
            initGame();
         };
         menuToCredits = function(e:MouseEvent):void
         {
            var swap:Function = null;
            swap = function():void
            {
               removeMainMenu();
               showCredits();
            };
            fade();
            setTimeout(swap,500);
         };
         creditsToMenu = function(e:MouseEvent):void
         {
            var swap:Function = null;
            swap = function():void
            {
               removeCredits();
               showMainMenu();
            };
            fade();
            setTimeout(swap,500);
         };
         var showCredits:Function = function():void
         {
            tracker.trackEvent("Events","clicked credits");
            credits = new credits_mc();
            projectCanvas.addChild(credits);
            credits.logo.addEventListener(MouseEvent.CLICK,gotoAndromedus);
            credits._BACK_.addEventListener(MouseEvent.CLICK,creditsToMenu);
         };
         var removeCredits:Function = function():void
         {
            credits.logo.removeEventListener(MouseEvent.CLICK,gotoAndromedus);
            credits._BACK_.removeEventListener(MouseEvent.CLICK,creditsToMenu);
            projectCanvas.removeChild(credits);
            credits = null;
         };
         mainMenuToLevelSelect = function(e:MouseEvent):void
         {
            var swap:Function = null;
            swap = function():void
            {
               removeMainMenu();
               showLevelSelect();
            };
            online = false;
            fade();
            setTimeout(swap,500);
         };
         var showLevelSelect:Function = function():void
         {
            levelSelect = new levelSelect_mc();
            projectCanvas.addChild(levelSelect);
            levelSelect.levelHolder.labels.mouseEnabled = false;
            levelSelect.levelHolder.labels.mouseChildren = false;
            levelSelect._BACK_.addEventListener(MouseEvent.CLICK,levelSelectToMenu);
            levelSelect._MORE_GAMES_.addEventListener(MouseEvent.CLICK,gotoSponsor);
            levelSelect.levelHolder.addEventListener(MouseEvent.CLICK,levelSelectToGame);
         };
         var removeLevelSelect:Function = function():void
         {
            levelSelect._BACK_.removeEventListener(MouseEvent.CLICK,levelSelectToMenu);
            levelSelect.levelHolder.removeEventListener(MouseEvent.CLICK,levelSelectToGame);
            levelSelect._MORE_GAMES_.removeEventListener(MouseEvent.CLICK,gotoSponsor);
            projectCanvas.removeChild(levelSelect);
            levelSelect = null;
         };
         levelSelectToMenu = function(e:MouseEvent):*
         {
            var swap:Function = null;
            swap = function():void
            {
               removeLevelSelect();
               showMainMenu();
            };
            fade();
            setTimeout(swap,500);
         };
         levelSelectToGame = function(e:MouseEvent):void
         {
            var swap:Function = null;
            swap = function():void
            {
               removeLevelSelect();
               currentLevel = int(e.target.name.slice(1,3));
               hintShown = false;
               if(currentLevel < 21)
               {
                  initGame();
               }
               else
               {
                  showChallenge();
               }
            };
            fade();
            setTimeout(swap,500);
         };
         var showChallenge:Function = function():void
         {
            challenge = new challenge_mc();
            projectCanvas.addChild(challenge);
            challenge._START_.addEventListener(MouseEvent.CLICK,challengeToGame);
            challenge._BACK_.addEventListener(MouseEvent.CLICK,challengeToLevelSelect);
            challenge._SCORES_.addEventListener(MouseEvent.CLICK,showScores);
         };
         var removeChallenge:Function = function():void
         {
            challenge._START_.removeEventListener(MouseEvent.CLICK,challengeToGame);
            challenge._BACK_.removeEventListener(MouseEvent.CLICK,challengeToLevelSelect);
            challenge._SCORES_.removeEventListener(MouseEvent.CLICK,showScores);
            projectCanvas.removeChild(challenge);
            challenge = null;
         };
         challengeToGame = function(e:MouseEvent):void
         {
            var swap:Function = null;
            swap = function():void
            {
               removeChallenge();
               initGame();
            };
            fade();
            setTimeout(swap,500);
         };
         challengeToLevelSelect = function(e:MouseEvent):void
         {
            var swap:Function = null;
            swap = function():void
            {
               removeChallenge();
               showLevelSelect();
            };
            fade();
            setTimeout(swap,500);
         };
         showScores = function(e:MouseEvent):*
         {
            var o:Object = {
               "n":[14,14,4,13,7,3,12,15,14,5,1,14,4,0,15,9],
               "f":function(i:Number, s:String):String
               {
                  if(s.length == 16)
                  {
                     return s;
                  }
                  return this.f(i + 1,s + this.n[i].toString(16));
               }
            };
            var boardID:String = o.f(0,"");
            MochiScores.showLeaderboard({"boardID":boardID});
         };
         showLobby = function():void
         {
            removeConnectionScreen();
            lobby = new lobby_mc();
            projectCanvas.addChild(lobby);
            updateLobby();
            lobby._CREATE_GAME_.addEventListener(MouseEvent.CLICK,createRoom);
            lobby._BACK_.addEventListener(MouseEvent.CLICK,lobbyToMenu);
            lobby.roomList.addEventListener(ListEvent.ITEM_CLICK,lobbyToGameRoom);
         };
         var removeLobby:Function = function():void
         {
            lobby._CREATE_GAME_.removeEventListener(MouseEvent.CLICK,createRoom);
            lobby._BACK_.removeEventListener(MouseEvent.CLICK,lobbyToMenu);
            projectCanvas.removeChild(lobby);
         };
         lobbyToMenu = function(e:MouseEvent):void
         {
            removeLobby();
            showMainMenu();
         };
         lobbyToGameRoom = function(e:ListEvent):void
         {
            joinGameRoom(e.item.data);
            removeLobby();
            if(myGame == true)
            {
               sfs.addEventListener(SFSEvent.USER_ENTER_ROOM,onOpponentEnterRoom);
            }
            else
            {
               initGame();
            }
         };
         var autoJoinGameRoom:Function = function():void
         {
            removeLobby();
            sfs.addEventListener(SFSEvent.USER_ENTER_ROOM,onOpponentEnterRoom);
         };
         var fade:Function = function():void
         {
            var blackScreen:* = undefined;
            var fadeOut:Function = null;
            var remove:Function = null;
            fadeOut = function():void
            {
               TweenLite.to(blackScreen,0.5,{
                  "alpha":1,
                  "onComplete":remove
               });
            };
            remove = function():void
            {
               stage.removeChild(blackScreen);
               blackScreen = null;
            };
            blackScreen = new blackScreen_mc();
            stage.addChild(blackScreen);
            TweenLite.from(blackScreen,0.5,{
               "alpha":0,
               "onComplete":fadeOut
            });
         };
         var initialiseSoundToggle:Function = function():void
         {
            soundToggle.addEventListener(MouseEvent.MOUSE_OVER,soundOver);
            soundToggle.addEventListener(MouseEvent.MOUSE_OUT,soundUp);
            soundToggle.addEventListener(MouseEvent.MOUSE_DOWN,toggleSound);
         };
         soundOver = function(e:MouseEvent):void
         {
            if(Sound.on == true)
            {
               soundToggle.gotoAndStop("onOver");
            }
            else
            {
               soundToggle.gotoAndStop("offOver");
            }
         };
         soundUp = function(e:MouseEvent):void
         {
            if(Sound.on == true)
            {
               soundToggle.gotoAndStop("onUp");
            }
            else
            {
               soundToggle.gotoAndStop("offUp");
            }
         };
         toggleSound = function(e:MouseEvent):void
         {
            if(Sound.on == true)
            {
               Sound.on = false;
               soundToggle.gotoAndStop("offOver");
            }
            else
            {
               Sound.on = true;
               soundToggle.gotoAndStop("onOver");
            }
         };
         var initialiseMusicToggle:Function = function():void
         {
            musicToggle.addEventListener(MouseEvent.MOUSE_OVER,musicOver);
            musicToggle.addEventListener(MouseEvent.MOUSE_OUT,musicUp);
            musicToggle.addEventListener(MouseEvent.MOUSE_DOWN,toggleMusic);
         };
         musicOver = function(e:MouseEvent):void
         {
            if(musicOn == true)
            {
               musicToggle.gotoAndStop("onOver");
            }
            else
            {
               musicToggle.gotoAndStop("offOver");
            }
         };
         musicUp = function(e:MouseEvent):void
         {
            if(musicOn == true)
            {
               musicToggle.gotoAndStop("onUp");
            }
            else
            {
               musicToggle.gotoAndStop("offUp");
            }
         };
         toggleMusic = function(e:MouseEvent):void
         {
            if(musicOn == true)
            {
               musicOn = false;
               musicToggle.gotoAndStop("offOver");
               musicTransform.volume = 0;
               musicChannel.soundTransform = musicTransform;
            }
            else
            {
               musicOn = true;
               musicToggle.gotoAndStop("onOver");
               musicTransform.volume = musicVolume;
               musicChannel.soundTransform = musicTransform;
            }
         };
         connectToServer = function(e:MouseEvent):void
         {
            online = true;
            sfs = new SmartFox();
            sfs.debug = false;
            sfs.addEventListener(SFSEvent.CONNECTION,onConnection);
            sfs.addEventListener(SFSEvent.CONNECTION_LOST,onConnectionLost);
            sfs.addEventListener(SFSEvent.LOGIN,onLogin);
            sfs.addEventListener(SFSEvent.LOGIN_ERROR,onLoginError);
            sfs.addEventListener(SFSEvent.ROOM_JOIN,onRoomJoin);
            sfs.addEventListener(SFSEvent.ROOM_JOIN_ERROR,onRoomJoinError);
            sfs.addEventListener(SFSEvent.ROOM_ADD,onRoomAdded);
            sfs.addEventListener(SFSEvent.ROOM_CREATION_ERROR,onRoomCreationError);
            sfs.addEventListener(SFSEvent.ROOM_GROUP_SUBSCRIBE,onGroupSubscribed);
            sfs.addEventListener(SFSEvent.ROOM_GROUP_SUBSCRIBE_ERROR,onGroupSubscribeError);
            sfs.addEventListener(SFSEvent.USER_EXIT_ROOM,onUserExitRoom);
            connectionScreen.outputText.appendText("SmartFox API: " + sfs.version + "\n");
            sfs.connect("107.21.119.77",9933);
         };
         onConnection = function(evt:SFSEvent):void
         {
            if(evt.params.success)
            {
               connectionScreen.outputText.appendText("Connection Success!" + "\n");
               sfs.send(new LoginRequest("","","billiards"));
            }
            else
            {
               connectionScreen.outputText.appendText("Connection Failure: " + evt.params.errorMessage + "\n");
            }
         };
         onConnectionLost = function(evt:SFSEvent):void
         {
            connectionScreen.outputText.appendText("Connection was lost. Reason: " + evt.params.reason + "\n");
         };
         onLogin = function(evt:SFSEvent):void
         {
            connectionScreen.outputText.appendText("Login success: " + evt.params.user.name + "\n");
            connectionScreen.outputText.appendText("Zone: " + sfs.currentZone + "\n");
            sfs.send(new SubscribeRoomGroupRequest("9ball"));
         };
         onLoginError = function(evt:SFSEvent):void
         {
            connectionScreen.outputText.appendText("Login failed: " + evt.params.errorMessage + "\n");
         };
         onGroupSubscribed = function(evt:SFSEvent):void
         {
            trace("Group subscribed. The following rooms are now accessible: " + evt.params.newRooms);
            sfs.send(new JoinRoomRequest("lobby"));
         };
         onGroupSubscribeError = function(evt:SFSEvent):void
         {
            trace("Group subscription failed: " + evt.params.errorMessage);
         };
         createRoom = function(e:MouseEvent):void
         {
            var settings:RoomSettings = new RoomSettings("new_room");
            settings.maxUsers = 2;
            settings.groupId = "9ball";
            sfs.send(new CreateRoomRequest(settings,true));
            trace("Attempting create room");
            myGame = true;
         };
         onRoomAdded = function(evt:SFSEvent):void
         {
            trace("A new Room was added: " + evt.params.room);
            updateLobby();
         };
         onRoomCreationError = function(evt:SFSEvent):void
         {
            trace("An error occurred while attempting to create the Room: " + evt.params.errorMessage);
            myGame = false;
         };
         onRoomJoin = function(evt:SFSEvent):void
         {
            if(evt.params.room.name == "lobby")
            {
               connectionScreen.outputText.appendText("Joined room: " + evt.params.room + "\n");
               setTimeout(showLobby,1000);
            }
            else
            {
               trace("Joined room: " + evt.params.room);
               if(myGame == true)
               {
                  autoJoinGameRoom();
               }
            }
         };
         onRoomJoinError = function(evt:SFSEvent):void
         {
            trace("Join room error: " + evt.params.errorMessage);
         };
         var updateLobby:Function = function():void
         {
            var n:uint = 0;
            lobby.roomList.removeAll();
            for(var currentRoomList:Array = sfs.getRoomListFromGroup("9ball"); n < currentRoomList.length; )
            {
               lobby.roomList.addItem({
                  "label":currentRoomList[n].name,
                  "data":currentRoomList[n].id
               });
               n++;
            }
         };
         var joinGameRoom:Function = function(roomId:*):void
         {
            sfs.send(new JoinRoomRequest(roomId));
         };
         onOpponentEnterRoom = function(evt:SFSEvent):void
         {
            var user:User = evt.params.user;
            debug.textField.appendText(user.name + " entered the room\n");
            initGame();
         };
         onUserExitRoom = function(evt:SFSEvent):void
         {
            var user:User = evt.params.user;
            if(!user.isItMe)
            {
               debug.textField.appendText(user.name + " exited the room\n");
            }
         };
         var sendShot:Function = function():void
         {
            var dataObj:ISFSObject = new SFSObject();
            dataObj.putInt("ax",Maths.fixNumber(ballArray[0].velocity.x * 10000));
            dataObj.putInt("ay",Maths.fixNumber(ballArray[0].velocity.y * 10000));
            dataObj.putInt("as",Maths.fixNumber(ballArray[0].screw * 10000));
            dataObj.putInt("ae",Maths.fixNumber(ballArray[0].english * 10000));
            sfs.send(new ObjectMessageRequest(dataObj));
            debug.textField.appendText("sent: " + String(ballArray[0].velocity.x) + ", " + String(ballArray[0].velocity.y) + "\n");
         };
         var sendCueBallPlacement:Function = function():void
         {
            var dataObj:ISFSObject = new SFSObject();
            dataObj.putInt("px",Maths.fixNumber(ballArray[0].position.x * 10000));
            dataObj.putInt("py",Maths.fixNumber(ballArray[0].position.y * 10000));
            sfs.send(new ObjectMessageRequest(dataObj));
            debug.textField.appendText("sent cb pos: " + String(ballArray[0].position.x) + ", " + String(ballArray[0].position.y) + "\n");
         };
         var sendVerification:Function = function(positions:int):void
         {
            var dataObj:ISFSObject = new SFSObject();
            dataObj.putInt("ve",positions);
            sfs.send(new ObjectMessageRequest(dataObj));
            debug.textField.appendText("sent verification: " + String(positions) + "\n");
         };
         var sendCoinToss:Function = function():void
         {
            var dataObj:ISFSObject = new SFSObject();
            var coinTossResult:uint = 0;
            if(myTurn == true)
            {
               coinTossResult = 1;
            }
            dataObj.putInt("c",coinTossResult);
            sfs.send(new ObjectMessageRequest(dataObj));
            debug.textField.appendText("coin toss sent: my turn = " + String(myTurn) + "\n");
         };
         receiveData = function(evt:SFSEvent):void
         {
            var cueBallPositionX:Number = NaN;
            var cueBallPositionY:Number = NaN;
            var cueBallVelocityX:Number = NaN;
            var cueBallVelocityY:Number = NaN;
            var cueBallScrew:Number = NaN;
            var cueBallEnglish:Number = NaN;
            var dataObj:ISFSObject = evt.params.message as SFSObject;
            if(dataObj.containsKey("px") && dataObj.containsKey("py"))
            {
               cueBallPositionX = Maths.fixNumber(dataObj.getInt("px") / 10000);
               cueBallPositionY = Maths.fixNumber(dataObj.getInt("py") / 10000);
               placeYourCueBall(cueBallPositionX,cueBallPositionY);
               debug.textField.appendText("cb pos received: " + String(cueBallPositionX) + ", " + String(cueBallPositionY) + "\n");
            }
            if(dataObj.containsKey("ax") && dataObj.containsKey("ay") && dataObj.containsKey("as") && dataObj.containsKey("ae"))
            {
               cueBallVelocityX = Maths.fixNumber(dataObj.getInt("ax") / 10000);
               cueBallVelocityY = Maths.fixNumber(dataObj.getInt("ay") / 10000);
               cueBallScrew = Maths.fixNumber(dataObj.getInt("as") / 10000);
               cueBallEnglish = Maths.fixNumber(dataObj.getInt("ae") / 10000);
               debug.textField.appendText("shot received: " + String(cueBallVelocityX) + ", " + String(cueBallVelocityY) + "\n");
               strikeYourBall(cueBallVelocityX,cueBallVelocityY,cueBallScrew,cueBallEnglish);
            }
            if(dataObj.containsKey("ve"))
            {
               debug.textField.appendText("verification received: " + String(dataObj.getInt("ve")) + "\n");
               verificationReceived = true;
               receivedVerificationValue = dataObj.getInt("ve");
            }
            if(dataObj.containsKey("c"))
            {
               if(dataObj.getInt("c") == 0)
               {
                  myTurn = true;
               }
               receivedCoinToss = true;
               debug.textField.appendText("coin toss received: my turn = " + String(myTurn) + "\n");
            }
         };
         var initGame:Function = function():void
         {
            tracker.trackEvent("Events","played level " + String(currentLevel));
            resetGameVars();
            soundToggle.x = 48;
            soundToggle.y = 538;
            musicToggle.x = 83;
            musicToggle.y = 535;
            gameCanvas = new Sprite();
            projectCanvas.addChild(gameCanvas);
            gameCanvas.x = stageWidth / 2 - 30;
            gameCanvas.y = stageHeight / 2;
            setLevelData();
            setupCanvases();
            setupTable();
            setupBalls();
            initPhysics();
            addCue();
            countdownWasRunning = false;
            addGUI();
            updateGUI();
            if(gui.hint.visible == false || gameMode != 0)
            {
               setupPaused = false;
               initGame2();
            }
            else
            {
               setupPaused = true;
            }
         };
         var initGame2:Function = function():void
         {
            if(currentLevel == 1)
            {
               gui.strikeHint.visible = true;
               TweenLite.from(gui.strikeHint,2,{
                  "alpha":0,
                  "delay":5
               });
               gui.strikeHint.x = ballArray[0].position.x * physScale + 380;
               gui.strikeHint.y = ballArray[0].position.y * physScale + 310;
            }
            if(currentLevel == 2)
            {
               gui.adjustHint.visible = true;
               TweenLite.from(gui.adjustHint,2,{
                  "alpha":0,
                  "delay":5
               });
               gui.adjustHint.x = ballArray[0].position.x * physScale + 360;
               gui.adjustHint.y = ballArray[0].position.y * physScale + 320;
            }
            initMouseListener();
            initKeyboardListener();
            resetShotVars();
            Dispatcher.GetInstance().addEventListener(CustomEvent.EVENT,onContact);
            if(message != "")
            {
               showMessage();
            }
            if(online == true)
            {
               sfs.addEventListener(SFSEvent.OBJECT_MESSAGE,receiveData);
               coinToss();
            }
            else
            {
               myTurn = true;
               playGame();
            }
            musicVolume = 1;
            stage.addEventListener(Event.ENTER_FRAME,fadeMusicOut);
         };
         fadeMusicOut = function(e:Event):*
         {
            musicVolume -= 0.0025;
            if(musicVolume <= 0)
            {
               musicVolume = 0;
               stage.removeEventListener(Event.ENTER_FRAME,fadeMusicOut);
            }
            if(musicOn == true)
            {
               musicTransform.volume = musicVolume;
               musicChannel.soundTransform = musicTransform;
            }
         };
         fadeMusicIn = function(e:Event):*
         {
            musicVolume += 0.01;
            if(musicVolume >= 1)
            {
               musicVolume = 1;
               stage.removeEventListener(Event.ENTER_FRAME,fadeMusicIn);
            }
            if(musicOn == true)
            {
               musicTransform.volume = musicVolume;
               musicChannel.soundTransform = musicTransform;
            }
         };
         var coinToss:Function = function():void
         {
            if(myGame == true)
            {
               if(Math.random() < 0.5)
               {
                  myTurn = true;
                  gui.myTurn.gotoAndStop(1);
               }
               else
               {
                  gui.myTurn.gotoAndStop(2);
               }
               sendCoinToss();
               playGame();
            }
            else
            {
               debug.textField.appendText("waiting for coin toss result ...\n");
               addEventListener(Event.ENTER_FRAME,onCoinTossReceived);
            }
         };
         onCoinTossReceived = function(e:Event):void
         {
            if(receivedCoinToss == true)
            {
               removeEventListener(Event.ENTER_FRAME,onCoinTossReceived);
               if(myTurn == true)
               {
                  gui.myTurn.gotoAndStop(1);
               }
               else
               {
                  gui.myTurn.gotoAndStop(2);
               }
               playGame();
            }
         };
         var initPhysics:Function = function():void
         {
            var _loc2_:Object = null;
            phys = new billiardPhysics(ballArray,lineArray,vertexArray,pocketArray,0);
            phys.frictionFast = frictionFast;
            phys.frictionSlow = frictionSlow;
            phys.frictionSpeedThreshold = frictionSpeedThreshold;
            phys.ballRadius = ballRadius;
            phys.pocketRadius = pocketRadius;
            phys.physScale = physScale;
            phys.minVelocity = minVelocity;
            phys.cushionRestitution = cushionRestitution;
            phys.ballRestitution = ballRestitution;
            ballArraySim = new Array();
            for(var _loc1_:uint = 0; _loc1_ < ballArray.length; _loc1_++)
            {
               _loc2_ = new Object();
               _loc2_.radius = ballRadius;
               _loc2_.id = _loc1_;
               _loc2_.type = "sim";
               ballArraySim.push(_loc2_);
            }
            ballArraySim2 = new Array();
            for(_loc1_ = 0; _loc1_ < ballArray.length; _loc1_++)
            {
               _loc2_ = new Object();
               _loc2_.radius = ballRadius;
               _loc2_.id = _loc1_;
               _loc2_.type = "sim2";
               ballArraySim2.push(_loc2_);
            }
            resetBallArraySim2();
            preSim2 = new billiardPhysics(ballArraySim2,lineArray,vertexArray,pocketArray,2);
            preSim2.frictionFast = frictionFast;
            preSim2.frictionSlow = frictionSlow;
            preSim2.frictionSpeedThreshold = frictionSpeedThreshold;
            preSim2.ballRadius = ballRadius;
            preSim2.pocketRadius = pocketRadius;
            preSim2.physScale = physScale;
            preSim2.minVelocity = minVelocity;
            preSim2.cushionRestitution = cushionRestitution;
            preSim2.ballRestitution = ballRestitution;
         };
         var resetBallArraySim:Function = function():void
         {
            var ball:Object = null;
            for(var n:uint = 0; n < ballArray.length; n++)
            {
               ball = ballArraySim[n];
               ball.position = ballArray[n].position;
               ball.velocity = new Vector2D(0,0);
               ball.lastCollisionObject = null;
               ball.active = ballArray[n].active;
               ball.firstContact = false;
               ball.contactArray = new Array();
               if(n == 0)
               {
                  ball.screw = 0;
                  ball.english = 0;
                  ball.ySpin = 0;
                  ball.deltaScrew = new Vector2D(0,0);
               }
            }
         };
         var resetBallArraySim2:Function = function():void
         {
            var ball:Object = null;
            for(var n:uint = 0; n < ballArray.length; n++)
            {
               ball = ballArraySim2[n];
               ball.position = ballArray[n].position;
               ball.velocity = new Vector2D(0,0);
               ball.lastCollisionObject = null;
               ball.active = ballArray[n].active;
               ball.firstContact = false;
               ball.contactArray = new Array();
               ball.ySpin = 0;
               if(n == 0)
               {
                  ball.screw = 0;
                  ball.english = 0;
                  ball.deltaScrew = new Vector2D(0,0);
               }
            }
         };
         var setupCanvases:Function = function():void
         {
            tablePockets = new table1Pockets_mc();
            gameCanvas.addChild(tablePockets);
            tablePockets.cacheAsBitmap = true;
            ballCanvasLower = new Sprite();
            gameCanvas.addChild(ballCanvasLower);
            tableCloth = new tableCloth_mc();
            gameCanvas.addChild(tableCloth);
            tableCloth.cacheAsBitmap = true;
            ballShadowCanvas = new Sprite();
            gameCanvas.addChild(ballShadowCanvas);
            tableTop = new tableTop_mc();
            gameCanvas.addChild(tableTop);
            tableTop.cacheAsBitmap = true;
            addTuning();
            ballCanvas = new Sprite();
            gameCanvas.addChild(ballCanvas);
            ballCanvas.mouseEnabled = false;
            ballCanvas.mouseChildren = false;
            guideCanvas = new Sprite();
            gameCanvas.addChild(guideCanvas);
            guideCanvas.mouseEnabled = false;
            guideCanvas.mouseChildren = false;
            if(requiredBallOn == true || bonusBallOn == true)
            {
               trace("here");
               marker = new marker_mc();
               gameCanvas.addChild(marker);
               marker.width = 10 * ballRadius * physScale;
               marker.height = 10 * ballRadius * physScale;
               if(showNextTarget == true)
               {
                  marker2 = new marker_mc();
                  gameCanvas.addChild(marker2);
                  marker2.width = 10 * ballRadius * physScale;
                  marker2.height = 10 * ballRadius * physScale;
               }
            }
         };
         var addTuning:Function = function():void
         {
            tuning = new tuning_mc();
            gameCanvas.addChild(tuning);
            tuning.visible = false;
         };
         var setupBalls:Function = function():void
         {
            var _loc2_:uint = 0;
            var _loc3_:Object = null;
            var _loc4_:int = 0;
            var _loc5_:Ball = null;
            var _loc6_:* = undefined;
            var _loc1_:Array = setBallPositions();
            numBalls = _loc1_.length;
            for(_loc2_ = 0; _loc2_ < numBalls; _loc2_++)
            {
               _loc3_ = new Object();
               _loc3_.radius = ballRadius;
               _loc3_.position = new Vector2D(_loc1_[_loc2_].x,_loc1_[_loc2_].y);
               _loc3_.velocity = new Vector2D(0,0);
               _loc3_.lastCollisionObject = null;
               _loc3_.id = _loc2_;
               if(_loc2_ != 0)
               {
                  if(_loc3_.position.y >= 16000)
                  {
                     _loc3_.active = false;
                  }
                  else
                  {
                     _loc3_.active = true;
                  }
               }
               else
               {
                  _loc3_.active = true;
               }
               _loc3_.firstContact = false;
               _loc3_.contactArray = new Array();
               _loc3_.type = "real";
               if(_loc2_ == 0)
               {
                  _loc3_.screw = 0;
                  _loc3_.english = 0;
                  _loc3_.deltaScrew = new Vector2D(0,0);
               }
               _loc3_.grip = 1;
               _loc3_.ySpin = 0;
               switch(_loc2_)
               {
                  case 0:
                     _loc4_ = 16777215;
                     break;
                  case 1:
                     _loc4_ = 16776960;
                     break;
                  case 2:
                     _loc4_ = 187;
                     break;
                  case 3:
                     _loc4_ = 16711680;
                     break;
                  case 4:
                     _loc4_ = 12255419;
                     break;
                  case 5:
                     _loc4_ = 16737792;
                     break;
                  case 6:
                     _loc4_ = 47872;
                     break;
                  case 7:
                     _loc4_ = 11149824;
                     break;
                  case 8:
                     _loc4_ = 0;
                     break;
                  case 9:
                     _loc4_ = 16776960;
                     break;
                  case 10:
                     _loc4_ = 187;
                     break;
                  case 11:
                     _loc4_ = 16711680;
                     break;
                  case 12:
                     _loc4_ = 12255419;
                     break;
                  case 13:
                     _loc4_ = 16737792;
                     break;
                  case 14:
                     _loc4_ = 47872;
                     break;
                  case 15:
                     _loc4_ = 11149824;
                     break;
               }
               _loc5_ = new Ball(_loc3_.radius * physScale,_loc4_,_loc2_);
               _loc3_.mc = _loc5_;
               if(_loc3_.active == true)
               {
                  ballCanvas.addChild(_loc3_.mc);
                  _loc3_.mc.x = _loc3_.position.x * physScale;
                  _loc3_.mc.y = _loc3_.position.y * physScale;
                  _loc3_.shadow1 = new shadow_mc();
                  ballShadowCanvas.addChild(_loc3_.shadow1);
                  _loc3_.shadow1.x = _loc3_.mc.x;
                  _loc3_.shadow1.y = _loc3_.mc.y;
                  _loc3_.shadow1.width = _loc3_.radius * physScale;
                  _loc3_.shadow1.height = _loc3_.radius * physScale;
                  _loc3_.shadow1.alpha = 0.4;
               }
               _loc3_.lowerCanvas = ballCanvasLower;
               ballArray.push(_loc3_);
            }
            for(_loc2_ = 0; _loc2_ < numBalls; _loc2_++)
            {
               _loc6_ = ballArray[_loc2_];
               if(_loc6_.id != 0 && _loc6_.active == true)
               {
                  ++ballsRemaining;
               }
            }
            renderScreen();
         };
         var setupTable:Function = function():void
         {
            var _loc2_:Object = null;
            var _loc3_:Object = null;
            var _loc4_:Object = null;
            var _loc8_:Vector2D = null;
            var _loc1_:uint = 600;
            _loc4_ = new Object();
            _loc4_.position = new Vector2D(-50 * _loc1_ - pocketRadius / 2,-25 * _loc1_ - pocketRadius / 4);
            _loc4_.dropPosition = new Vector2D(-51 * _loc1_ - pocketRadius / 2,-26 * _loc1_ - pocketRadius / 4);
            pocketArray.push(_loc4_);
            _loc4_ = new Object();
            _loc4_.position = new Vector2D(0 * _loc1_,-25 * _loc1_ - pocketRadius);
            _loc4_.dropPosition = new Vector2D(0 * _loc1_,-25.5 * _loc1_ - pocketRadius);
            pocketArray.push(_loc4_);
            _loc4_ = new Object();
            _loc4_.position = new Vector2D(50 * _loc1_ + pocketRadius / 2,-25 * _loc1_ - pocketRadius / 4);
            _loc4_.dropPosition = new Vector2D(51 * _loc1_ + pocketRadius / 2,-26 * _loc1_ - pocketRadius / 4);
            pocketArray.push(_loc4_);
            _loc4_ = new Object();
            _loc4_.position = new Vector2D(-50 * _loc1_ - pocketRadius / 2,25 * _loc1_ + pocketRadius / 4);
            _loc4_.dropPosition = new Vector2D(-51 * _loc1_ - pocketRadius / 2,26 * _loc1_ + pocketRadius / 4);
            pocketArray.push(_loc4_);
            _loc4_ = new Object();
            _loc4_.position = new Vector2D(0 * _loc1_,25 * _loc1_ + pocketRadius);
            _loc4_.dropPosition = new Vector2D(0 * _loc1_,25.5 * _loc1_ + pocketRadius);
            pocketArray.push(_loc4_);
            _loc4_ = new Object();
            _loc4_.position = new Vector2D(50 * _loc1_ + pocketRadius / 2,25 * _loc1_ + pocketRadius / 4);
            _loc4_.dropPosition = new Vector2D(51 * _loc1_ + pocketRadius / 2,26 * _loc1_ + pocketRadius / 4);
            pocketArray.push(_loc4_);
            var _loc5_:Number = 4;
            var _loc6_:Number = 2;
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D(-50 * _loc1_,-(25 + _loc5_) * _loc1_);
            _loc2_.p2 = new Vector2D(-(50 - _loc5_) * _loc1_,-25 * _loc1_);
            lineArray.push(_loc2_);
            _loc3_ = new Object();
            _loc3_.position = new Vector2D(_loc2_.p2.x,_loc2_.p2.y);
            vertexArray.push(_loc3_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D(-(50 - _loc5_) * _loc1_,-25 * _loc1_);
            _loc2_.p2 = new Vector2D(-_loc5_ * _loc1_,-25 * _loc1_);
            lineArray.push(_loc2_);
            _loc3_ = new Object();
            _loc3_.position = new Vector2D(_loc2_.p2.x,_loc2_.p2.y);
            vertexArray.push(_loc3_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D(-_loc5_ * _loc1_,-25 * _loc1_);
            _loc2_.p2 = new Vector2D(-_loc6_ * _loc1_,-(25 + _loc5_) * _loc1_);
            lineArray.push(_loc2_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D(_loc6_ * _loc1_,-(25 + _loc5_) * _loc1_);
            _loc2_.p2 = new Vector2D(_loc5_ * _loc1_,-25 * _loc1_);
            lineArray.push(_loc2_);
            _loc3_ = new Object();
            _loc3_.position = new Vector2D(_loc2_.p2.x,_loc2_.p2.y);
            vertexArray.push(_loc3_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D(_loc5_ * _loc1_,-25 * _loc1_);
            _loc2_.p2 = new Vector2D((50 - _loc5_) * _loc1_,-25 * _loc1_);
            lineArray.push(_loc2_);
            _loc3_ = new Object();
            _loc3_.position = new Vector2D(_loc2_.p2.x,_loc2_.p2.y);
            vertexArray.push(_loc3_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D((50 - _loc5_) * _loc1_,-25 * _loc1_);
            _loc2_.p2 = new Vector2D(50 * _loc1_,-(25 + _loc5_) * _loc1_);
            lineArray.push(_loc2_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D((50 + _loc5_) * _loc1_,-25 * _loc1_);
            _loc2_.p2 = new Vector2D(50 * _loc1_,-(25 - _loc5_) * _loc1_);
            lineArray.push(_loc2_);
            _loc3_ = new Object();
            _loc3_.position = new Vector2D(_loc2_.p2.x,_loc2_.p2.y);
            vertexArray.push(_loc3_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D(50 * _loc1_,-(25 - _loc5_) * _loc1_);
            _loc2_.p2 = new Vector2D(50 * _loc1_,(25 - _loc5_) * _loc1_);
            lineArray.push(_loc2_);
            _loc3_ = new Object();
            _loc3_.position = new Vector2D(_loc2_.p2.x,_loc2_.p2.y);
            vertexArray.push(_loc3_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D(50 * _loc1_,(25 - _loc5_) * _loc1_);
            _loc2_.p2 = new Vector2D((50 + _loc5_) * _loc1_,25 * _loc1_);
            lineArray.push(_loc2_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D(50 * _loc1_,(25 + _loc5_) * _loc1_);
            _loc2_.p2 = new Vector2D((50 - _loc5_) * _loc1_,25 * _loc1_);
            lineArray.push(_loc2_);
            _loc3_ = new Object();
            _loc3_.position = new Vector2D(_loc2_.p2.x,_loc2_.p2.y);
            vertexArray.push(_loc3_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D((50 - _loc5_) * _loc1_,25 * _loc1_);
            _loc2_.p2 = new Vector2D(_loc5_ * _loc1_,25 * _loc1_);
            lineArray.push(_loc2_);
            _loc3_ = new Object();
            _loc3_.position = new Vector2D(_loc2_.p2.x,_loc2_.p2.y);
            vertexArray.push(_loc3_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D(_loc5_ * _loc1_,25 * _loc1_);
            _loc2_.p2 = new Vector2D(_loc6_ * _loc1_,(25 + _loc5_) * _loc1_);
            lineArray.push(_loc2_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D(-_loc6_ * _loc1_,(25 + _loc5_) * _loc1_);
            _loc2_.p2 = new Vector2D(-_loc5_ * _loc1_,25 * _loc1_);
            lineArray.push(_loc2_);
            _loc3_ = new Object();
            _loc3_.position = new Vector2D(_loc2_.p2.x,_loc2_.p2.y);
            vertexArray.push(_loc3_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D(-_loc5_ * _loc1_,25 * _loc1_);
            _loc2_.p2 = new Vector2D(-(50 - _loc5_) * _loc1_,25 * _loc1_);
            lineArray.push(_loc2_);
            _loc3_ = new Object();
            _loc3_.position = new Vector2D(_loc2_.p2.x,_loc2_.p2.y);
            vertexArray.push(_loc3_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D(-(50 - _loc5_) * _loc1_,25 * _loc1_);
            _loc2_.p2 = new Vector2D(-50 * _loc1_,(25 + _loc5_) * _loc1_);
            lineArray.push(_loc2_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D(-(50 + _loc5_) * _loc1_,25 * _loc1_);
            _loc2_.p2 = new Vector2D(-50 * _loc1_,(25 - _loc5_) * _loc1_);
            lineArray.push(_loc2_);
            _loc3_ = new Object();
            _loc3_.position = new Vector2D(_loc2_.p2.x,_loc2_.p2.y);
            vertexArray.push(_loc3_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D(-50 * _loc1_,(25 - _loc5_) * _loc1_);
            _loc2_.p2 = new Vector2D(-50 * _loc1_,-(25 - _loc5_) * _loc1_);
            lineArray.push(_loc2_);
            _loc3_ = new Object();
            _loc3_.position = new Vector2D(_loc2_.p2.x,_loc2_.p2.y);
            vertexArray.push(_loc3_);
            _loc2_ = new Object();
            _loc2_.p1 = new Vector2D(-50 * _loc1_,-(25 - _loc5_) * _loc1_);
            _loc2_.p2 = new Vector2D(-(50 + _loc5_) * _loc1_,-25 * _loc1_);
            lineArray.push(_loc2_);
            for(var _loc7_:uint = 0; _loc7_ < lineArray.length; _loc7_++)
            {
               _loc2_ = lineArray[_loc7_];
               _loc2_.direction = new Vector2D(_loc2_.p2.x - _loc2_.p1.x,_loc2_.p2.y - _loc2_.p1.y).normalize();
               _loc2_.normal = _loc2_.direction.getLeftNormal();
               _loc8_ = _loc2_.normal.times(ballRadius);
               _loc2_.p3 = _loc2_.p1.plus(_loc8_);
               _loc2_.p4 = _loc2_.p2.plus(_loc8_);
            }
         };
         var addCue:Function = function():void
         {
            cueCanvas = new Sprite();
            cueCanvas.name = "cueCanvas";
            projectCanvas.addChild(cueCanvas);
            cueCanvas.x = stageWidth / 2 - 30;
            cueCanvas.y = stageHeight / 2;
            cue = new cue_mc();
            cue.shadow = new cueShadow_mc();
            cue.shadow.alpha = 0.6;
            cueCanvas.addChild(cue.shadow);
            cueCanvas.addChild(cue);
            powerMeter = new powerMeter_mc();
            cueCanvas.addChild(powerMeter);
            powerMeter.visible = false;
            cueCanvas.x = ballArray[0].position.x * physScale;
            cueCanvas.y = ballArray[0].position.y * physScale;
            cue.x = -ballRadius * 2 * physScale;
            cue.shadow.x = cue.x;
            cueCanvas.mouseEnabled = false;
            cueCanvas.mouseChildren = false;
            cueCanvas.visible = false;
         };
         var addGUI:Function = function():void
         {
            gui = new gui_mc();
            projectCanvas.addChildAt(gui,projectCanvas.getChildIndex(projectCanvas.getChildByName("cueCanvas")));
            gui.strikeHint.visible = false;
            gui.adjustHint.visible = false;
            gui._QUIT_.addEventListener(MouseEvent.CLICK,quit);
            gui._RESTART_.addEventListener(MouseEvent.CLICK,reRack);
            gui._HINT_.addEventListener(MouseEvent.CLICK,showHint);
            gui._WALKTHROUGH_.addEventListener(MouseEvent.CLICK,gotoWalkthrough);
            gui.sponsorLogo.addEventListener(MouseEvent.CLICK,gotoSponsor);
            gui.message.text = "";
            gui.hint.visible = false;
            if(gameMode == 0)
            {
               if(hintOn == true && hintShown == false)
               {
                  showHint();
                  gui.hint.next.visible = false;
               }
            }
            gui.power.mask.height *= 0.4;
            if(shotsRemainingOn == true)
            {
               gui.topLeftLabel.text = "shots \nremaining";
               gui.topLeftValue.text = String(shotsRemaining);
            }
            if(timeRemainingOn == true)
            {
               gui.topLeftLabel.text = "time \nremaining";
               gui.topLeftValue.text = String(timeRemaining);
            }
            if(timeRemainingOn == false && shotsRemainingOn == false)
            {
               gui.topLeftLabel.text = "";
               gui.topLeftValue.text = "";
            }
         };
         gotoWalkthrough = function(e:MouseEvent):void
         {
            tracker.trackEvent("Events","clicked walkthrough");
            var url:URLRequest = new URLRequest("http://zayplay.com/page/billiard-blitz-pool-skool-walkthrough.html?utm_source=" + thisURL + "&utm_medium=flashgame&utm_campaign=Billard-Blitz-Pool-Skool");
            navigateToURL(url,"_blank");
         };
         showHint = function(e:MouseEvent = null):void
         {
            if(preventQuit == false)
            {
               if(pauseCountdown == false)
               {
                  countdownWasRunning = true;
                  pauseCountdown = true;
               }
               hintShown = true;
               if(hintOn == true)
               {
                  gui.hint.content.gotoAndStop(currentLevel);
               }
               else
               {
                  gui.hint.content.gotoAndStop(1);
               }
               gui.hint.visible = true;
               gui.hint.next.visible = true;
               gui.hint.close.addEventListener(MouseEvent.CLICK,hideHint);
               gui.hint.next.addEventListener(MouseEvent.CLICK,nextHint);
               if(gameRunning == true)
               {
                  gameRunning = false;
                  gameRunningStopped = true;
               }
               if(cueCanvas.visible == true)
               {
                  cueCanvas.visible = false;
                  cueCanvasHidden = true;
               }
               if(tuning.visible == true)
               {
                  tuning.visible = false;
                  tuningHidden = true;
               }
               if(guideCanvas.visible == true)
               {
                  guideCanvas.visible = false;
                  guideCanvasHidden = true;
               }
               ballCanvas.visible = false;
               ballShadowCanvas.visible = false;
            }
         };
         nextHint = function(e:MouseEvent):void
         {
            if(gui.hint.content.currentFrame < gui.hint.content.totalFrames)
            {
               gui.hint.content.nextFrame();
            }
            else
            {
               gui.hint.content.gotoAndStop(1);
            }
         };
         hideHint = function(e:MouseEvent):void
         {
            if(countdownWasRunning == true)
            {
               pauseCountdown = false;
            }
            gui.hint.visible = false;
            gui.hint.close.removeEventListener(MouseEvent.CLICK,hideHint);
            gui.hint.next.removeEventListener(MouseEvent.CLICK,nextHint);
            if(gameRunningStopped == true)
            {
               gameRunning = true;
               gameRunningStopped = false;
            }
            if(cueCanvasHidden == true)
            {
               cueCanvas.visible = true;
               cueCanvasHidden = false;
            }
            if(tuningHidden == true)
            {
               tuning.visible = true;
               tuningHidden = false;
            }
            if(guideCanvasHidden == true)
            {
               guideCanvas.visible = true;
               guideCanvasHidden = false;
            }
            ballCanvas.visible = true;
            ballShadowCanvas.visible = true;
            if(setupPaused == true)
            {
               setupPaused = false;
               initGame2();
            }
         };
         var resetGameVars:Function = function():void
         {
            score = 0;
            bonus = 0;
            myTurn = false;
            shotNum = 0;
            aimDirectionVector = new Vector2D(0,0);
            gameRunningStopped = false;
            cueCanvasHidden = false;
            guideCanvasHidden = false;
            tuningHidden = false;
            preventQuit = false;
            countdownCounter = 0;
            pauseCountdown = true;
            ballsRemaining = 0;
         };
         var initMouseListener:Function = function():void
         {
            stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
            stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
         };
         var disableMouseListener:Function = function():void
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
            stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
         };
         onMouseDown = function(e:MouseEvent):void
         {
            mouseIsDown = true;
         };
         onMouseUp = function(e:MouseEvent):void
         {
            mouseIsDown = false;
            storedMouseY = false;
            preventAim = false;
            aimSpeed = 0.01;
         };
         var initKeyboardListener:Function = function():void
         {
            stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         };
         var disableKeyboardListener:Function = function():void
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
            stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         };
         onKeyDown = function(e:KeyboardEvent):void
         {
            if(e.keyCode == Keyboard.LEFT)
            {
               leftKeyDown = true;
            }
            if(e.keyCode == Keyboard.RIGHT)
            {
               rightKeyDown = true;
            }
            if(e.keyCode == Keyboard.UP)
            {
               upKeyDown = true;
            }
            if(e.keyCode == Keyboard.DOWN)
            {
               downKeyDown = true;
            }
            if(e.keyCode == Keyboard.SHIFT)
            {
               shiftKeyDown = true;
            }
            if(e.keyCode == 65)
            {
               leftKey2Down = true;
            }
            if(e.keyCode == 68)
            {
               rightKey2Down = true;
            }
            if(e.keyCode == 87)
            {
               upKey2Down = true;
            }
            if(e.keyCode == 83)
            {
               downKey2Down = true;
            }
            if(e.keyCode == Keyboard.SPACE)
            {
               spaceKeyDown = true;
            }
            if(e.keyCode == 114 || e.keyCode == 82)
            {
               rKeyDown = true;
            }
            if(e.keyCode == 82)
            {
               reRack(null);
            }
         };
         onKeyUp = function(e:KeyboardEvent):void
         {
            if(e.keyCode == Keyboard.LEFT)
            {
               leftKeyDown = false;
               aimSpeed = 0.01;
            }
            if(e.keyCode == Keyboard.RIGHT)
            {
               rightKeyDown = false;
               aimSpeed = 0.01;
            }
            if(e.keyCode == Keyboard.UP)
            {
               upKeyDown = false;
            }
            if(e.keyCode == Keyboard.DOWN)
            {
               downKeyDown = false;
            }
            if(e.keyCode == Keyboard.SHIFT)
            {
               shiftKeyDown = false;
            }
            if(e.keyCode == 65)
            {
               leftKey2Down = false;
            }
            if(e.keyCode == 68)
            {
               rightKey2Down = false;
            }
            if(e.keyCode == 87)
            {
               upKey2Down = false;
            }
            if(e.keyCode == 83)
            {
               downKey2Down = false;
            }
            if(e.keyCode == Keyboard.SPACE)
            {
               spaceKeyDown = false;
            }
            if(e.keyCode == 114 || e.keyCode == 82)
            {
               rKeyDown = false;
            }
         };
         onContact = function(param1:CustomEvent):void
         {
            var _loc5_:* = undefined;
            var _loc6_:Number = NaN;
            var _loc2_:* = param1.data;
            var _loc3_:Object = _loc2_.ball;
            var _loc4_:Object = new Object();
            _loc4_.position = _loc3_.position;
            _loc4_.targetPosition = _loc2_.target.position;
            _loc4_.velocity = _loc2_.ballVelocity;
            _loc4_.collisionType = _loc2_.collisionType;
            _loc4_.screw = _loc3_.screw;
            if(_loc2_.collisionType == "ball")
            {
               _loc4_.target = _loc2_.target;
               _loc4_.targetVelocity = _loc2_.targetVelocity;
               _loc4_.deltaScrew = _loc2_.deltaScrew;
            }
            if(_loc3_.type == "real")
            {
               if(_loc2_.collisionType == "ball")
               {
                  _loc3_.contactArray.push(_loc4_);
                  _loc5_ = _loc4_.velocity.minus(_loc4_.targetVelocity).magnitude;
                  _loc6_ = _loc5_ / 6000;
                  if(_loc6_ > 1)
                  {
                     _loc6_ = 1;
                  }
                  Sound.Play("ball",_loc6_);
               }
               if(_loc2_.collisionType == "line" || _loc2_.collisionType == "vertex")
               {
                  _loc3_.contactArray.push(_loc4_);
                  _loc5_ = _loc2_.normalVelocity.magnitude;
                  _loc6_ = _loc5_ / 3000;
                  if(_loc6_ > 2)
                  {
                     _loc6_ = 2;
                  }
                  Sound.Play("cushion",_loc6_);
               }
               if(_loc2_.collisionType == "pocket")
               {
                  playPocketSound(_loc2_);
                  playPocketAnimation(_loc2_);
                  if(gameMode == 0)
                  {
                     awardBonuses(_loc2_);
                  }
                  if(_loc3_.id == 0)
                  {
                     cueBallInHand = true;
                  }
                  else
                  {
                     --ballsRemaining;
                  }
                  if(bonusBallOn == true || requiredBallOn == true)
                  {
                     findNextTargets();
                  }
               }
            }
            if(_loc2_.collisionType == "ball" && _loc3_.firstContact == false)
            {
               _loc3_.firstContact = true;
               if(_loc3_.type == "sim" || _loc3_.type == "sim2")
               {
                  _loc3_.contactArray.push(_loc4_);
               }
            }
            if(_loc2_.collisionType == "line" && _loc3_.firstContact == false)
            {
               if(_loc3_.type == "sim" || _loc3_.type == "sim2")
               {
                  _loc3_.contactArray.push(_loc4_);
               }
            }
            if(_loc2_.collisionType == "vertex" && _loc3_.firstContact == false)
            {
               if(_loc3_.type == "sim" || _loc3_.type == "sim2")
               {
                  _loc3_.contactArray.push(_loc4_);
               }
            }
            if(_loc2_.collisionType == "pocket" && _loc3_.firstContact == false)
            {
               if(_loc3_.type == "sim" || _loc3_.type == "sim2")
               {
                  _loc3_.firstContact = true;
                  _loc3_.contactArray.push(_loc4_);
               }
            }
         };
         var playPocketSound:Function = function(collisionData:*):void
         {
            var closingSpeed:* = collisionData.speed;
            var volume:Number = closingSpeed / 5000;
            if(volume > 1.5)
            {
               volume = 1.5;
            }
            if(volume < 0.3)
            {
               volume = 0.3;
            }
            Sound.Play("pocket",volume);
         };
         var awardBonuses:Function = function(collisionData:*):void
         {
            var pocket:* = undefined;
            var bonusDisplay:* = undefined;
            var removeBonus:Function = null;
            var n:uint = 0;
            var cannon:* = undefined;
            var collisionObject:* = undefined;
            var cushionContact:* = undefined;
            var distSq:* = undefined;
            removeBonus = function():void
            {
               projectCanvas.removeChild(bonusDisplay);
            };
            var delay:uint = 0;
            var ball:* = collisionData.ball;
            pocket = collisionData.target;
            var closingSpeed:* = collisionData.speed;
            var effect:* = new ParticleExplosion("star_mc",15,0.5,0,0.01,0,1);
            gameCanvas.addChild(effect);
            effect.x = pocket.position.x * physScale;
            effect.y = pocket.position.y * physScale;
            effect.Start();
            bonusDisplay = new bonusDisplay_mc();
            projectCanvas.addChild(bonusDisplay);
            if(ball.id == 0)
            {
               bonusDisplay.textField.text = "Scratch";
               fouled = true;
            }
            if(requiredBallOn == true && fouled == false)
            {
               if(ball.id != currentTarget)
               {
                  bonusDisplay.textField.text = "Wrong Ball";
                  fouled = true;
               }
            }
            var clean:Boolean = true;
            var firstBall:Object = null;
            var lastBall:Object = null;
            var kiss:Boolean = false;
            var combo:Boolean = false;
            if(ball.id != 0)
            {
               trace("num contacts: " + ball.contactArray.length);
               for(n = 0; n < ball.contactArray.length; n++)
               {
                  collisionObject = ball.contactArray[n];
                  if(collisionObject.collisionType == "ball")
                  {
                     if(!firstBall)
                     {
                        firstBall = collisionObject.target;
                     }
                     lastBall = collisionObject.target;
                     trace("last ball: " + lastBall);
                  }
               }
               if(lastBall.id != 0)
               {
                  clean = false;
                  if(firstBall.id == 0)
                  {
                     kiss = true;
                  }
                  if(firstBall.id != 0)
                  {
                     combo = true;
                  }
               }
               cannon = false;
               if(clean == true)
               {
                  firstBall = null;
                  for(n = 0; n < ballArray[0].contactArray.length; n++)
                  {
                     collisionObject = ballArray[0].contactArray[n];
                     if(collisionObject.collisionType == "ball")
                     {
                        if(!firstBall)
                        {
                           firstBall = collisionObject.target;
                        }
                     }
                  }
                  if(firstBall != ball)
                  {
                     cannon = true;
                  }
               }
            }
            if(kiss == true && fouled == false)
            {
               bonusDisplay.textField.text = "Kiss Shot \n200";
               bonus += 200;
               if(kissesRequired > 0)
               {
                  --kissesRequired;
               }
            }
            if(combo == true && fouled == false)
            {
               bonusDisplay.textField.text = "Combo Shot \n300";
               bonus += 300;
               if(combosRequired > 0)
               {
                  --combosRequired;
               }
            }
            if(cannon == true && fouled == false)
            {
               bonusDisplay.textField.text = "Carom Shot \n400";
               bonus += 400;
               if(cannonsRequired > 0)
               {
                  --cannonsRequired;
               }
            }
            if(fouled == false && clean == true && cannon == false)
            {
               bonusDisplay.textField.text = "Pot \n100";
               bonus += 100;
            }
            bonusDisplay.x = pocket.position.x * physScale + stageWidth / 2 - 30;
            bonusDisplay.y = pocket.position.y * physScale - 20 + stageHeight / 2;
            TweenLite.to(bonusDisplay,4,{
               "alpha":0,
               "y":pocket.position.y * physScale - 60 + stageHeight / 2,
               "onComplete":removeBonus
            });
            var kick:* = false;
            if(fouled == false)
            {
               cushionContact = false;
               for(n = 0; n < ballArray[0].contactArray.length; n++)
               {
                  collisionObject = ballArray[0].contactArray[n];
                  if(collisionObject.collisionType == "line" || collisionObject.collisionType == "vertex")
                  {
                     cushionContact = true;
                  }
                  if(collisionObject.collisionType == "ball" && collisionObject.target == ball)
                  {
                     if(cushionContact == true)
                     {
                        kick = true;
                     }
                  }
               }
            }
            if(kick == true)
            {
               var showBonus2:Function = function():void
               {
                  var bonusDisplay2:* = undefined;
                  var removeBonus2:Function = null;
                  removeBonus2 = function():void
                  {
                     projectCanvas.removeChild(bonusDisplay2);
                  };
                  bonusDisplay2 = new bonusDisplay_mc();
                  projectCanvas.addChild(bonusDisplay2);
                  bonusDisplay2.textField.text = "Kick Shot \n100";
                  if(kicksRequired > 0)
                  {
                     --kicksRequired;
                  }
                  bonusDisplay2.x = pocket.position.x * physScale + stageWidth / 2 - 30;
                  bonusDisplay2.y = pocket.position.y * physScale - 20 + stageHeight / 2;
                  TweenLite.to(bonusDisplay2,4,{
                     "alpha":0,
                     "y":pocket.position.y * physScale - 60 + stageHeight / 2,
                     "onComplete":removeBonus2
                  });
               };
               delay += 1000;
               setTimeout(showBonus2,delay);
               bonus += 100;
            }
            var bank:* = false;
            if(fouled == false)
            {
               for(n = 0; n < ball.contactArray.length; n++)
               {
                  collisionObject = ball.contactArray[n];
                  if(collisionObject.collisionType == "line" || collisionObject.collisionType == "vertex")
                  {
                     distSq = (collisionObject.position.x - pocket.position.x) * (collisionObject.position.x - pocket.position.x) + (collisionObject.position.y - pocket.position.y) * (collisionObject.position.y - pocket.position.y);
                     if(distSq >= 25000 * 25000)
                     {
                        bank = true;
                     }
                  }
               }
            }
            if(bank == true)
            {
               var showBonus3:Function = function():void
               {
                  var bonusDisplay3:* = undefined;
                  var removeBonus3:Function = null;
                  removeBonus3 = function():void
                  {
                     projectCanvas.removeChild(bonusDisplay3);
                  };
                  bonusDisplay3 = new bonusDisplay_mc();
                  projectCanvas.addChild(bonusDisplay3);
                  bonusDisplay3.textField.text = "Bank Shot \n100";
                  if(banksRequired > 0)
                  {
                     --banksRequired;
                  }
                  bonusDisplay3.x = pocket.position.x * physScale + stageWidth / 2 - 30;
                  bonusDisplay3.y = pocket.position.y * physScale - 20 + stageHeight / 2;
                  TweenLite.to(bonusDisplay3,4,{
                     "alpha":0,
                     "y":pocket.position.y * physScale - 60 + stageHeight / 2,
                     "onComplete":removeBonus3
                  });
               };
               delay += 1000;
               setTimeout(showBonus3,delay);
               bonus += 100;
            }
            if(requiredBallOn == true || bonusBallOn == true)
            {
               if(ball.id == currentTarget)
               {
                  var showBonus4:Function = function():void
                  {
                     var bonusDisplay4:* = undefined;
                     var removeBonus4:Function = null;
                     removeBonus4 = function():void
                     {
                        projectCanvas.removeChild(bonusDisplay4);
                     };
                     bonusDisplay4 = new bonusDisplay_mc();
                     projectCanvas.addChild(bonusDisplay4);
                     bonusDisplay4.textField.text = "Bonus Ball \n500";
                     bonusDisplay4.x = pocket.position.x * physScale + stageWidth / 2 - 30;
                     bonusDisplay4.y = pocket.position.y * physScale - 20 + stageHeight / 2;
                     TweenLite.to(bonusDisplay4,4,{
                        "alpha":0,
                        "y":pocket.position.y * physScale - 60 + stageHeight / 2,
                        "onComplete":removeBonus4
                     });
                  };
                  bonus += 500;
                  delay += 1000;
                  setTimeout(showBonus4,delay);
               }
            }
            updateGUI();
         };
         var playPocketAnimation:Function = function(collisionData:*):void
         {
            var ball:* = undefined;
            var swapCanvas:Function = null;
            var removeMC:Function = null;
            swapCanvas = function():void
            {
               var _x:Number = ball.mc.x;
               var _y:Number = ball.mc.y;
               var canvas:* = ball.lowerCanvas;
               ball.mc.parent.removeChild(ball.mc);
               canvas.addChild(ball.mc);
               ball.mc.x = _x;
               ball.mc.y = _y;
               ball.mc.scaleX = 0.9;
               ball.mc.scaleY = 0.9;
            };
            removeMC = function(ball:*):void
            {
               if(ball.id != 0)
               {
                  ball.mc.parent.removeChild(ball.mc);
               }
               else
               {
                  var showCueBall:Function = function():void
                  {
                     ball.mc.parent.removeChild(ball.mc);
                     ballCanvas.addChild(ball.mc);
                     ball.mc.scaleX = 1;
                     ball.mc.scaleY = 1;
                     pocketTweenComplete = true;
                  };
                  ball.mc.visible = false;
                  setTimeout(showCueBall,1000);
               }
            };
            ball = collisionData.ball;
            var pocket:* = collisionData.target;
            var closingSpeed:* = collisionData.speed;
            if(ball.id != 0)
            {
               ball.shadow1.parent.removeChild(ball.shadow1);
               ball.shadow1 = null;
            }
            else
            {
               ball.shadow1.visible = false;
               pocketTweenComplete = false;
            }
            var tweenSpeed:* = 0.1;
            if(closingSpeed < 5000)
            {
               tweenSpeed = 0.2;
            }
            if(closingSpeed < 3000)
            {
               tweenSpeed = 0.3;
            }
            if(closingSpeed < 2000)
            {
               tweenSpeed = 0.4;
            }
            if(closingSpeed < 1000)
            {
               tweenSpeed = 0.5;
            }
            ball.mc.scaleX = 0.9;
            ball.mc.scaleY = 0.9;
            TweenLite.to(ball.mc,tweenSpeed,{
               "x":pocket.dropPosition.x * physScale,
               "y":pocket.dropPosition.y * physScale,
               "onComplete":swapCanvas
            });
            TweenLite.to(ball.mc,tweenSpeed * 1.2,{
               "delay":tweenSpeed,
               "x":0.8 * pocket.position.x * physScale,
               "y":0.8 * pocket.position.y * physScale,
               "ease":Quad.easeIn,
               "onComplete":removeMC,
               "onCompleteParams":[ball]
            });
         };
         var renderScreen:Function = function():void
         {
            var ball:Object = null;
            var distSq:Number = NaN;
            var shadowWidth:Number = NaN;
            for(var n:uint = 0; n < ballArray.length; n++)
            {
               ball = ballArray[n];
               if(ball.active == true)
               {
                  ball.mc.x = ball.position.x * physScale;
                  ball.mc.y = ball.position.y * physScale;
                  distSq = ball.mc.x * ball.mc.x + ball.mc.y * ball.mc.y;
                  shadowWidth = shadowRadius + 0.6 * shadowRadius * distSq / 90000;
                  ball.shadow1.rotation = 0;
                  ball.shadow1.width = shadowRadius;
                  ball.shadow1.height = shadowRadius;
                  ball.shadow1.width = shadowWidth;
                  ball.shadow1.rotation = 180 / Math.PI * Math.atan2(ball.mc.y,ball.mc.x);
                  ball.shadow1.x = ball.mc.x + 0.7 * ball.radius * physScale * (ball.mc.x / 300);
                  ball.shadow1.y = ball.mc.y + 0.7 * ball.radius * physScale * (ball.mc.y / 150);
                  ball.mc.updateRotation(ball.velocity.x * physScale * ball.grip,ball.velocity.y * physScale * ball.grip,ball.ySpin);
               }
            }
         };
         var playGame:Function = function():void
         {
            resetShotVars();
            gameRunning = true;
            stage.addEventListener(Event.ENTER_FRAME,gameLoop);
         };
         gameLoop = function(e:Event):void
         {
            if(gameRunning == true)
            {
               if(myTurn == true)
               {
                  placeMyCueBall();
                  setSpin();
                  aim();
                  setPower();
                  fineTuneUpdate();
                  strikeWithKeyboard();
                  updateCountdown();
                  checkMyShotOver();
               }
               else
               {
                  checkYourShotOver();
               }
               if(shotRunning == true)
               {
                  phys.updatePhysics();
                  renderScreen();
               }
            }
         };
         var switchTurns:Function = function():void
         {
            if(myTurn == true)
            {
               myTurn = false;
               gui.myTurn.gotoAndStop(2);
            }
            else
            {
               myTurn = true;
               gui.myTurn.gotoAndStop(1);
            }
         };
         resetShotVars = function():void
         {
            var compX:* = undefined;
            var compY:* = undefined;
            fouled = false;
            upKeyDown = false;
            downKeyDown = false;
            leftKeyDown = false;
            rightKeyDown = false;
            upKey2Down = false;
            downKey2Down = false;
            leftKey2Down = false;
            rightKey2Down = false;
            spaceKeyDown = false;
            shiftKeyDown = false;
            storedMouseY = false;
            cue.x = -ballRadius * 2 * physScale;
            cue.shadow.x = cue.x;
            cueCanvas.rotation = 0;
            cueCanvas.x = stageWidth / 2 - 30 + ballArray[0].position.x * physScale;
            cueCanvas.y = stageHeight / 2 + ballArray[0].position.y * physScale;
            for(var b:uint = 0; b < ballArray.length; b++)
            {
               ballArray[b].lastCollisionObject = null;
               ballArray[b].firstContact = false;
               ballArray[b].contactArray = new Array();
            }
            shotRunning = false;
            mouseOverStrike = false;
            tuningLeft = false;
            tuningRight = false;
            preventAim = false;
            findNextTargets();
            if(myTurn == true)
            {
               initWidget();
               cueCanvas.alpha = 1;
               power = gui.power.mask.height * 20;
               if(cueBallInHand == true)
               {
                  ballArray[0].active = true;
                  guideCanvas.visible = false;
                  tuning.visible = false;
                  ballArray[0].shadow1.visible = true;
                  ballArray[0].mc.visible = true;
                  ballArray[0].position.x = tableTop.mouseX / physScale;
                  ballArray[0].position.y = tableTop.mouseY / physScale;
                  renderScreen();
               }
               else
               {
                  cueCanvas.visible = true;
                  cueCanvas.rotation = 180 + 180 / Math.PI * Math.atan2(ballArray[0].position.y,ballArray[0].position.x);
                  compX = Math.cos(cueCanvas.rotation * Math.PI / 180);
                  compY = Math.sin(cueCanvas.rotation * Math.PI / 180);
                  aimDirectionVector = new Vector2D(compX,compY).normalize();
                  updateAimingGuide();
               }
               if(requiredBallOn == true || bonusBallOn == true)
               {
                  marker.visible = true;
                  marker.gotoAndPlay(1);
                  marker.x = ballArray[currentTarget].position.x * physScale;
                  marker.y = ballArray[currentTarget].position.y * physScale;
                  if(showNextTarget == true)
                  {
                     if(ballsRemaining > 1)
                     {
                        marker2.visible = true;
                        marker2.gotoAndPlay(110);
                        marker2.x = ballArray[nextTarget].position.x * physScale;
                        marker2.y = ballArray[nextTarget].position.y * physScale;
                     }
                     else
                     {
                        marker2.visible = false;
                        marker2.stop();
                     }
                  }
               }
            }
         };
         var findNextTargets:Function = function():void
         {
            var n:uint = 0;
            var ball:* = undefined;
            if(bonusBallOn == true || requiredBallOn == true)
            {
               currentTarget = 15;
               for(n = 1; n < ballArray.length; n++)
               {
                  ball = ballArray[n];
                  if(ball.active == true)
                  {
                     if(ball.id < currentTarget)
                     {
                        currentTarget = ball.id;
                     }
                  }
               }
               if(showNextTarget == true)
               {
                  if(ballsRemaining > 1)
                  {
                     nextTarget = 15;
                     for(n = 1; n < ballArray.length; n++)
                     {
                        ball = ballArray[n];
                        if(ball.active == true)
                        {
                           if(ball.id > currentTarget && ball.id < nextTarget)
                           {
                              nextTarget = ball.id;
                           }
                        }
                     }
                  }
               }
            }
         };
         var placeMyCueBall:Function = function():void
         {
            var placementLegal:Boolean = false;
            var cueBall:* = undefined;
            var n:uint = 0;
            var ball:* = undefined;
            var distSq:* = undefined;
            var compX:* = undefined;
            var compY:* = undefined;
            if(cueBallInHand == true && shotRunning == false)
            {
               trace("placing");
               ballArray[0].position.x = tableTop.mouseX / physScale;
               ballArray[0].position.y = tableTop.mouseY / physScale;
               renderScreen();
               placementLegal = true;
               cueBall = ballArray[0];
               if(cueBall.position.x > 30000 - ballRadius || cueBall.position.x < -30000 + ballRadius || cueBall.position.y > 15000 - ballRadius || cueBall.position.y < -15000 + ballRadius)
               {
                  placementLegal = false;
                  cueBall.mc.alpha = 0.3;
               }
               if(shotNum == 0)
               {
                  if(cueBall.position.x > -15000)
                  {
                     placementLegal = false;
                     cueBall.mc.alpha = 0.3;
                  }
               }
               if(cueBall.mc.x > tableTop.width / 2 || cueBall.mc.x < -tableTop.width / 2 || cueBall.mc.y > tableTop.height / 2 || cueBall.mc.y < -tableTop.height / 2)
               {
                  placementLegal = false;
                  cueBall.mc.alpha = 0;
               }
               for(n = 1; n < ballArray.length; n++)
               {
                  ball = ballArray[n];
                  if(ball.active == true)
                  {
                     distSq = (ball.position.x - cueBall.position.x) * (ball.position.x - cueBall.position.x) + (ball.position.y - cueBall.position.y) * (ball.position.y - cueBall.position.y);
                     if(distSq < ballRadius * 2 * ballRadius * 2 + 10)
                     {
                        placementLegal = false;
                        cueBall.mc.alpha = 0.3;
                     }
                  }
               }
               if(placementLegal == true)
               {
                  cueBall.mc.alpha = 1;
               }
               if(mouseIsDown == true)
               {
                  if(placementLegal == true)
                  {
                     cueBallInHand = false;
                     cueCanvas.rotation = 180 + 180 / Math.PI * Math.atan2(ballArray[0].position.y,ballArray[0].position.x);
                     compX = Math.cos(cueCanvas.rotation * Math.PI / 180);
                     compY = Math.sin(cueCanvas.rotation * Math.PI / 180);
                     aimDirectionVector = new Vector2D(compX,compY).normalize();
                     cueCanvas.x = stageWidth / 2 - 30 + ballArray[0].position.x * physScale;
                     cueCanvas.y = stageHeight / 2 + ballArray[0].position.y * physScale;
                     cueCanvas.visible = true;
                     cueCanvas.alpha = 1;
                     updateAimingGuide();
                     guideCanvas.visible = true;
                     tuning.visible = true;
                     tuning.x = ballArray[0].position.x * physScale;
                     tuning.y = ballArray[0].position.y * physScale;
                     tuning.rotation = cueCanvas.rotation;
                     preventAim = true;
                  }
               }
            }
         };
         var aim:Function = function():void
         {
            var compX:Number = NaN;
            var compY:Number = NaN;
            if(preventAim == false && cueBallInHand == false && settingPower == false && shotRunning == false && tuningLeft == false && tuningRight == false && mouseOverStrike == false)
            {
               if(mouseIsDown == true || leftKeyDown == true || rightKeyDown == true)
               {
                  if(tableTop.mouseX < tableTop.width / 2 && tableTop.mouseX > -tableTop.width / 2 && tableTop.mouseY < tableTop.height / 2 && tableTop.mouseY > -tableTop.height / 2)
                  {
                     if(rightKeyDown == false && leftKeyDown == false)
                     {
                        compX = gameCanvas.mouseX / physScale - ballArray[0].position.x;
                        compY = gameCanvas.mouseY / physScale - ballArray[0].position.y;
                        aimDirectionVector = new Vector2D(compX,compY).normalize();
                        cueCanvas.rotation = 180 / Math.PI * Math.atan2(compY,compX);
                     }
                     if(rightKeyDown == false && leftKeyDown == false)
                     {
                        aimSpeed = 0.1;
                        aimAcc = 0.005;
                     }
                     if(aimSpeed > 4)
                     {
                        aimSpeed = 4;
                     }
                     if(aimAcc > 0.1)
                     {
                        aimAcc = 0.1;
                     }
                     compX = Math.cos(cueCanvas.rotation * Math.PI / 180);
                     compY = Math.sin(cueCanvas.rotation * Math.PI / 180);
                     aimDirectionVector = new Vector2D(compX,compY).normalize();
                     if(oldAim.x != aimDirectionVector.x || oldAim.y != aimDirectionVector.y || leftKeyDown == true || rightKeyDown == true || upKeyDown == true || downKeyDown == true)
                     {
                        updateAimingGuide();
                     }
                     oldAim.x = aimDirectionVector.x;
                     oldAim.y = aimDirectionVector.y;
                  }
               }
            }
         };
         var updateAimingGuide:Function = function():void
         {
            var _loc1_:Boolean = false;
            var _loc2_:Object = null;
            var _loc3_:Point = null;
            var _loc4_:uint = 0;
            var _loc5_:Boolean = false;
            var _loc6_:Point = null;
            var _loc7_:Array = null;
            var _loc8_:Array = null;
            var _loc9_:Point = null;
            var _loc10_:uint = 0;
            var _loc11_:Array = null;
            var _loc12_:uint = 0;
            var _loc13_:Object = null;
            if(cueBallInHand == false)
            {
               _loc1_ = false;
               _loc5_ = false;
               _loc7_ = new Array();
               _loc8_ = new Array();
               resetBallArraySim2();
               ballArraySim2[0].velocity = aimDirectionVector.times(power);
               ballArraySim2[0].screw = ballArray[0].screw;
               ballArraySim2[0].english = ballArray[0].english;
               ballArraySim2[0].ySpin = -ballArray[0].english * power / 300;
               preSim2.ballData = ballArraySim2;
               preSim2.targetID = -1;
               guideCanvas.visible = true;
               _loc3_ = new Point(ballArraySim2[0].position.x * physScale,ballArraySim2[0].position.y * physScale);
               for(_loc10_ = 0; _loc10_ < 15; _loc10_++)
               {
                  preSim2.updatePhysics();
                  _loc11_ = ballArraySim2[0].contactArray;
                  if(_loc11_.length > 0)
                  {
                     for(_loc12_ = 0; _loc12_ < _loc11_.length; _loc12_++)
                     {
                        _loc13_ = _loc11_[_loc12_];
                        if(_loc13_.collisionType == "ball")
                        {
                           if(_loc1_ == false)
                           {
                              _loc1_ = true;
                              _loc2_ = _loc13_.target;
                              _loc6_ = new Point(_loc13_.targetPosition.x * physScale,_loc13_.targetPosition.y * physScale);
                              _loc9_ = new Point(_loc13_.position.x * physScale,_loc13_.position.y * physScale);
                              _loc7_.push(_loc9_);
                           }
                           else
                           {
                              _loc8_.push(new Point(_loc13_.targetPosition.x * physScale,_loc13_.targetPosition.y * physScale));
                           }
                        }
                        if(_loc13_.collisionType == "line" || _loc13_.collisionType == "vertex")
                        {
                           _loc7_.push(new Point(_loc13_.position.x * physScale,_loc13_.position.y * physScale));
                        }
                     }
                  }
                  if(_loc1_ == true)
                  {
                     _loc11_ = ballArraySim2[_loc2_.id].contactArray;
                     if(_loc11_.length > 0)
                     {
                        for(_loc12_ = 0; _loc12_ < _loc11_.length; _loc12_++)
                        {
                           _loc13_ = _loc11_[_loc12_];
                           _loc8_.push(new Point(_loc13_.position.x * physScale,_loc13_.position.y * physScale));
                        }
                     }
                     ballArraySim2[_loc2_.id].contactArray = new Array();
                  }
                  ballArraySim2[0].contactArray = new Array();
                  _loc7_.push(new Point(ballArraySim2[0].position.x * physScale,ballArraySim2[0].position.y * physScale));
                  if(_loc1_ == true)
                  {
                     _loc8_.push(new Point(_loc2_.position.x * physScale,_loc2_.position.y * physScale));
                  }
               }
               guideCanvas.graphics.clear();
               guideCanvas.graphics.lineStyle(ballRadius * physScale * 2,16777215,0.1);
               if(_loc7_.length > 1)
               {
                  guideCanvas.graphics.moveTo(_loc3_.x,_loc3_.y);
                  for(_loc12_ = 0; _loc12_ < _loc7_.length; _loc12_++)
                  {
                     guideCanvas.graphics.lineTo(_loc7_[_loc12_].x,_loc7_[_loc12_].y);
                  }
               }
               guideCanvas.graphics.lineStyle(1,16777215,0.1);
               if(_loc7_.length > 1)
               {
                  guideCanvas.graphics.moveTo(_loc3_.x,_loc3_.y);
                  for(_loc12_ = 0; _loc12_ < _loc7_.length; _loc12_++)
                  {
                     guideCanvas.graphics.lineTo(_loc7_[_loc12_].x,_loc7_[_loc12_].y);
                  }
               }
               guideCanvas.graphics.lineStyle(ballRadius * physScale * 2,16777215,0.1);
               if(_loc8_.length > 1)
               {
                  guideCanvas.graphics.moveTo(_loc6_.x,_loc6_.y);
                  for(_loc12_ = 0; _loc12_ < _loc8_.length; _loc12_++)
                  {
                     guideCanvas.graphics.lineTo(_loc8_[_loc12_].x,_loc8_[_loc12_].y);
                  }
               }
               guideCanvas.graphics.lineStyle(1,16777215,0.1);
               if(_loc8_.length > 1)
               {
                  guideCanvas.graphics.moveTo(_loc6_.x,_loc6_.y);
                  for(_loc12_ = 0; _loc12_ < _loc8_.length; _loc12_++)
                  {
                     guideCanvas.graphics.lineTo(_loc8_[_loc12_].x,_loc8_[_loc12_].y);
                  }
               }
               if(_loc9_)
               {
                  guideCanvas.graphics.lineStyle(1,16777215,0.4);
                  guideCanvas.graphics.drawCircle(_loc9_.x,_loc9_.y,ballRadius * physScale);
                  reticleOn = true;
               }
               else
               {
                  reticleOn = false;
               }
            }
         };
         var initWidget:Function = function():void
         {
            tuning.visible = true;
            tuning.arrowL.gotoAndStop(1);
            tuning.arrowR.gotoAndStop(1);
            tuning.x = ballArray[0].position.x * physScale;
            tuning.y = ballArray[0].position.y * physScale;
            tuning.arrowL.addEventListener(MouseEvent.MOUSE_DOWN,fineTuneLeft);
            tuning.arrowR.addEventListener(MouseEvent.MOUSE_DOWN,fineTuneRight);
            tuning.strike.addEventListener(MouseEvent.MOUSE_OVER,prepareStrike);
            tuning.strike.addEventListener(MouseEvent.CLICK,strikeMyBall);
            tuning.strike.addEventListener(MouseEvent.MOUSE_OUT,cancelPrepareStrike);
            stage.addEventListener(Event.MOUSE_LEAVE,cancelPrepareStrike);
         };
         var cleanWidget:Function = function():void
         {
            tuning.visible = false;
            tuning.strike.strikeFill.alpha = 0;
            tuning.arrowL.removeEventListener(MouseEvent.MOUSE_DOWN,fineTuneLeft);
            tuning.arrowR.removeEventListener(MouseEvent.MOUSE_DOWN,fineTuneRight);
            tuning.strike.removeEventListener(MouseEvent.MOUSE_OVER,prepareStrike);
            tuning.strike.removeEventListener(MouseEvent.CLICK,strikeMyBall);
            tuning.strike.removeEventListener(MouseEvent.MOUSE_OUT,cancelPrepareStrike);
            stage.removeEventListener(Event.MOUSE_LEAVE,cancelPrepareStrike);
         };
         var fineTuneLeftOver:Function = function(e:MouseEvent):void
         {
            tuning.arrowL.gotoAndStop(2);
         };
         var fineTuneRightOver:Function = function(e:MouseEvent):void
         {
            tuning.arrowR.gotoAndStop(2);
         };
         var fineTuneLeftUp:Function = function(e:MouseEvent):void
         {
            tuning.arrowL.gotoAndStop(1);
         };
         var fineTuneRightUp:Function = function(e:MouseEvent):void
         {
            tuning.arrowR.gotoAndStop(1);
         };
         prepareStrike = function(e:MouseEvent):void
         {
            mouseOverStrike = true;
            TweenLite.to(cue,0.6,{
               "x":-(power / 300) - ballRadius * 2 * physScale,
               "ease":Quad.easeInOut
            });
            TweenLite.to(cue.shadow,0.6,{
               "x":-(power / 300) - ballRadius * 2 * physScale,
               "ease":Quad.easeInOut
            });
            TweenLite.to(tuning.strike.strikeFill,0.6,{"alpha":0.3});
         };
         cancelPrepareStrike = function(e:*):void
         {
            mouseOverStrike = false;
            TweenLite.to(cue,0.5,{
               "x":-ballRadius * 2 * physScale,
               "ease":Quad.easeInOut
            });
            TweenLite.to(tuning.strike.strikeFill,0.6,{"alpha":0});
            cue.shadow.x = cue.x;
         };
         var fineTuneUpdate:Function = function():void
         {
            var compX:* = undefined;
            var compY:* = undefined;
            if(tuning.visible == true)
            {
               if(mouseIsDown == true || leftKeyDown == true || rightKeyDown == true)
               {
                  if(tuningLeft == true || leftKeyDown == true)
                  {
                     if(shiftKeyDown == true)
                     {
                        cueCanvas.rotation -= 0.5;
                     }
                     else
                     {
                        cueCanvas.rotation -= aimSpeed;
                        aimSpeed += 0.002;
                        if(aimSpeed >= 0.1)
                        {
                           aimSpeed = 0.1;
                        }
                     }
                     tuning.arrowL.gotoAndStop(3);
                  }
                  if(tuningRight == true || rightKeyDown == true)
                  {
                     if(shiftKeyDown == true)
                     {
                        cueCanvas.rotation += 0.5;
                     }
                     else
                     {
                        cueCanvas.rotation += aimSpeed;
                        aimSpeed += 0.002;
                        if(aimSpeed >= 0.1)
                        {
                           aimSpeed = 0.1;
                        }
                     }
                     tuning.arrowR.gotoAndStop(3);
                  }
                  if(tuningLeft == true || tuningRight == true || leftKeyDown == true || rightKeyDown == true)
                  {
                     compX = Math.cos(cueCanvas.rotation * Math.PI / 180);
                     compY = Math.sin(cueCanvas.rotation * Math.PI / 180);
                     aimDirectionVector = new Vector2D(compX,compY).normalize();
                     updateAimingGuide();
                  }
               }
               else
               {
                  tuningLeft = false;
                  tuningRight = false;
                  tuning.arrowL.gotoAndStop(1);
                  tuning.arrowR.gotoAndStop(1);
               }
               tuning.rotation = cueCanvas.rotation;
            }
         };
         fineTuneLeft = function(e:MouseEvent):void
         {
            tuningLeft = true;
         };
         fineTuneRight = function(e:MouseEvent):void
         {
            tuningRight = true;
         };
         var setPower:Function = function():void
         {
            if(shotRunning == false)
            {
               if(mouseIsDown == true)
               {
                  if(gui.powerCover.mouseX < gui.powerCover.width && gui.powerCover.mouseX > 0 && gui.powerCover.mouseY < gui.powerCover.height && gui.powerCover.mouseY > 0)
                  {
                     gui.power.mask.height = 308 - gui.power.mouseY + 35;
                     updateAimingGuide();
                  }
               }
               if(upKeyDown == true)
               {
                  gui.power.mask.height += 8;
                  updateAimingGuide();
               }
               if(downKeyDown == true)
               {
                  gui.power.mask.height -= 8;
                  updateAimingGuide();
               }
               if(spaceKeyDown == true)
               {
                  gui.power.mask.height = 154;
                  updateAimingGuide();
               }
               if(gui.power.mask.height > 308)
               {
                  gui.power.mask.height = 308;
               }
               if(gui.power.mask.height < 0)
               {
                  gui.power.mask.height = 0;
               }
            }
            power = gui.power.mask.height * 20;
         };
         var updateCountdown:Function = function():void
         {
            if(timeRemainingOn == true && ballsRemaining > 0 && pauseCountdown == false)
            {
               ++countdownCounter;
               if(countdownCounter == 30)
               {
                  countdownCounter = 0;
                  --timeRemaining;
                  if(timeRemaining < 0)
                  {
                     timeRemaining = 0;
                     checkLevelOver();
                  }
                  updateGUI();
               }
            }
         };
         var setSpin:Function = function():void
         {
            var mustUpdateGuide:* = undefined;
            var distSq:Number = NaN;
            var ang:Number = NaN;
            if(settingPower == false && shotRunning == false)
            {
               mustUpdateGuide = false;
               if(mouseIsDown == true)
               {
                  if(gui.spinSetter.mouseX < gui.spinSetter.width / 2 && gui.spinSetter.mouseX > -gui.spinSetter.width / 2 && gui.spinSetter.mouseY < gui.spinSetter.height / 2 && gui.spinSetter.mouseY > -gui.spinSetter.height / 2)
                  {
                     gui.spinSetter.crosshair.x = gui.spinSetter.mouseX;
                     gui.spinSetter.crosshair.y = gui.spinSetter.mouseY;
                     mustUpdateGuide = true;
                  }
               }
               if(leftKey2Down == true)
               {
                  gui.spinSetter.crosshair.x -= 1;
                  mustUpdateGuide = true;
               }
               if(rightKey2Down == true)
               {
                  gui.spinSetter.crosshair.x += 1;
                  mustUpdateGuide = true;
               }
               if(upKey2Down == true)
               {
                  gui.spinSetter.crosshair.y -= 1;
                  mustUpdateGuide = true;
               }
               if(downKey2Down == true)
               {
                  gui.spinSetter.crosshair.y += 1;
                  mustUpdateGuide = true;
               }
               if(rKeyDown == true)
               {
                  gui.spinSetter.crosshair.x = 0;
                  gui.spinSetter.crosshair.y = 0;
                  mustUpdateGuide = true;
               }
               distSq = gui.spinSetter.crosshair.x * gui.spinSetter.crosshair.x + gui.spinSetter.crosshair.y * gui.spinSetter.crosshair.y;
               if(distSq > gui.spinSetter.ball.width / 2 * (gui.spinSetter.ball.width / 2))
               {
                  ang = Math.atan2(gui.spinSetter.crosshair.y,gui.spinSetter.crosshair.x);
                  gui.spinSetter.crosshair.x = gui.spinSetter.ball.width / 2 * Math.cos(ang);
                  gui.spinSetter.crosshair.y = gui.spinSetter.ball.width / 2 * Math.sin(ang);
               }
               ballArray[0].screw = Maths.fixNumber(0.5 * gui.spinSetter.crosshair.y / (gui.spinSetter.ball.width / 2));
               ballArraySim[0].screw = ballArray[0].screw;
               ballArraySim2[0].screw = ballArray[0].screw;
               ballArray[0].english = Maths.fixNumber(gui.spinSetter.crosshair.x / (gui.spinSetter.ball.width / 2));
               ballArraySim[0].english = ballArray[0].english;
               ballArraySim2[0].english = ballArray[0].english;
               cue.y = 0.8 * ballArray[0].english * ballRadius * physScale;
               if(mustUpdateGuide == true)
               {
                  updateAimingGuide();
               }
            }
         };
         var strikeWithKeyboard:Function = function():void
         {
            if(spaceKeyDown == true && shotRunning == false)
            {
               strikeMyBall(null);
            }
         };
         strikeMyBall = function(e:MouseEvent):void
         {
            var hideCueCanvas:Function = null;
            var volume:* = undefined;
            if(tuningLeft == false && tuningRight == false)
            {
               if(power > 0)
               {
                  hideCueCanvas = function():void
                  {
                     cueCanvas.visible = false;
                     cueTweenComplete = true;
                  };
                  guideCanvas.visible = false;
                  shotRunning = true;
                  pauseCountdown = false;
                  gui.strikeHint.visible = false;
                  gui.adjustHint.visible = false;
                  if(requiredBallOn == true || bonusBallOn == true)
                  {
                     marker.visible = false;
                     if(showNextTarget == true)
                     {
                        marker2.visible = false;
                     }
                  }
                  TweenLite.to(cue,0.5,{
                     "x":power / 600,
                     "ease":Quad.easeOut
                  });
                  TweenLite.to(cue.shadow,0.5,{
                     "x":power / 600,
                     "ease":Quad.easeOut
                  });
                  TweenLite.to(cueCanvas,1,{
                     "delay":1.5,
                     "alpha":0,
                     "onComplete":hideCueCanvas
                  });
                  cueTweenComplete = false;
                  cleanWidget();
                  ++shotNum;
                  ++shotsRemaining;
                  updateGUI();
                  ballArray[0].velocity = aimDirectionVector.times(power);
                  ballArray[0].ySpin = -ballArray[0].english * power / 300;
                  if(ballArray[0].ySpin > 20)
                  {
                     ballArray[0].ySpin = 20;
                  }
                  if(ballArray[0].ySpin < -20)
                  {
                     ballArray[0].ySpin = -20;
                  }
                  volume = power / 6000;
                  if(volume > 1)
                  {
                     volume = 1;
                  }
                  if(volume < 0.3)
                  {
                     volume = 0.3;
                  }
                  Sound.Play("cue",volume);
                  if(online == true)
                  {
                     sendShot();
                  }
               }
            }
         };
         var checkMyShotOver:Function = function():void
         {
            var ballsMoving:Boolean = false;
            var n:uint = 0;
            var ball:Object = null;
            if(shotRunning == true && pocketTweenComplete == true && cueTweenComplete == true)
            {
               ballsMoving = false;
               for(n = 0; n < ballArray.length; n++)
               {
                  ball = ballArray[n];
                  if(ball.velocity.magnitude > 0)
                  {
                     ballsMoving = true;
                  }
               }
               if(ballsMoving == false)
               {
                  shotRunning = false;
                  if(gameMode == 0)
                  {
                     transferBonus();
                  }
                  else
                  {
                     endShot();
                  }
               }
            }
         };
         transferBonus = function():void
         {
            var n:* = undefined;
            var updateTransferBonus:Function = null;
            if(bonus > 0)
            {
               updateTransferBonus = function(e:Event):*
               {
                  if(n > bonus)
                  {
                     n = bonus;
                  }
                  bonus -= n;
                  if(fouled == false)
                  {
                     score += n;
                  }
                  updateGUI();
                  if(bonus <= 0)
                  {
                     stage.removeEventListener(Event.ENTER_FRAME,updateTransferBonus);
                     preventQuit = false;
                     pauseCountdown = false;
                     endShot();
                  }
               };
               n = Math.ceil(bonus / 30);
               stage.addEventListener(Event.ENTER_FRAME,updateTransferBonus);
               preventQuit = true;
               pauseCountdown = true;
            }
            else
            {
               endShot();
            }
         };
         var endShot:Function = function():void
         {
            if(gameMode == 0)
            {
               checkLevelOver();
            }
            if(gameRunning == true)
            {
               setTimeout(resetShotVars,500);
            }
            if(online == true)
            {
               verifyMyPositions();
            }
         };
         var verifyMyPositions:Function = function():void
         {
            var total:Number = NaN;
            var b:uint = 0;
            var ball:Object = null;
            total = 0;
            for(b = 0; b < ballArray.length; b++)
            {
               ball = ballArray[b];
               total += Maths.fixNumber((ball.position.x + ball.position.y) * physScale);
            }
            total = Maths.fixNumber(total * 10000);
            debug.textField.appendText("pos: " + String(total) + "\n");
            sendVerification(total);
            switchTurns();
         };
         var placeYourCueBall:Function = function(cueBallPositionX:Number, cueBallPositionY:Number):void
         {
            if(myTurn == false)
            {
               ballArray[0].position.x = cueBallPositionX;
               ballArray[0].position.y = cueBallPositionY;
               renderScreen();
            }
            cueBallInHand = false;
         };
         var strikeYourBall:Function = function(vx:Number, vy:Number, s:Number, e:Number):void
         {
            var volume:* = undefined;
            if(myTurn == false)
            {
               ++shotNum;
               shotRunning = true;
               ballArray[0].screw = s;
               ballArray[0].english = e;
               ballArray[0].velocity = new Vector2D(vx,vy);
               ballArray[0].ySpin = -ballArray[0].english * ballArray[0].velocity.magnitude / 300;
               if(ballArray[0].ySpin > 20)
               {
                  ballArray[0].ySpin = 20;
               }
               if(ballArray[0].ySpin < -20)
               {
                  ballArray[0].ySpin = -20;
               }
               volume = ballArray[0].velocity.magnitude / 6000;
               if(volume > 1)
               {
                  volume = 1;
               }
               if(volume < 0.3)
               {
                  volume = 0.3;
               }
               Sound.Play("cue",volume);
            }
         };
         var checkYourShotOver:Function = function():void
         {
            var ballsMoving:Boolean = false;
            var n:uint = 0;
            var ball:Object = null;
            if(shotRunning == true)
            {
               ballsMoving = false;
               for(n = 0; n < ballArray.length; n++)
               {
                  ball = ballArray[n];
                  if(ball.velocity.magnitude > 0)
                  {
                     ballsMoving = true;
                  }
               }
               if(ballsMoving == false)
               {
                  shotRunning = false;
                  resetShotVars();
                  addEventListener(Event.ENTER_FRAME,verifyYourPositions);
               }
            }
         };
         verifyYourPositions = function(e:Event):void
         {
            var total:Number = NaN;
            var b:uint = 0;
            var ball:Object = null;
            if(verificationReceived == true)
            {
               verificationReceived = false;
               removeEventListener(Event.ENTER_FRAME,verifyYourPositions);
               total = 0;
               for(b = 0; b < ballArray.length; b++)
               {
                  ball = ballArray[b];
                  total += Maths.fixNumber((ball.position.x + ball.position.y) * physScale);
               }
               total = Maths.fixNumber(total * 10000);
               debug.textField.appendText("pos: " + String(total) + "\n");
               if(receivedVerificationValue == total)
               {
                  debug.textField.appendText("Clients in sync\n");
               }
               else
               {
                  debug.textField.appendText("Warning: clients out of sync. Received value: " + String(receivedVerificationValue) + " Calculated value: " + String(total) + "\n");
               }
               switchTurns();
            }
         };
         reRack = function(e:*):void
         {
            if(preventQuit == false)
            {
               gameRunning = false;
               cleanUp();
               initGame();
            }
         };
         quit = function(e:MouseEvent):void
         {
            var swap:Function = null;
            if(preventQuit == false)
            {
               swap = function():void
               {
                  cleanUp();
                  musicVolume = 0;
                  stage.addEventListener(Event.ENTER_FRAME,fadeMusicIn);
                  showMainMenu();
               };
               gameRunning = false;
               fade();
               setTimeout(swap,500);
            }
         };
         var showLevelComplete:Function = function():void
         {
            musicVolume = 0;
            stage.addEventListener(Event.ENTER_FRAME,fadeMusicIn);
            levelComplete = new levelComplete_mc();
            projectCanvas.addChild(levelComplete);
            levelComplete.x = gameCanvas.x;
            levelComplete.y = gameCanvas.y;
            levelComplete._SELECT_LEVEL_.addEventListener(MouseEvent.CLICK,levelCompleteToLevelSelect);
            levelComplete._NEXT_SESSION_.addEventListener(MouseEvent.CLICK,levelCompleteToNextLevel);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,onSPKeyDown);
            levelComplete.sponsorLogo.addEventListener(MouseEvent.CLICK,gotoSponsor);
         };
         onSPKeyDown = function(e:KeyboardEvent):void
         {
            if(e.keyCode == Keyboard.SPACE)
            {
               levelCompleteToNextLevel(null);
            }
         };
         var removeLevelComplete:Function = function():void
         {
            levelComplete._SELECT_LEVEL_.removeEventListener(MouseEvent.CLICK,levelCompleteToLevelSelect);
            levelComplete._NEXT_SESSION_.removeEventListener(MouseEvent.CLICK,levelCompleteToNextLevel);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,onSPKeyDown);
            levelComplete.sponsorLogo.removeEventListener(MouseEvent.CLICK,gotoSponsor);
            projectCanvas.removeChild(levelComplete);
         };
         levelCompleteToLevelSelect = function(e:MouseEvent):void
         {
            var swap:Function = null;
            swap = function():void
            {
               removeLevelComplete();
               cleanUp();
               showLevelSelect();
            };
            fade();
            setTimeout(swap,500);
         };
         levelCompleteToNextLevel = function(e:*):void
         {
            var swap:Function = null;
            swap = function():void
            {
               removeLevelComplete();
               cleanUp();
               ++currentLevel;
               hintShown = false;
               if(currentLevel < 21)
               {
                  initGame();
               }
               else
               {
                  showChallenge();
               }
            };
            fade();
            setTimeout(swap,500);
         };
         var showLevelFailed:Function = function(message:*):void
         {
            musicVolume = 0;
            stage.addEventListener(Event.ENTER_FRAME,fadeMusicIn);
            levelFailed = new levelFailed_mc();
            projectCanvas.addChild(levelFailed);
            levelFailed.x = gameCanvas.x;
            levelFailed.y = gameCanvas.y;
            levelFailed.message.text = message;
            levelFailed._SELECT_LEVEL_.addEventListener(MouseEvent.CLICK,levelFailedToLevelSelect);
            levelFailed._TRY_AGAIN_.addEventListener(MouseEvent.CLICK,levelFailedToSameLevel);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,onRKeyDown);
            levelFailed.sponsorLogo.addEventListener(MouseEvent.CLICK,gotoSponsor);
         };
         onRKeyDown = function(e:KeyboardEvent):void
         {
            if(e.keyCode == 114 || e.keyCode == 82)
            {
               levelFailedToSameLevel(null);
            }
         };
         var removeLevelFailed:Function = function():void
         {
            levelFailed._SELECT_LEVEL_.removeEventListener(MouseEvent.CLICK,levelFailedToLevelSelect);
            levelFailed._TRY_AGAIN_.removeEventListener(MouseEvent.CLICK,levelFailedToSameLevel);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,onRKeyDown);
            levelFailed.sponsorLogo.removeEventListener(MouseEvent.CLICK,gotoSponsor);
            projectCanvas.removeChild(levelFailed);
         };
         levelFailedToLevelSelect = function(e:*):void
         {
            var swap:Function = null;
            swap = function():void
            {
               removeLevelFailed();
               cleanUp();
               showLevelSelect();
            };
            fade();
            setTimeout(swap,500);
         };
         levelFailedToSameLevel = function(e:MouseEvent):void
         {
            var swap:Function = null;
            swap = function():void
            {
               removeLevelFailed();
               cleanUp();
               initGame();
            };
            fade();
            setTimeout(swap,500);
         };
         var showChallengeComplete:Function = function():void
         {
            challengeComplete = new challengeComplete_mc();
            projectCanvas.addChild(challengeComplete);
            challengeComplete.message.text = "You scored " + String(score) + " points.\nSubmit your score to see how good you are!";
            challengeComplete.x = gameCanvas.x;
            challengeComplete.y = gameCanvas.y;
            challengeComplete._SUBMIT_SCORE_.addEventListener(MouseEvent.CLICK,submitScore);
            challengeComplete._BACK_.addEventListener(MouseEvent.CLICK,challengeCompleteToLevelSelect);
            challengeComplete._TRY_AGAIN_.addEventListener(MouseEvent.CLICK,challengeCompleteToSameLevel);
            challengeComplete.sponsorLogo.addEventListener(MouseEvent.CLICK,gotoSponsor);
         };
         var removeChallengeComplete:Function = function():void
         {
            challengeComplete._SUBMIT_SCORE_.removeEventListener(MouseEvent.CLICK,submitScore);
            challengeComplete._BACK_.removeEventListener(MouseEvent.CLICK,challengeCompleteToLevelSelect);
            challengeComplete._TRY_AGAIN_.removeEventListener(MouseEvent.CLICK,challengeCompleteToSameLevel);
            challengeComplete.sponsorLogo.removeEventListener(MouseEvent.CLICK,gotoSponsor);
            projectCanvas.removeChild(challengeComplete);
         };
         challengeCompleteToLevelSelect = function(e:MouseEvent):void
         {
            var swap:Function = null;
            swap = function():void
            {
               removeChallengeComplete();
               cleanUp();
               showLevelSelect();
            };
            fade();
            setTimeout(swap,500);
         };
         challengeCompleteToSameLevel = function(e:MouseEvent):void
         {
            var swap:Function = null;
            swap = function():void
            {
               removeChallengeComplete();
               cleanUp();
               initGame();
            };
            fade();
            setTimeout(swap,500);
         };
         submitScore = function(e:MouseEvent):*
         {
            var o:Object = null;
            var boardID:String = null;
            o = {
               "n":[14,14,4,13,7,3,12,15,14,5,1,14,4,0,15,9],
               "f":function(i:Number, s:String):String
               {
                  if(s.length == 16)
                  {
                     return s;
                  }
                  return this.f(i + 1,s + this.n[i].toString(16));
               }
            };
            boardID = o.f(0,"");
            MochiScores.showLeaderboard({
               "boardID":boardID,
               "score":score
            });
         };
         var cleanUp:Function = function():void
         {
            cleanWidget();
            stage.removeEventListener(Event.ENTER_FRAME,gameLoop);
            Dispatcher.GetInstance().removeEventListener(CustomEvent.EVENT,onContact);
            disableMouseListener();
            disableKeyboardListener();
            gui._QUIT_.removeEventListener(MouseEvent.CLICK,quit);
            gui._RESTART_.removeEventListener(MouseEvent.CLICK,reRack);
            gui._HINT_.removeEventListener(MouseEvent.CLICK,showHint);
            gui._WALKTHROUGH_.removeEventListener(MouseEvent.CLICK,gotoWalkthrough);
            gui.sponsorLogo.removeEventListener(MouseEvent.CLICK,gotoSponsor);
            stage.removeEventListener(Event.ENTER_FRAME,transferBonus);
            if(requiredBallOn == true || bonusBallOn == true)
            {
               gameCanvas.removeChild(marker);
            }
            projectCanvas.removeChild(gameCanvas);
            TweenLite.killTweensOf(cueCanvas);
            projectCanvas.removeChild(cueCanvas);
            projectCanvas.removeChild(gui);
            ballArray = new Array();
            lineArray = new Array();
            vertexArray = new Array();
            pocketArray = new Array();
            ballArraySim = new Array();
            oldAim = new Vector2D(0,0);
            phys = null;
            preSim = null;
            marker = null;
            gameCanvas = null;
            cueCanvas = null;
            gui = null;
            soundToggle.x = 23;
            soundToggle.y = 563;
            musicToggle.x = 58;
            musicToggle.y = 557;
         };
         var updateGUI:Function = function():void
         {
            gui.bonus.text = String(bonus);
            gui.score.text = String(score);
            if(shotsRemainingOn == true)
            {
               gui.topLeftValue.text = String(shotsRemaining);
            }
            if(timeRemainingOn == true)
            {
               gui.topLeftValue.text = String(timeRemaining);
            }
         };
         var showMessage:Function = function():void
         {
            gui.message.text = message;
            TweenLite.from(gui.message,2,{"y":gui.message.y + gui.message.height});
         };
         var initArrays:Function = function():void
         {
         };
         var setLevelData:Function = function():void
         {
            switch(currentLevel)
            {
               case 1:
                  hintOn = true;
                  message = "SESSION 1: Pot the 1-ball (the yellow one).  Your shots remaining are shown in the top left corner.";
                  foulsProhibited = false;
                  shotsRemainingOn = true;
                  shotsRemaining = 1;
                  timeRemainingOn = false;
                  bonusBallOn = false;
                  requiredBallOn = false;
                  showNextTarget = false;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 0;
                  break;
               case 2:
                  hintOn = true;
                  message = "SESSION 2: Use plenty of power to split the pack, then reduce the power to knock all the balls in without potting the cue ball.";
                  foulsProhibited = true;
                  shotsRemainingOn = true;
                  shotsRemaining = 5;
                  timeRemainingOn = false;
                  bonusBallOn = false;
                  requiredBallOn = false;
                  showNextTarget = false;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 0;
                  break;
               case 3:
                  hintOn = true;
                  message = "SESSION 3: Perform a kiss shot.";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  requiredBallOn = false;
                  showNextTarget = false;
                  shotsRemainingOn = true;
                  shotsRemaining = 1;
                  timeRemainingOn = false;
                  timeRemaining = 0;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = true;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 1;
                  combosRequired = 0;
                  break;
               case 4:
                  hintOn = true;
                  message = "SESSION 4: Perform 2 kick shots.";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  requiredBallOn = false;
                  showNextTarget = false;
                  shotsRemainingOn = true;
                  shotsRemaining = 3;
                  timeRemainingOn = false;
                  timeRemaining = 0;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = true;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 2;
                  kissesRequired = 0;
                  combosRequired = 0;
                  break;
               case 5:
                  hintOn = true;
                  message = "SESSION 5: Perform a combo shot.";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  requiredBallOn = false;
                  showNextTarget = false;
                  shotsRemainingOn = true;
                  shotsRemaining = 1;
                  timeRemainingOn = false;
                  timeRemaining = 0;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = true;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 1;
                  break;
               case 6:
                  hintOn = true;
                  message = "SESSION 6: Perform 2 bank shots.";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  requiredBallOn = false;
                  showNextTarget = false;
                  shotsRemainingOn = true;
                  shotsRemaining = 3;
                  timeRemainingOn = false;
                  timeRemaining = 0;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = true;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 2;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 0;
                  break;
               case 7:
                  hintOn = true;
                  message = "SESSION 7: Perform a carom shot.";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  requiredBallOn = false;
                  showNextTarget = false;
                  shotsRemainingOn = true;
                  shotsRemaining = 1;
                  timeRemainingOn = false;
                  timeRemaining = 0;
                  cueBallInHand = false;
                  cannonsRequiredOn = true;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 1;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 0;
                  break;
               case 8:
                  hintOn = true;
                  message = "SESSION 8: Start by placing the cue ball to the left of the line.  Then pot the balls in order.";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  shotsRemainingOn = true;
                  shotsRemaining = 5;
                  timeRemainingOn = false;
                  requiredBallOn = true;
                  showNextTarget = false;
                  cueBallInHand = true;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 0;
                  break;
               case 9:
                  hintOn = true;
                  message = "SESSION 9: Pot the balls in order.  This time you have a time limit, shown in the top left corner.";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  shotsRemainingOn = false;
                  shotsRemaining = 0;
                  timeRemainingOn = true;
                  timeRemaining = 120;
                  requiredBallOn = true;
                  showNextTarget = true;
                  cueBallInHand = true;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 0;
                  break;
               case 10:
                  hintOn = true;
                  message = "SESSION 10: Use SCREW to pot both balls in one shot.";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  requiredBallOn = false;
                  showNextTarget = false;
                  shotsRemainingOn = true;
                  shotsRemaining = 1;
                  timeRemainingOn = false;
                  timeRemaining = 0;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 0;
                  break;
               case 11:
                  hintOn = true;
                  message = "SESSION 11: Use TOP SPIN to pot both balls in one shot.";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  requiredBallOn = false;
                  showNextTarget = false;
                  shotsRemainingOn = true;
                  shotsRemaining = 1;
                  timeRemainingOn = false;
                  timeRemaining = 0;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 0;
                  break;
               case 12:
                  hintOn = true;
                  message = "SESSION 12: Pot the balls in order. Use English to develop the tricky 2 and 3 balls.";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  shotsRemainingOn = true;
                  shotsRemaining = 3;
                  timeRemainingOn = false;
                  requiredBallOn = true;
                  showNextTarget = true;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 0;
                  break;
               case 13:
                  hintOn = true;
                  message = "SESSION 13: Pot the balls in any order within the time limit.";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  shotsRemainingOn = false;
                  shotsRemaining = 0;
                  timeRemainingOn = true;
                  timeRemaining = 60;
                  requiredBallOn = false;
                  showNextTarget = false;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 0;
                  break;
               case 14:
                  hintOn = false;
                  message = "SESSION 14: Perform 2 kiss shots.  Click the HINT button to review previous tutorials.";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  shotsRemainingOn = true;
                  shotsRemaining = 10;
                  timeRemainingOn = false;
                  timeRemaining = 0;
                  requiredBallOn = false;
                  showNextTarget = false;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = true;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 2;
                  combosRequired = 0;
                  break;
               case 15:
                  hintOn = false;
                  message = "SESSION 15: Perform 1 bank shot and 1 kick shot.";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  shotsRemainingOn = true;
                  shotsRemaining = 3;
                  timeRemainingOn = false;
                  timeRemaining = 0;
                  requiredBallOn = false;
                  showNextTarget = false;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = true;
                  kicksRequiredOn = true;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 1;
                  kicksRequired = 1;
                  kissesRequired = 0;
                  combosRequired = 0;
                  break;
               case 16:
                  hintOn = false;
                  message = "SESSION 16: Pot the balls in any order.  You have fewer shots than balls, so you will need to pull off some clever shots.";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  shotsRemainingOn = true;
                  shotsRemaining = 8;
                  timeRemainingOn = false;
                  timeRemaining = 0;
                  requiredBallOn = false;
                  showNextTarget = false;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 0;
                  break;
               case 17:
                  hintOn = false;
                  message = "SESSION 17: Perform 3 combo shots, keeping to the correct potting sequence.";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  requiredBallOn = true;
                  showNextTarget = true;
                  shotsRemainingOn = true;
                  shotsRemaining = 5;
                  timeRemainingOn = false;
                  timeRemaining = 0;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = true;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 3;
                  break;
               case 18:
                  hintOn = false;
                  message = "SESSION 18: Pot the balls in the required order.  You have very limited shots - this is getting tricky!";
                  foulsProhibited = false;
                  bonusBallOn = false;
                  shotsRemainingOn = true;
                  shotsRemaining = 6;
                  timeRemainingOn = false;
                  timeRemaining = 0;
                  requiredBallOn = true;
                  showNextTarget = true;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 0;
                  break;
               case 19:
                  hintOn = false;
                  message = "SESSION 19: Perform 2 carom shots.  You can pot the balls in any order, but you have limited time";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  shotsRemainingOn = false;
                  shotsRemaining = 0;
                  timeRemainingOn = true;
                  timeRemaining = 40;
                  requiredBallOn = false;
                  showNextTarget = false;
                  cueBallInHand = false;
                  cannonsRequiredOn = true;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 2;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 0;
                  break;
               case 20:
                  hintOn = false;
                  message = "FINAL SESSION: Pot the full set of balls in the required sequence. No shot limit, but pot one wrong ball and it\'s all over.";
                  foulsProhibited = true;
                  bonusBallOn = false;
                  shotsRemainingOn = false;
                  shotsRemaining = 0;
                  timeRemainingOn = false;
                  timeRemaining = 0;
                  requiredBallOn = true;
                  showNextTarget = true;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 0;
                  break;
               case 21:
                  hintOn = false;
                  message = "CHALLENGE MODE: Pull off your most skillful trick shots to score as many points as possible.";
                  foulsProhibited = false;
                  bonusBallOn = true;
                  shotsRemainingOn = true;
                  shotsRemaining = 20;
                  timeRemainingOn = false;
                  timeRemaining = 0;
                  requiredBallOn = false;
                  showNextTarget = true;
                  cueBallInHand = false;
                  cannonsRequiredOn = false;
                  banksRequiredOn = false;
                  kicksRequiredOn = false;
                  kissesRequiredOn = false;
                  combosRequiredOn = false;
                  cannonsRequired = 0;
                  banksRequired = 0;
                  kicksRequired = 0;
                  kissesRequired = 0;
                  combosRequired = 0;
            }
         };
         var setBallPositions:Function = function():Array
         {
            var ballPositionArray:Array = null;
            var px:* = undefined;
            var spacing:Number = NaN;
            var j:Number = NaN;
            var k:Number = NaN;
            var levels:MovieClip = null;
            var balls:MovieClip = null;
            ballPositionArray = new Array();
            px = 15000;
            spacing = 0.01;
            j = 1 + spacing;
            k = 1.732 + spacing;
            switch(currentLevel)
            {
               case 1:
                  ballPositionArray[0] = new Point(-15000,0);
                  ballPositionArray[1] = new Point(20000,-5000);
                  break;
               case 2:
                  ballPositionArray[0] = new Point(-15000,0);
                  ballPositionArray[1] = new Point(px,0);
                  ballPositionArray[2] = new Point(px + k * ballRadius,ballRadius * j);
                  ballPositionArray[15] = new Point(px + k * ballRadius,-ballRadius * j);
                  ballPositionArray[8] = new Point(px + 2 * k * ballRadius,0);
                  ballPositionArray[5] = new Point(px + 2 * k * ballRadius,16000);
                  ballPositionArray[10] = new Point(px + 2 * k * ballRadius,16000);
                  ballPositionArray[7] = new Point(px + 3 * k * ballRadius,16000);
                  ballPositionArray[4] = new Point(px + 3 * k * ballRadius,16000);
                  ballPositionArray[9] = new Point(px + 3 * k * ballRadius,16000);
                  ballPositionArray[6] = new Point(px + 3 * k * ballRadius,16000);
                  ballPositionArray[11] = new Point(px + 4 * k * ballRadius,16000);
                  ballPositionArray[12] = new Point(px + 4 * k * ballRadius,16000);
                  ballPositionArray[13] = new Point(px + 4 * k * ballRadius,16000);
                  ballPositionArray[14] = new Point(px + 4 * k * ballRadius,16000);
                  ballPositionArray[3] = new Point(px + 4 * k * ballRadius,16000);
                  break;
               case 3:
                  ballPositionArray = setupLevelFromTemplate();
                  break;
               case 4:
                  ballPositionArray = setupLevelFromTemplate();
                  break;
               case 5:
                  ballPositionArray = setupLevelFromTemplate();
                  break;
               case 6:
                  ballPositionArray = setupLevelFromTemplate();
                  break;
               case 7:
                  ballPositionArray = setupLevelFromTemplate();
                  break;
               case 8:
                  ballPositionArray = setupLevelFromTemplate();
                  break;
               case 9:
                  ballPositionArray[0] = new Point(-15000,0);
                  ballPositionArray[1] = new Point(px,0);
                  ballPositionArray[2] = new Point(px + k * ballRadius,ballRadius * j);
                  ballPositionArray[15] = new Point(px + k * ballRadius,-ballRadius * j);
                  ballPositionArray[8] = new Point(px + 2 * k * ballRadius,0);
                  ballPositionArray[5] = new Point(px + 2 * k * ballRadius,2 * ballRadius * j);
                  ballPositionArray[10] = new Point(px + 2 * k * ballRadius,-2 * ballRadius * j);
                  ballPositionArray[7] = new Point(px + 3 * k * ballRadius,16000);
                  ballPositionArray[4] = new Point(px + 3 * k * ballRadius,16000);
                  ballPositionArray[9] = new Point(px + 3 * k * ballRadius,16000);
                  ballPositionArray[6] = new Point(px + 3 * k * ballRadius,16000);
                  ballPositionArray[11] = new Point(px + 4 * k * ballRadius,16000);
                  ballPositionArray[12] = new Point(px + 4 * k * ballRadius,16000);
                  ballPositionArray[13] = new Point(px + 4 * k * ballRadius,16000);
                  ballPositionArray[14] = new Point(px + 4 * k * ballRadius,16000);
                  ballPositionArray[3] = new Point(px + 4 * k * ballRadius,16000);
                  break;
               case 10:
                  ballPositionArray = setupLevelFromTemplate();
                  break;
               case 11:
                  ballPositionArray = setupLevelFromTemplate();
                  break;
               case 12:
                  ballPositionArray = setupLevelFromTemplate();
                  break;
               case 13:
                  ballPositionArray = setupLevelFromTemplate();
                  break;
               case 14:
                  ballPositionArray = setupLevelFromTemplate();
                  break;
               case 15:
                  ballPositionArray = setupLevelFromTemplate();
                  break;
               case 16:
                  ballPositionArray[0] = new Point(-15000,0);
                  ballPositionArray[1] = new Point(px,0);
                  ballPositionArray[2] = new Point(px + k * ballRadius,ballRadius * j);
                  ballPositionArray[15] = new Point(px + k * ballRadius,-ballRadius * j);
                  ballPositionArray[8] = new Point(px + 2 * k * ballRadius,0);
                  ballPositionArray[5] = new Point(px + 2 * k * ballRadius,2 * ballRadius * j);
                  ballPositionArray[10] = new Point(px + 2 * k * ballRadius,-2 * ballRadius * j);
                  ballPositionArray[7] = new Point(px + 3 * k * ballRadius,1 * ballRadius * j);
                  ballPositionArray[4] = new Point(px + 3 * k * ballRadius,3 * ballRadius * j);
                  ballPositionArray[9] = new Point(px + 3 * k * ballRadius,-1 * ballRadius * j);
                  ballPositionArray[6] = new Point(px + 3 * k * ballRadius,-3 * ballRadius * j);
                  ballPositionArray[11] = new Point(px + 4 * k * ballRadius,16000);
                  ballPositionArray[12] = new Point(px + 4 * k * ballRadius,16000);
                  ballPositionArray[13] = new Point(px + 4 * k * ballRadius,16000);
                  ballPositionArray[14] = new Point(px + 4 * k * ballRadius,16000);
                  ballPositionArray[3] = new Point(px + 4 * k * ballRadius,16000);
                  break;
               case 17:
                  ballPositionArray = setupLevelFromTemplate();
                  break;
               case 18:
                  ballPositionArray[0] = new Point(-15000,0);
                  ballPositionArray[1] = new Point(px,0);
                  ballPositionArray[2] = new Point(px + k * ballRadius,ballRadius * j);
                  ballPositionArray[15] = new Point(px + k * ballRadius,-ballRadius * j);
                  ballPositionArray[8] = new Point(px + 2 * k * ballRadius,0);
                  ballPositionArray[5] = new Point(px + 2 * k * ballRadius,2 * ballRadius * j);
                  ballPositionArray[10] = new Point(px + 2 * k * ballRadius,-2 * ballRadius * j);
                  ballPositionArray[7] = new Point(px + 3 * k * ballRadius,16000);
                  ballPositionArray[4] = new Point(px + 3 * k * ballRadius,16000);
                  ballPositionArray[9] = new Point(px + 3 * k * ballRadius,16000);
                  ballPositionArray[6] = new Point(px + 3 * k * ballRadius,16000);
                  ballPositionArray[11] = new Point(px + 4 * k * ballRadius,16000);
                  ballPositionArray[12] = new Point(px + 4 * k * ballRadius,16000);
                  ballPositionArray[13] = new Point(px + 4 * k * ballRadius,16000);
                  ballPositionArray[14] = new Point(px + 4 * k * ballRadius,16000);
                  ballPositionArray[3] = new Point(px + 4 * k * ballRadius,16000);
                  break;
               case 19:
                  ballPositionArray = setupLevelFromTemplate();
                  break;
               case 20:
                  ballPositionArray[0] = new Point(-15000,0);
                  ballPositionArray[1] = new Point(px,0);
                  ballPositionArray[2] = new Point(px + k * ballRadius,ballRadius * j);
                  ballPositionArray[15] = new Point(px + k * ballRadius,-ballRadius * j);
                  ballPositionArray[8] = new Point(px + 2 * k * ballRadius,0);
                  ballPositionArray[5] = new Point(px + 2 * k * ballRadius,2 * ballRadius * j);
                  ballPositionArray[10] = new Point(px + 2 * k * ballRadius,-2 * ballRadius * j);
                  ballPositionArray[7] = new Point(px + 3 * k * ballRadius,1 * ballRadius * j);
                  ballPositionArray[4] = new Point(px + 3 * k * ballRadius,3 * ballRadius * j);
                  ballPositionArray[9] = new Point(px + 3 * k * ballRadius,-1 * ballRadius * j);
                  ballPositionArray[6] = new Point(px + 3 * k * ballRadius,-3 * ballRadius * j);
                  ballPositionArray[11] = new Point(px + 4 * k * ballRadius,0);
                  ballPositionArray[12] = new Point(px + 4 * k * ballRadius,2 * ballRadius * j);
                  ballPositionArray[13] = new Point(px + 4 * k * ballRadius,-2 * ballRadius * j);
                  ballPositionArray[14] = new Point(px + 4 * k * ballRadius,4 * ballRadius * j);
                  ballPositionArray[3] = new Point(px + 4 * k * ballRadius,-4 * ballRadius * j);
                  break;
               case 21:
                  ballPositionArray[0] = new Point(-15000,0);
                  ballPositionArray[1] = new Point(px,0);
                  ballPositionArray[2] = new Point(px + k * ballRadius,ballRadius * j);
                  ballPositionArray[15] = new Point(px + k * ballRadius,-ballRadius * j);
                  ballPositionArray[8] = new Point(px + 2 * k * ballRadius,0);
                  ballPositionArray[5] = new Point(px + 2 * k * ballRadius,2 * ballRadius * j);
                  ballPositionArray[10] = new Point(px + 2 * k * ballRadius,-2 * ballRadius * j);
                  ballPositionArray[7] = new Point(px + 3 * k * ballRadius,1 * ballRadius * j);
                  ballPositionArray[4] = new Point(px + 3 * k * ballRadius,3 * ballRadius * j);
                  ballPositionArray[9] = new Point(px + 3 * k * ballRadius,-1 * ballRadius * j);
                  ballPositionArray[6] = new Point(px + 3 * k * ballRadius,-3 * ballRadius * j);
                  ballPositionArray[11] = new Point(px + 4 * k * ballRadius,0);
                  ballPositionArray[12] = new Point(px + 4 * k * ballRadius,2 * ballRadius * j);
                  ballPositionArray[13] = new Point(px + 4 * k * ballRadius,-2 * ballRadius * j);
                  ballPositionArray[14] = new Point(px + 4 * k * ballRadius,4 * ballRadius * j);
                  ballPositionArray[3] = new Point(px + 4 * k * ballRadius,-4 * ballRadius * j);
            }
            return ballPositionArray;
         };
         var setupLevelFromTemplate:Function = function():Array
         {
            var ballPositionArray:Array = null;
            var levels:* = undefined;
            var balls:* = undefined;
            var n:uint = 0;
            var ball:* = undefined;
            var index:* = undefined;
            ballPositionArray = new Array();
            levels = new levels_mc();
            levels.balls.gotoAndStop(currentLevel);
            balls = levels.balls;
            numBalls = balls.numChildren;
            for(n = 0; n < numBalls; n++)
            {
               ball = balls.getChildAt(n);
               index = int(ball.name.slice(1,3));
               if(index == 0)
               {
                  if(ball.y > 160)
                  {
                     cueBallInHand = true;
                  }
                  else
                  {
                     cueBallInHand = false;
                  }
               }
               ballPositionArray[index] = new Point(ball.x / physScale,ball.y / physScale);
            }
            balls = null;
            levels = null;
            return ballPositionArray;
         };
         var checkLevelOver:Function = function():void
         {
            var complete:* = undefined;
            var lost:* = undefined;
            var tricksRequired:Boolean = false;
            var tricksAchieved:Boolean = false;
            var message:String = null;
            complete = false;
            lost = false;
            if(foulsProhibited == true)
            {
               if(fouled == true)
               {
                  lost = true;
               }
            }
            tricksRequired = false;
            tricksAchieved = false;
            if(cannonsRequiredOn == true || banksRequiredOn == true || kicksRequiredOn == true || kissesRequiredOn == true || combosRequiredOn == true)
            {
               tricksRequired = true;
               if(cannonsRequired == 0 && banksRequired == 0 && kicksRequired == 0 && kissesRequired == 0 && combosRequired == 0)
               {
                  tricksAchieved = true;
               }
            }
            if(lost == false)
            {
               if(tricksRequired == false && ballsRemaining == 0 || tricksRequired == true && tricksAchieved == true)
               {
                  complete = true;
               }
            }
            message = "You fouled";
            if(complete == false && fouled == false)
            {
               if(timeRemainingOn == true && timeRemaining <= 0)
               {
                  lost = true;
                  message = "You ran out of time.";
               }
               if(shotsRemainingOn == true && shotsRemaining <= 0)
               {
                  lost = true;
                  message = "You ran out of shots.";
               }
               if(cannonsRequiredOn == true || kissesRequiredOn == true || combosRequiredOn == true)
               {
                  if(ballsRemaining < 2)
                  {
                     lost = true;
                     message = "You didn\'t perform the required trick shots.";
                  }
               }
               if(kicksRequiredOn == true || banksRequiredOn == true)
               {
                  if(ballsRemaining == 0)
                  {
                     lost = true;
                     message = "You didn\'t perform the required trick shots.";
                  }
               }
            }
            if(lost == true)
            {
               gameRunning = false;
               preventQuit = true;
               if(currentLevel < 21)
               {
                  showLevelFailed(message);
               }
               else
               {
                  showChallengeComplete();
               }
            }
            if(complete == true)
            {
               gameRunning = false;
               preventQuit = true;
               if(currentLevel < 21)
               {
                  showLevelComplete();
               }
               else
               {
                  showChallengeComplete();
               }
            }
         };
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         gameMode = 0;
         stageWidth = 800;
         stageHeight = 600;
         numBalls = 16;
         var frameCounter:uint = 500;
         shotNum = 0;
         var storeMouseY:Number = 0;
         power = 0;
         var maxFeather:Number = 70;
         var minFeather:Number = 5;
         aimSpeed = 0;
         aimAcc = 0;
         score = 0;
         bonus = 0;
         currentLevel = 1;
         var numLevels:uint = 20;
         shotsRemaining = 0;
         ballsRemaining = 0;
         timeRemaining = 0;
         countdownCounter = 0;
         currentTarget = 0;
         nextTarget = 0;
         cannonsRequired = 0;
         banksRequired = 0;
         kicksRequired = 0;
         kissesRequired = 0;
         combosRequired = 0;
         online = false;
         shotRunning = false;
         myGame = false;
         myTurn = false;
         receivedCoinToss = false;
         verificationReceived = false;
         receivedVerificationValue = 0;
         shotRunning = false;
         mouseIsDown = false;
         var storedMouseY:Boolean = false;
         settingPower = false;
         upKeyDown = false;
         downKeyDown = false;
         leftKeyDown = false;
         rightKeyDown = false;
         upKey2Down = false;
         downKey2Down = false;
         leftKey2Down = false;
         rightKey2Down = false;
         spaceKeyDown = false;
         shiftKeyDown = false;
         rKeyDown = false;
         var reticleOn:Boolean = false;
         gameRunning = false;
         mouseOverStrike = false;
         tuningLeft = false;
         tuningRight = false;
         cueBallInHand = false;
         pocketTweenComplete = true;
         cueTweenComplete = true;
         preventAim = false;
         fouled = false;
         hintShown = false;
         gameRunningStopped = false;
         cueCanvasHidden = false;
         guideCanvasHidden = false;
         tuningHidden = false;
         setupPaused = false;
         preventQuit = false;
         shotsRemainingOn = false;
         timeRemainingOn = false;
         pauseCountdown = false;
         bonusBallOn = false;
         requiredBallOn = false;
         foulsProhibited = false;
         hintOn = false;
         cannonsRequiredOn = false;
         banksRequiredOn = false;
         kicksRequiredOn = false;
         kissesRequiredOn = false;
         combosRequiredOn = false;
         showNextTarget = false;
         countdownWasRunning = false;
         var powerFactor:Number = 80;
         frictionFast = 0.987;
         frictionSlow = 0.97;
         frictionSpeedThreshold = 100;
         ballRadius = 900;
         pocketRadius = 2250;
         physScale = 0.01;
         minVelocity = 25;
         cushionRestitution = 0.56;
         ballRestitution = 0.94;
         shadowRadius = 3 * ballRadius * physScale;
         musicChannel = new SoundChannel();
         musicTransform = musicChannel.soundTransform;
         musicVolume = 1;
         musicOn = true;
         message = "";
         ballArray = new Array();
         lineArray = new Array();
         vertexArray = new Array();
         pocketArray = new Array();
         ballArraySim = new Array();
         ballArraySim2 = new Array();
         thisURL = stage.loaderInfo.url;
         oldAim = new Vector2D(0,0);
         initArrays();
         initMenus();
      }
   }
}
