package com.games.elevate.view
{
	import com.feathers.themes.AzureMobileTheme;
	import com.framework.assetManager.AssetManager;
	import com.framework.common.Global;
	import com.framework.core.Scene;
	import com.framework.overlays.SceneTransition;
	import com.framework.sound.SoundManager;
	import com.framework.utils.ImageUtils;
	import com.games.elevate.model.Model;
	import com.games.elevate.view.game.Balloon;
	import com.games.elevate.view.game.Game;
	import com.games.elevate.view.game.Sky;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.plugins.BezierPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	
	import starling.core.Starling;
	import starling.display.Image;
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
	import starling.utils.deg2rad;
	
	public class Tutorial extends Scene
	{
		[Embed(source="../../../../assets/elevate/particles/pdSwipe.pex", mimeType="application/octet-stream")]
		private static const _pdSwipePEX:Class;
		
		[Embed(source = "../../../../assets/elevate/particles/pdSwipe.png")]
		private static const _pdSwipePNG:Class;
		
		TweenPlugin.activate([BezierPlugin])
		
		//asset manager
		private var _assets:AssetManager;
		
		//model
		private var _model:Model;
		
		//framework components
		private var _global:Global = Global.getInstance();
		private var _transitionMgr:SceneTransition = SceneTransition.getInstance();
		
		//assets
		private var _bg:Sprite;
		private var _view:Sprite;
		private var _sky:Sky;
		private var _balloon:Balloon;
		private var _hand:Sprite;
		private var _redX:Image;

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
		private var _tutorialTimer:Timer;
		private var _targetTimer:Timer;
		
		//theme
		protected var _theme:AzureMobileTheme;
		
		//filters
		private var _stimsColorFilter:ColorMatrixFilter = new ColorMatrixFilter();
		
		//sounds
		private var _soundMgr:SoundManager = SoundManager.getInstance();
		private var _st:SoundTransform = new SoundTransform();
		
		//data
		private var _tutorialStims:Array = ["dove", "turtle", "butterfly", "crab", "butterfly"];
		private var _trialCount:int = 0;
		
		//timelinemax
		private var _swipeTimeline:TimelineMax;
		
		
		public function Tutorial()
		{
			super();
		}
		
		override public function init(model:Model, assets:AssetManager):void
		{
			_model = model;
			_assets = assets;
			
			initData();
			initAssets();
			_transitionMgr.fadeIn(1);
			startTutorial();
		}
		
		private function initData():void
		{
			_model.balloonVO.restingSpeedY = 20;
			_model.balloonVO.restingSpeedX = 5;
			
			_model.balloonVO.xSpeed = _model.balloonVO.restingSpeedX;
			_model.balloonVO.ySpeed = _model.balloonVO.restingSpeedY;
			
			_model.balloonVO.largeBoost = -2000;
			_model.balloonVO.smallBoost = -500;
			
			_model.balloonVO.boostTweenTimeLarge = 3;
			_model.balloonVO.boostTweenTimeSmall = 1;
			
			_model.balloonVO.friction = 300;
			
			//set view scale data
			_model.viewScaleLargeBoost = 0.65;
			_model.viewScaleSmallBoost = 0.95;
			
			_tutorialTimer = new Timer(1000, 1);
			_targetTimer = new Timer(1500, 1);
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
			
			_stimsContainer.x = 54;
			_stimsContainer.y = 66;
			_balloon.addChild(_stimsContainer);
			
			
			//swipe particle system
			_psSwipeXML = XML(new _pdSwipePEX());
			_psSwipeTexture = Texture.fromBitmap(new _pdSwipePNG());
			_psSwipe = new PDParticleSystem(_psSwipeXML, _psSwipeTexture);
			_psSwipe.scaleY = -1;
			addChild(_psSwipe);
			Starling.juggler.add(_psSwipe);
			
			//hand
			_hand = new Sprite();
			_hand.addChild(new Image(_assets.getTexture("hand")));
			_hand.rotation = deg2rad(-30);
			_hand.alpha = 0;
			addChild(_hand);
			
			_redX = new Image(_assets.getTexture("redX"));
			_redX.x = 0;
			_redX.y = 44;
			_redX.alpha = 0;
			_hand.addChild(_redX);
			
			//sounds
			var gameMusic1:Sound = _assets.getSound("gameMusic1");
			var gameMusic2:Sound = _assets.getSound("gameMusic2");
			_soundMgr.playSequence(Vector.<Sound>([gameMusic1, gameMusic1, gameMusic2, gameMusic2]), 99, 1);
			
		}
		
		private function startTutorial():void
		{
			this.addEventListener(TouchEvent.TOUCH, onSwipe);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_tutorialTimer.addEventListener(TimerEvent.TIMER, onTutorialTimer);
			_tutorialTimer.start();
		}
		
		private function initTrial():void
		{
			var trialStim:Image = new Image(_assets.getTexture(_tutorialStims[_trialCount]));
			trialStim.filter = _stimsColorFilter;
			
			_stimsColorFilter.reset();
			_stimsColorFilter.adjustHue((Math.random() * 2) - 1);
			_stimsColorFilter.adjustSaturation(0.25);
			_stimsColorFilter.adjustBrightness(-0.35);
			
			_stimsContainer.addChild(trialStim);
			
			_trialCount++;
			
			swipeInstruct();
		}
		
		private function swipeInstruct():void
		{
			_hand.x = 35;
			_hand.y = _global.stageHeight - 75;
			
			if(_trialCount != 3 && _trialCount != 5)
			{	
				_swipeTimeline = new TimelineMax({delay:0.25, onComplete:swipeInstruct});
				
				_swipeTimeline.insertMultiple([new TweenLite(_hand, 0.25, {alpha:1}),
					new TweenLite(_hand, 1, {bezier:[{x:_global.stageWidth/2 - 75, y:_global.stageHeight/2}, {x:_global.stageWidth - 125, y:50}]}),
					new TweenLite(_hand, 0.25, {alpha:0})],
					0,
					TweenAlign.SEQUENCE,
					0.2);	
			}
			else
			{
				withholdInstruct();
			}
		}
		
		private function withholdInstruct():void
		{
			this.removeEventListener(TouchEvent.TOUCH, onSwipe);
				
			_swipeTimeline = new TimelineMax({delay:0.25, onComplete:flashX});
			
			_swipeTimeline.insertMultiple([new TweenLite(_hand, 0.25, {alpha:1}),
				new TweenLite(_hand, 0.25, {x:55, y:_global.stageHeight - 155}),
				new TweenLite(_redX, 0.25, {alpha:1})],
				0,
				TweenAlign.SEQUENCE,
				0.2);
		}
		
		private function flashX():void
		{
			TweenMax.to(_redX, 0.75, {alpha:0, yoyo:true, repeat:3, onComplete:bigBoost, ease:Expo.easeIn});
		}
		
		private function bigBoost():void
		{
			this.addEventListener(TouchEvent.TOUCH, onSwipe);
			
			TweenLite.to(_hand, 0.5, {alpha:0});
			_model.balloonVO.ySpeed = _model.balloonVO.largeBoost;
			//_soundMgr.play(Vector.<Sound>([_assets.getSound("tCorrect")]), 1, 1.25);
			_balloon.animateBalloon(Game.CORRECT_TARGET);
			_redX.alpha = 0;
			
			if(_trialCount == 3)
			{
				scaleView(Game.CORRECT_TARGET);
			}
			else if(_trialCount == 5)
			{
				scaleView("end");	
			}
			
			clearStims();
			
		}
		
		//************** Event Handlers *****************//
		
		private function onTutorialTimer(e:TimerEvent):void
		{
			initTrial();
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
			
		}
		
		private function onSwipe(e:TouchEvent):void
		{
			var touchBegan:Touch = e.getTouch(this, TouchPhase.BEGAN);
			var touchMoved:Touch = e.getTouch(this, TouchPhase.MOVED);
			var touchEnded:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			if(touchBegan)
			{
				_psSwipe.start();
				_hand.alpha = 0;
				_swipeTimeline.kill();
			}
			if(touchMoved)
			{
				_psSwipe.emitterX = touchMoved.globalX;
				_psSwipe.emitterY = -touchMoved.globalY;
			}
			
			if(touchEnded)
			{
				_model.touchEndedY = touchEnded.globalY;		
				_psSwipe.stop();
				
				switch(_trialCount)
				{
					case 1:
						_model.balloonVO.ySpeed = _model.balloonVO.smallBoost;
						_balloon.animateBalloon(Game.CORRECT_NON_TARGET);
						scaleView(Game.CORRECT_NON_TARGET);
						break;
					case 2:
						_model.balloonVO.ySpeed = _model.balloonVO.smallBoost;
						_balloon.animateBalloon(Game.CORRECT_NON_TARGET);
						scaleView(Game.CORRECT_NON_TARGET);
						break;
					case 3:
						
						break;
					case 4:
						_model.balloonVO.ySpeed = _model.balloonVO.smallBoost;
						_balloon.animateBalloon(Game.CORRECT_NON_TARGET);
						scaleView(Game.CORRECT_NON_TARGET);
						break;
					case 5:
					
						break;
				}
				
				clearStims();
			}
			
		}
		
		private function scaleView(mode:String):void
		{
			switch(mode)
			{
				case Game.CORRECT_NON_TARGET:
					TweenLite.to(_view, _model.balloonVO.boostTweenTimeSmall, {scaleX:_model.viewScaleSmallBoost, scaleY:_model.viewScaleSmallBoost, onComplete:onViewScaleComplete, onCompleteParams:[mode]});	
					break;
				
				case Game.CORRECT_TARGET:
					TweenLite.to(_view, _model.balloonVO.boostTweenTimeLarge, {scaleX:_model.viewScaleLargeBoost, scaleY:_model.viewScaleLargeBoost, onComplete:onViewScaleComplete,  onCompleteParams:[mode]});	
					break;
				
				case "end":
					TweenLite.to(_view, _model.balloonVO.boostTweenTimeLarge, {scaleX:_model.viewScaleLargeBoost, scaleY:_model.viewScaleLargeBoost, onComplete:onViewScaleComplete,  onCompleteParams:[mode]});	
					break;
			}
		}
		
		private function onViewScaleComplete(mode:String):void
		{
			switch(mode)
			{
				case Game.CORRECT_NON_TARGET:
					TweenLite.to(_view, _model.balloonVO.boostTweenTimeSmall, {scaleX:1, scaleY:1, onComplete:initTrial});	
					break;
				
				case Game.CORRECT_TARGET:
					TweenLite.to(_view, _model.balloonVO.boostTweenTimeLarge, {scaleX:1, scaleY:1, onComplete:initTrial});	
					break;
				
				case "end":
					TweenLite.to(_view, _model.balloonVO.boostTweenTimeLarge, {scaleX:1, scaleY:1, onComplete:transition});	
					break;
			}
		}
		
		private function clearStims():void
		{
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
			this.removeEventListener(TouchEvent.TOUCH, onSwipe);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_model.endScene();
		}
	}
}