package com.games.elevate.view
{
	import com.framework.assetManager.AssetManager;
	import com.framework.common.Global;
	import com.framework.core.Scene;
	import com.framework.overlays.SceneTransition;
	import com.framework.sound.SoundManager;
	import com.games.elevate.model.Model;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.deg2rad;

	
	public class Splash extends Scene
	{
		//asset manager
		private var _assets:AssetManager;
		
		//model
		private var _model:Model;
		
		//assets
		private var _clouds:Image;
		private var _sun:Image;
		private var _sky:Image;
		private var _balloonContainer:Sprite;
		private var _balloonHole:Image;
		private var _flame:MovieClip;
		private var _balloonGlow:Image;
		private var _balloon:Image;
		private var _title:TextField;
		private var _playButton:Button;
		private var _basket:Image;

		
		//particle systems
		private var _psCorrect:PDParticleSystem;
		private var _psCorrectXML:XML;
		private var _psCorrectTexture:Texture;

		//filters
		private var _blurFilter:BlurFilter = new BlurFilter();
		
		//sounds
		private var _soundMgr:SoundManager = SoundManager.getInstance();
		
		//timeline max
		private var _animationTimeline:TimelineMax;
		
		//framework components
		private var _global:Global = Global.getInstance();
		private var _transitionMgr:SceneTransition = SceneTransition.getInstance();
		
		
		public function Splash()
		{
			super();
		}
		
		override public function init(model:Model, assets:AssetManager):void
		{
			_model = model;
			_assets = assets;
			
			//bg
			_sky = new Image(_assets.getTexture("skySplash"));
			_sky.touchable = false;
			_sky.pivotX = _sky.width / 2;
			_sky.x = _global.stageWidth / 2;
			addChild(_sky);
			
			_sun = new Image(_assets.getTexture("sunSplash"));
			_sun.touchable = false;
			_sun.pivotX = _sun.width / 2;
			_sun.pivotY = _sun.height / 2;
			_sun.x = _global.stageWidth / 2;
			addChild(_sun);
			
			_clouds = new Image(_assets.getTexture("cloudsSplash"));
			_clouds.touchable = false;
			_clouds.pivotX = _clouds.width / 2;
			_clouds.x = _global.stageWidth / 2;
			_clouds.y = _global.stageHeight - _clouds.height;
			_sun.y = _clouds.y + 130; //sky y relative to clouds
			addChild(_clouds);
			
			
			//balloon 
			_balloonContainer = new Sprite();
			
			_balloonGlow = new Image(_assets.getTexture("balloonGlow"));
			_balloonGlow.touchable = false;
			_balloonGlow.x = -60;
			_balloonGlow.y = -50;
			_balloonGlow.alpha = 0.5;
			_balloonContainer.addChild(_balloonGlow);
			
			_balloonHole = new Image(_assets.getTexture("balloonHole"));
			_balloonHole.touchable = false;
			_balloonHole.x = 123;
			_balloonHole.y = 280;
			_balloonContainer.addChild(_balloonHole); 
			
			_flame = new MovieClip(_assets.getTextures("flame_"), 16);
			_flame.touchable = false;
			_flame.x = 124;
			_flame.y = 270;
			_flame.play();
			_balloonContainer.addChild(_flame); 
			Starling.juggler.add(_flame);
			
			_balloon = new Image(_assets.getTexture("balloon"));
			_balloon.touchable = false;
			_balloonContainer.addChild(_balloon); 
			
			_basket = new Image(_assets.getTexture("basket"));
			_basket.touchable = false;
			_basket.x = 109;
			_basket.y = 262;
			_balloonContainer.addChild(_basket);
			
			_balloonContainer.rotation = deg2rad(10);
			_balloonContainer.pivotX = _balloonContainer.width/2;
			_balloonContainer.pivotY = _balloonContainer.height/2;
			_balloonContainer.scaleX = _balloonContainer.scaleY = 0.8;
			_balloonContainer.x = _global.stageWidth/2 + _balloonContainer.width/5;
			_balloonContainer.y = _global.stageHeight - 180;
			addChild(_balloonContainer);
			
			
			_title = new TextField(250, 100, "Elevate!", "LaoMN", 50, 0xCECECE);
			_title.x = 17;
			_title.y = 10;
			_title.filter = BlurFilter.createDropShadow(1.5, 0.55, 0x000000, 0.35, 1, 0.5);
			addChild(_title);
			
			_playButton = new Button(_assets.getTexture("playButton_up"), "", _assets.getTexture("playButton_down"));
			_playButton.x = _global.stageWidth - 120;
			_playButton.y = _global.stageHeight - 75;
			_playButton.filter = BlurFilter.createDropShadow();
			addChild(_playButton);
			
			_soundMgr.play(_assets.getSound("splash"), 99, 1);

			
			_playButton.addEventListener(starling.events.Event.TRIGGERED, onButtonTriggered);
			
			animateScene();
		}
		
		
		//***************** Private Methods ***********************//
		
		private function animateScene():void
		{
			var tweenTime:Number = 3;
			var tweenAmount:Number = 2;
			var tweenConst:Number = 4;
			
			_animationTimeline = new TimelineMax({repeat:1, yoyo:true, onComplete:animateScene});
			
			_animationTimeline.insertMultiple([new TweenLite(_clouds, tweenTime, {y:_clouds.y + (Math.random()*tweenAmount)+tweenConst}),
				new TweenLite(_sun, tweenTime, {rotation:deg2rad((Math.random()*tweenAmount)-tweenAmount)}),
				new TweenLite(_balloonContainer, tweenTime, {y:_balloonContainer.y - tweenAmount*4}),
				new TweenLite(_balloonGlow, tweenTime, {alpha:1})],
				0,
				TweenAlign.START,
				0.25);
		}
		
		private function onButtonTriggered(e:Event):void
		{
			transition();
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
			_animationTimeline.kill();
			_soundMgr.stop();
			_model.endScene();
		}
	}
}