package com.games.elevate.view.game
{
	import com.framework.assetManager.AssetManager;
	import com.framework.common.Global;
	import com.framework.sound.SoundManager;
	import com.games.elevate.model.Model;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.media.Sound;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.filters.ColorMatrixFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	TweenPlugin.activate([AutoAlphaPlugin])
	
	public class Balloon extends Sprite
	{
		[Embed(source="../../../../../assets/elevate/particles/pdCorrect.pex", mimeType="application/octet-stream")]
		private static const _pdCorrectPEX:Class;
		
		[Embed(source = "../../../../../assets/elevate/particles/pdCorrect.png")]
		private static const _pdCorrectPNG:Class;
		
		[Embed(source="../../../../../assets/elevate/particles/pdIncorrect.pex", mimeType="application/octet-stream")]
		private static const _pdIncorrectPEX:Class;
		
		[Embed(source = "../../../../../assets/elevate/particles/pdIncorrect.png")]
		private static const _pdIncorrectPNG:Class;
		
		//asset manager
		private var _assets:AssetManager;
		
		//model
		private var _model:Model;
		
		//framework components
		private var _global:Global = Global.getInstance();
		
		//assets
		private var _view:Sprite;
		private var _balloonHole:Image;
		private var _flame:MovieClip;
		private var _balloon:Image;
		private var _balloonHalf:Image;
		private var _balloonHalf2:Image;
		private var _basket:Image;
		private var _banner:Image;
		private var _rewardBanner:Sprite;
		
		//text
		private var _rewardText:TextField;
		
		//stims
		private var _ntStimsArray:Array;
		private var _target:Image;
		private var _stimsContainer:Sprite;
		
		//sounds
		private var _soundMgr:SoundManager = SoundManager.getInstance();
	
		//particle systems
		private var _psCorrect:PDParticleSystem;
		private var _psCorrectXML:XML;
		private var _psCorrectTexture:Texture;
		private var _psIncorrect:PDParticleSystem;
		private var _psIncorrectXML:XML;
		private var _psIncorrectTexture:Texture;
		
		//filters
		private var _colorFilter1:ColorMatrixFilter = new ColorMatrixFilter();
		private var _colorFilter2:ColorMatrixFilter = new ColorMatrixFilter();

		
		//TODO: Add some public static consts for the balloon animation mode.  i.e public static const NON_TARGET_CORECT:String = "nonTargetCorrect";
		public function Balloon(model:Model, assets:AssetManager, view:Sprite)
		{
			_model = model;
			_assets = assets;
			_view = view;
			
			initData();
			initListeners();
			init();
			
		}
		
		private function initData():void
		{
			//set balloon VO data
			_model.balloonVO.startingElevation = 3000;
			_model.balloonVO.currentElevation = _model.balloonVO.startingElevation;
			_model.balloonVO.targetElevation = _model.balloonVO.currentElevation;
			
			_model.balloonVO.largeBoost = -1000;
			_model.balloonVO.smallBoost = -400;
			_model.balloonVO.largeFall = 1000;
			_model.balloonVO.smallFall = 400;
			
			_model.balloonVO.restingSpeedY = 20;
			_model.balloonVO.restingSpeedX = 5;
			
			_model.balloonVO.xSpeed = _model.balloonVO.restingSpeedX;
			_model.balloonVO.ySpeed = _model.balloonVO.restingSpeedY;
			
			_model.balloonVO.boostTweenTimeLarge = 3;
			_model.balloonVO.boostTweenTimeSmall = 1;
			
			_model.balloonVO.friction = 300;
		}
		
		private function initListeners():void
		{
			_model.addEventListener(Model.UPDATE, onModelUpdate);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function init():void
		{
			//correct particle system
			_psCorrectXML = XML(new _pdCorrectPEX());
			_psCorrectTexture = Texture.fromBitmap(new _pdCorrectPNG());
			_psCorrect = new PDParticleSystem(_psCorrectXML, _psCorrectTexture);
			
			_psCorrect.x = 137;
			_psCorrect.y = 338;
			_psCorrect.scaleY = -1;
			
			addChild(_psCorrect);
			Starling.juggler.add(_psCorrect);
			
			
			//assets
			_balloonHole = new Image(_assets.getTexture("balloonHole"));
			_balloonHole.touchable = false;
			_balloonHole.x = 123;
			_balloonHole.y = 280;
			addChild(_balloonHole); 
			
			_flame = new MovieClip(_assets.getTextures("flame_"), 16);
			_flame.touchable = false;
			_flame.x = 124;
			_flame.y = 270;
			_flame.visible = false;
			_flame.stop();
			addChild(_flame); 
			
			Starling.juggler.add(_flame);
			
			_balloon = new Image(_assets.getTexture("balloon"));
			_balloon.touchable = false;
			addChild(_balloon); 
			
			_basket = new Image(_assets.getTexture("basket"));
			_basket.touchable = false;
			_basket.x = 109;
			_basket.y = 262;
			addChild(_basket);
			
			_banner = new Image(_assets.getTexture("banner"));
			_banner.touchable = false;
			_banner.pivotX = _banner.width/2;
			_banner.pivotY = _banner.height/2;
			_banner.x = 141;
			_banner.y = 124;
			addChild(_banner);
			
			_rewardBanner = new Sprite();
			_rewardBanner.addChild(new Image(_assets.getTexture("rewardBanner")));
			_rewardBanner.touchable = false;
			_rewardBanner.x = 25;
			_rewardBanner.y = 170;
			_rewardBanner.alpha = 0;
			addChild(_rewardBanner);
			
			_rewardText = new TextField(200, 80, "Test Text", "LaoMN", 14, 0xCECECE);
			_rewardText.x = 14;
			_rewardText.y = -16;
			_rewardBanner.addChild(_rewardText);
			
			//incorrect particle system
			_psIncorrectXML = XML(new _pdIncorrectPEX());
			_psIncorrectTexture = Texture.fromBitmap(new _pdIncorrectPNG());
			_psIncorrect = new PDParticleSystem(_psIncorrectXML, _psIncorrectTexture);
			
			_psIncorrect.x = 138;
			_psIncorrect.y = 90;
			_psIncorrect.scaleY = -1;
			
			addChild(_psIncorrect);
			Starling.juggler.add(_psIncorrect);
		}
		
		//****************** Public Methods *****************//
		
		public function animateBalloon(mode:String, speed:Number=1):void
		{
			switch(mode)
			{
				case "correctTarget":
					TweenLite.to(this, _model.balloonVO.boostTweenTimeLarge, {y:_model.balloonVO.origY - (75/_model.viewScaleLargeBoost), onComplete:animationComplete, onCompleteParams:[mode]});	
					_flame.visible = true;
					_flame.play();
					
					_soundMgr.play(_assets.getSound("tCorrect"));
					
					_psCorrect.maxNumParticles = 120;
					_psCorrect.speed = 260;
					_psCorrect.gravityY = -1800;
					_psCorrect.start(1);			
					break;
				
				case "correctNonTarget":
					var numParticles:Number = -speed/3;
					
					TweenLite.to(this, _model.balloonVO.boostTweenTimeSmall, {y:_model.balloonVO.origY - (25/_model.viewScaleSmallBoost), onComplete:animationComplete, onCompleteParams:[mode]});
					_flame.visible = true;
					_flame.play();
					
					_soundMgr.play(_assets.getSound("ntCorrect"));
					
					_psCorrect.maxNumParticles = numParticles;
					_psCorrect.speed = 120;
					_psCorrect.gravityY = -800;
					_psCorrect.start(_model.balloonVO.boostTweenTimeSmall/2);
					break;
				
				case "incorrectTarget":
					TweenLite.to(this, _model.balloonVO.boostTweenTimeLarge, {y:_model.balloonVO.origY + 75, onComplete:animationComplete, onCompleteParams:[mode]});	
					_psIncorrect.start(1);	
					
					_soundMgr.play(_assets.getSound("ntIncorrect"), 1, 1.25); //Note: May want to add a 'tIncorrect' that is more dramatic
					break;
				
				case "incorrectNonTarget":
					TweenLite.to(this, _model.balloonVO.boostTweenTimeSmall, {y:_model.balloonVO.origY + 25, onComplete:animationComplete, onCompleteParams:[mode]});
					_psIncorrect.start(0.25);	
					
					_soundMgr.play(_assets.getSound("ntIncorrect")); 
					break;
				
				case "powerUp":
					TweenLite.to(this, _model.balloonVO.boostTweenTimeLarge, {y:_model.balloonVO.origY - (75/_model.viewScaleLargeBoost), onComplete:animationComplete, onCompleteParams:[mode]});	
					_flame.visible = true;
					_flame.play();
					
					_soundMgr.play(_assets.getSound("tCorrect"));
					
					_psCorrect.maxNumParticles = 120;
					_psCorrect.speed = 260;
					_psCorrect.gravityY = -1800;
					_psCorrect.start(1);
					
					_model.spawnBirds = true;
					break;
			}
		}
		
		
		public function setRewardText(text:String):void
		{
			_rewardText.text = text;
		}
		
		public function pause():void
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function resume():void
		{
			if(!this.hasEventListener(Event.ENTER_FRAME))
			{
				this.addEventListener(Event.ENTER_FRAME, onEnterFrame);	
			}
		}
		
		//****************** Event Handlers *********************//
		
		private function onModelUpdate(e:Event):void
		{
			var mode:String = e.data.mode;
			
			switch(mode)
			{
				case Model.TRIAL_COMPLETE:
					
					break;
				
				case Model.ACHIEVEMENT_BEGIN:
				
					break;
				
				case Model.ACHIEVEMENT_END:
					
					break;
				
				case Model.ACHIEVEMENT_TUTORIAL_BEGIN:
					
					break;
				
				case Model.ACHIEVEMENT_TUTORIAL_END:
					
					break;
				
				case Model.PAUSE:
					_model.pause ? pause() : resume();
					break;
			}
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void
		{
			if(_model.balloonVO.ySpeed > 20)
			{
				_model.balloonVO.ySpeed -= e.passedTime * _model.balloonVO.friction;
			}
			if(_model.balloonVO.ySpeed < 20)
			{
				_model.balloonVO.ySpeed += e.passedTime * _model.balloonVO.friction; 	
			}
		}
		
		private function onAchievementBegin(e:Event):void
		{
			setRewardText("20 in a row!!");
			showAchievement();
		}
		
		private function onAchievementEnd(e:Event):void
		{
		
		}
		
		private function onAchievementTutorialBegin(e:Event):void
		{
			
		}
		
		private function onAchievementTutorialEnd(e:Event):void
		{
			animateBalloon("powerUp");
		}
		
		private function onPowerUpActivated(e:Event):void
		{
			animateBalloon("powerUp");
		}
		
		//****************** Private Methods *****************//
		
		public function showAchievement():void
		{
			TweenLite.to(_rewardBanner, 0.25, {autoAlpha:1, onComplete:removeAchievement});
		}
		
		private function removeAchievement():void
		{
			TweenLite.to(_rewardBanner, 0.25, {delay:3, autoAlpha:0});
		}
		
		private function animationComplete(mode:String):void
		{
			switch(mode)
			{
				case "correctTarget":
					TweenLite.to(this, _model.balloonVO.boostTweenTimeLarge, {y:_model.balloonVO.origY});	
					break;
				
				case "correctNonTarget":
					TweenLite.to(this, _model.balloonVO.boostTweenTimeSmall, {y:_model.balloonVO.origY});
					break;
				
				case "incorrectTarget":
					TweenLite.to(this, _model.balloonVO.boostTweenTimeLarge, {y:_model.balloonVO.origY});	
					break;
				
				case "incorrectNonTarget":
					TweenLite.to(this, _model.balloonVO.boostTweenTimeSmall, {y:_model.balloonVO.origY});
					break;
				case "powerUp":
					TweenLite.to(this, _model.balloonVO.boostTweenTimeLarge, {y:_model.balloonVO.origY});
					_model.spawnBirds = false;
					break;
			}
			
			_flame.visible = false;
			_flame.stop();
		}
	}
}