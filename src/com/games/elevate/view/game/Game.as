package com.games.elevate.view.game
{
	import com.feathers.themes.AzureMobileTheme;
	import com.framework.assetManager.AssetManager;
	import com.framework.common.Global;
	import com.framework.core.Scene;
	import com.framework.overlays.SceneTransition;
	import com.framework.sound.SoundManager;
	import com.framework.utils.ImageUtils;
	import com.framework.utils.MathUtils;
	import com.games.elevate.model.Model;
	import com.games.elevate.model.ResponseVO;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;

	
	public class Game extends Scene
	{
		
		[Embed(source="../../../../../assets/elevate/particles/pdSwipe.pex", mimeType="application/octet-stream")]
		private static const _pdSwipePEX:Class;
		
		[Embed(source = "../../../../../assets/elevate/particles/pdSwipe.png")]
		private static const _pdSwipePNG:Class;
		
		TweenPlugin.activate([AutoAlphaPlugin])
			
		//consts
		public static const CORRECT_TARGET:String = "correctTarget";
		public static const CORRECT_NON_TARGET:String = "correctNonTarget";
		public static const INCORRECT_TARGET:String = "incorrectTarget";
		public static const INCORRECT_NON_TARGET:String = "incorrectNonTarget";
		
		//trial types
		public static const COLOR:String = "color";
		public static const STIM_COUNT:String = "stimCount";
		public static const STIM_TYPE:String = "stimType";
			
		//asset manager
		private var _assets:AssetManager;
		
		//model
		private var _model:Model;
		
		//framework components
		private var _global:Global = Global.getInstance();
		private var _transitionMgr:SceneTransition = SceneTransition.getInstance();
		private var _soundMgr:SoundManager = SoundManager.getInstance();
		
		//assets
		private var _bg:Sprite;
		private var _view:Sprite;
		private var _sky:Sky;
		private var _balloon:Balloon;
		private var _focus:Sprite;
		private var _powerUps:PowerUp;
		private var _achievement:Achievement;
		
		//stims
		private var _target:Image;
		private var _stimsContainer:Sprite;
		
		//particle
		private var _psSwipe:PDParticleSystem;
		private var _psSwipeXML:XML;
		private var _psSwipeTexture:Texture;
		
		//text
		private var _elevationText:TextField;
		private var _rewardText:TextField;
		
		//timers
		private var _stimTimer:Timer;
		private var _reactionTimer:Timer;
		
		//data
		private var _responseVO:ResponseVO;
		
		//theme
		protected var _theme:AzureMobileTheme;
		
		//filters
		private var _stimsColorFilter:ColorMatrixFilter = new ColorMatrixFilter();
		
		
		
		public function Game()
		{
			super();
		}
		
		override public function init(model:Model, assets:AssetManager):void
		{
			_model = model;
			_assets = assets;
			
			startUp();
		}
		
		private function startUp():void
		{
			_transitionMgr.fadeIn(1);
			
			initData();
			initListeners();
			initAssets();
			initGame();
		}
		
		private function initData():void
		{
			//set view scale data
			_model.viewScaleLargeBoost = 0.65;
			_model.viewScaleSmallBoost = 0.95;
			
			//set stim data
			_model.ntStimsArray = ["crustacean", "parrot", "crane", "airplane", "boat", "crab", "dove", "fish", "lobster", "ray", "turtle"];
			_model.timerDelayArray = [500, 1200, 3000];
			
			//achivements
			_model.achievementCriteria = [Achievement.TWENTY_CONSECUTIVE, Achievement.FORTY_CONSECUTIVE, Achievement.SIXTY_CONSECUTIVE]; 

			//trial
			_model.maxTrials = 300;
			_model.targetFrequencyMultiplier = 11;
			_model.targetType = COLOR;
			_model.targetHue = 0.25;
		}
		
		private function initListeners():void
		{
			_model.addEventListener(Model.UPDATE, onModelUpdate);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addEventListener(TouchEvent.TOUCH, onSwipe);
		}
		
		private function initAssets():void
		{
			//bg
			_bg = new Sprite();
			_bg.addChild(new Image(_assets.getTexture("bg")));
			_bg.scaleX =  _global.stageWidth / _bg.width;
			_bg.scaleY =  _global.stageHeight / _bg.height;
			_bg.x = ImageUtils.centerStageX(_bg);
			_bg.y = ImageUtils.centerStageY(_bg);
			_bg.flatten();
			addChild(_bg);
			
			//view
			_view = new Sprite();
			addChild(_view);
			_view.pivotX = Global.getInstance().stageWidth/2;
			_view.pivotY = Global.getInstance().stageHeight/2;
			_view.x = ImageUtils.centerStageX(_view);
			_view.y = ImageUtils.centerStageY(_view);
			
			//sky
			_sky = new Sky(_model, _assets, _view);
			_sky.touchable = false;
			_view.addChild(_sky);
			
			//balloon
			_balloon = new Balloon(_model, _assets, _view);
			_balloon.touchable = false;
			_balloon.x = _model.balloonVO.origX = ImageUtils.centerStageX(_balloon);
			_balloon.y = _model.balloonVO.origY = ImageUtils.centerStageY(_balloon);
			_view.addChild(_balloon);
			
			//stims
			_stimsContainer = new Sprite();
			_stimsContainer.touchable = false;
			
			for(var i:int = 0; i < _model.ntStimsArray.length; i++)
			{
				var stim:Image = new Image(_assets.getTexture(_model.ntStimsArray[i]));
				stim.name = _model.ntStimsArray[i];
				stim.filter = _stimsColorFilter;
				stim.visible = false;
				_stimsContainer.addChild(stim);
			}
			
			_target = new Image(_assets.getTexture("butterfly"));
			_target.filter = _stimsColorFilter;
			_target.visible = false;
			_stimsContainer.addChild(_target);
			
			_stimsContainer.x = 54;
			_stimsContainer.y = 66;
			_balloon.addChild(_stimsContainer);
			
			_focus = new Sprite();
			var rect:Shape = new Shape();
			rect.graphics.beginFill(0xFFFFFF);
			rect.graphics.drawRect(0, 0, _global.stageWidth, _global.stageHeight);
			rect.graphics.endFill();
			_focus.addChild(rect);
			_focus.alpha = 0;
			_focus.touchable = false;
			addChild(_focus);
			
			//text
			_elevationText = new TextField(200, 40, "Elevation:", "LaoMN", 12, 0xCECECE);
			_elevationText.text = "Elevation: " + _model.balloonVO.startingElevation;
			_elevationText.hAlign = HAlign.LEFT;
			_elevationText.x = Global.getInstance().stageWidth - 120;
			_elevationText.y = _elevationText.height - 30;
			addChild(_elevationText);
			
			//swipe particle system
			_psSwipeXML = XML(new _pdSwipePEX());
			_psSwipeTexture = Texture.fromBitmap(new _pdSwipePNG());
			_psSwipe = new PDParticleSystem(_psSwipeXML, _psSwipeTexture);
			_psSwipe.scaleY = -1;
			addChild(_psSwipe);
			Starling.juggler.add(_psSwipe);
			
			//sounds
			var gameMusic1:Sound = _assets.getSound("gameMusic1");
			var gameMusic2:Sound = _assets.getSound("gameMusic2");
			_soundMgr.playSequence(Vector.<Sound>([gameMusic1, gameMusic1, gameMusic2, gameMusic2]), 99);
			
			
		}	
		
		private function initGame():void
		{
			initTrial();
		}
		
		private function initTrial():void
		{
			var ranTime:int = int(Math.random() * _model.timerDelayArray.length);
			
			_responseVO = new ResponseVO();
			_responseVO.trialNum = _model.trialCount;
			
			_stimTimer = new Timer(_model.timerDelayArray[ranTime], 1);
			_stimTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onStimTimer);
			_stimTimer.start();
		}
		

		//****************** Event Handlers ********************//
		
		private function onModelUpdate(e:Event):void
		{
			var mode:String = e.data.mode;
			
			switch(mode)
			{
				case Model.TRIAL_COMPLETE:
				
					break;
				
				case Model.ACHIEVEMENT_BEGIN:
					_model.pause = true;
					break;
				
				case Model.ACHIEVEMENT_END:
					_model.pause = false;
					break;
				
				case Model.ACHIEVEMENT_TUTORIAL_BEGIN:
					TweenLite.to(_focus, 0.5, {delay:0.5, autoAlpha:0.35});
					break;
				
				case Model.ACHIEVEMENT_TUTORIAL_END:
					TweenLite.to(_focus, 0.1, {autoAlpha:0});
					scaleView(CORRECT_TARGET);
					_model.pause = false;
					break;
				
				case Model.PAUSE:
					_model.pause ? pause() : resume();
					break;
			}
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void
		{	
			
			if(_model.balloonVO.currentElevation < _model.balloonVO.targetElevation)
			{
				_model.balloonVO.currentElevation += e.passedTime * _model.balloonVO.friction;
			}
			if(_model.balloonVO.currentElevation > _model.balloonVO.targetElevation)
			{
				_model.balloonVO.currentElevation -= e.passedTime * _model.balloonVO.friction;
			}
			
			_elevationText.text = "Elevation: " + _model.balloonVO.currentElevation;
		}
		
		private function onStimTimer(e:TimerEvent):void
		{
			var ranTimerIndex:int = Math.random()*_model.timerDelayArray.length;
			
			_stimTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onStimTimer);
			
			_reactionTimer = new Timer(800, 1);
			_reactionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onReactionTimerComplete);
			_reactionTimer.start();
			
			_responseVO.timerDelay = _model.timerDelayArray[ranTimerIndex];
			
			var ranStimNum:int = int(Math.random() * _model.targetFrequencyMultiplier);
			
			//filter adjust
			var stimHueNum:Number = MathUtils.randomNumberInRange(_model.targetHue, 1, -1, 0.25);
			
			_stimsColorFilter.reset();
			_stimsColorFilter.adjustHue(stimHueNum);
			_stimsColorFilter.adjustSaturation(0.25);
			_stimsColorFilter.adjustBrightness(-0.35);
			
			if(ranStimNum == 1)
			{
				_target.visible = true;
				_responseVO.stimName = "butterfly"; //will need to update this later
			} 
			else 
			{
				var ranNTName:String = _model.ntStimsArray[int(Math.random() * _model.ntStimsArray.length)];
				var ranNT:Image = _stimsContainer.getChildByName(ranNTName) as Image;
				
				_responseVO.stimName = ranNTName;
				
				ranNT.visible = true;
			}
			
			_model.prevTime = getTimer();
		}
		
		private function onSwipe(e:TouchEvent):void
		{
			var touchBegan:Touch = e.getTouch(this, TouchPhase.BEGAN);
			var touchMoved:Touch = e.getTouch(this, TouchPhase.MOVED);
			var touchEnded:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			if(touchBegan)
			{
				_model.touchBeganY = touchBegan.globalY;
				_responseVO.startSwipe = new Point(touchBegan.globalX, touchBegan.globalY);
			}
			
			if(touchMoved)
			{
				_psSwipe.start();
				_psSwipe.emitterX = touchMoved.globalX;
				_psSwipe.emitterY = -touchMoved.globalY;
			}
			
			if(touchEnded)
			{
				_model.touchEndedY = touchEnded.globalY;
				_responseVO.endSwipe = new Point(touchEnded.globalX, touchEnded.globalY);
				_psSwipe.stop();	
		
				if(_model.touchBeganY - _model.touchEndedY > 50)
				{
					if(_stimTimer.running)
					{
						return;
					}
					
					if(_target.visible) 
					{
						_model.balloonVO.ySpeed += _model.balloonVO.largeFall;
						_model.balloonVO.targetElevation -= _model.balloonVO.largeFall;
						_balloon.animateBalloon(INCORRECT_TARGET);
						scaleView(INCORRECT_TARGET);
						_model.consecutiveCorrect = 0;
						_responseVO.target = true;
						_responseVO.correct = false;
					}
					else if(!_target.visible) 
					{
						var swipeDistance:Number = _model.touchEndedY - _model.touchBeganY;
						
						_model.balloonVO.ySpeed += _model.balloonVO.smallBoost;
						_model.balloonVO.targetElevation -= _model.balloonVO.smallBoost;
						_balloon.animateBalloon(CORRECT_NON_TARGET, swipeDistance);
						scaleView(CORRECT_NON_TARGET);
						_model.consecutiveCorrect++;
						_responseVO.target = false;
						_responseVO.correct = true;
					}
					
					_reactionTimer.stop();
					
					_model.currentTime = getTimer();
					_responseVO.reactionTime = _model.currentTime - _model.prevTime;
					
					trialComplete();
				}
				
			}
			
		}
		
		private function onReactionTimerComplete(e:TimerEvent):void
		{
			_reactionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onReactionTimerComplete);
			
			if(_target.visible) 
			{
				_model.balloonVO.ySpeed += _model.balloonVO.largeBoost;
				_model.balloonVO.targetElevation -= _model.balloonVO.largeBoost;
				_balloon.animateBalloon(CORRECT_TARGET);
				scaleView(CORRECT_TARGET);
				_model.consecutiveCorrect++;
				_responseVO.target = true;
				_responseVO.correct = true;
			}
			else if(!_target.visible) 
			{
				_model.balloonVO.ySpeed += _model.balloonVO.smallFall;
				_model.balloonVO.targetElevation -= _model.balloonVO.smallFall;
				_balloon.animateBalloon(INCORRECT_NON_TARGET);
				scaleView(INCORRECT_NON_TARGET);
				_model.consecutiveCorrect = 0;
				_responseVO.target = false;
				_responseVO.correct = false;
			}
			
			trialComplete();	
		}
		
		
		//****************** Private Methods *****************//
		
		private function trialComplete():void
		{
			clearStims();
			_model.trialCount++;
			
			_model.results.push(_responseVO);
			
			if(!_model.pause && _model.trialCount < _model.maxTrials)
			{
				initTrial();	
			}
			else
			{
				transition();
			}
		}
		
		private function scaleView(mode:String):void
		{
			switch(mode)
			{
				case INCORRECT_TARGET:
					TweenLite.to(_view, _model.balloonVO.boostTweenTimeLarge, {scaleX:1, scaleY:1});
					break;
				case CORRECT_NON_TARGET:
					TweenLite.to(_view, _model.balloonVO.boostTweenTimeSmall, {scaleX:_model.viewScaleSmallBoost, scaleY:_model.viewScaleSmallBoost, 
						onComplete:onViewScaleComplete, onCompleteParams:[mode]});	
					break;
				case CORRECT_TARGET:
					TweenLite.to(_view, _model.balloonVO.boostTweenTimeLarge, {scaleX:_model.viewScaleLargeBoost, scaleY:_model.viewScaleLargeBoost, 
						onComplete:onViewScaleComplete,  onCompleteParams:[mode]});	
					break;
				case INCORRECT_NON_TARGET:
					TweenLite.to(_view, _model.balloonVO.boostTweenTimeSmall, {scaleX:1, scaleY:1});
					break;
			}
		}
		
		private function onViewScaleComplete(mode:String):void
		{
			switch(mode)
			{
				case INCORRECT_TARGET:
					break;
				case CORRECT_NON_TARGET:
					TweenLite.to(_view, _model.balloonVO.boostTweenTimeSmall, {scaleX:1, scaleY:1});	
					break;
				case CORRECT_TARGET:
					TweenLite.to(_view, _model.balloonVO.boostTweenTimeLarge, {scaleX:1, scaleY:1});	
					break;
				case INCORRECT_NON_TARGET:
					break;
			}
		}
		
		private function pause():void
		{	
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(TouchEvent.TOUCH, onSwipe);
			_stimTimer.stop();
			
		}
		
		private function resume():void
		{
			if(!this.hasEventListener(Event.ENTER_FRAME))
			{
				this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				this.addEventListener(TouchEvent.TOUCH, onSwipe);
				
				initTrial();
			}
		}
		
		private function clearStims():void
		{
			_target.visible = false;
			for(var i:int = 0; i < _stimsContainer.numChildren; i++)
			{
				_stimsContainer.getChildAt(i).visible = false;
			}
		}
		
		private function transition():void
		{
			var transitionDelay:Number = 1.5;
			
			_soundMgr.fadeOut(transitionDelay);
			_transitionMgr.fadeOut(transitionDelay);
			TweenLite.delayedCall(transitionDelay, close);
		}
		
		override public function close():void
		{
			_soundMgr.stop();
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(TouchEvent.TOUCH, onSwipe);
			_model.endScene();
		}
	}
}