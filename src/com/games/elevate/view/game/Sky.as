package com.games.elevate.view.game
{
	import com.framework.assetManager.AssetManager;
	import com.framework.common.Global;
	import com.framework.utils.ImageUtils;
	import com.games.elevate.model.Model;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.filters.ColorMatrixFilter;
	
	public class Sky extends Sprite
	{
		//asset manager
		private var _assets:AssetManager;
		
		//model
		private var _model:Model;
		
		//framework components
		private var _global:Global = Global.getInstance();
		
		//assets
		private var _view:Sprite;
		private var _birdContainer:Sprite;
		private var _cloudContainer:Sprite;
		
		//data
		private var _birdsReset:Boolean = true;
		
		
		public function Sky(model:Model, assets:AssetManager, view:Sprite)
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
			_model.spawnBirds = false;
			_model.resetBirds = false;
		}
		
		private function initListeners():void
		{
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_model.addEventListener(Model.UPDATE, onModelUpdate);
		}
		
		private function init():void
		{
			//bird container experiment
			_birdContainer = new Sprite();
			_birdContainer.touchable = false;
			
			var birdLen:int = 30;
			for(var j:int = 0; j < birdLen; j++)
			{
				var _bird:MovieClip = new MovieClip(_assets.getTextures("bird_"), int(Math.random() * 12) + 12);
				
				var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
				colorMatrixFilter.adjustHue((Math.random() * 2) - 1);
				colorMatrixFilter.adjustSaturation(0.4);
				colorMatrixFilter.adjustBrightness(-0.8);
				
				_bird.x =  -_bird.width - (Math.random() * 1000) - 200;
				_bird.y = Math.random() * Global.getInstance().stageHeight;
				_bird.scaleX = _bird.scaleY = Math.random();
				_bird.alpha = _bird.scaleX;
				_bird.filter = colorMatrixFilter;
				_bird.play();
				_birdContainer.addChild(_bird); 
				
				Starling.juggler.add(_bird);
			}
			
			addChild(_birdContainer);
			
			//clouds
			_cloudContainer = new Sprite();
			_cloudContainer.touchable = false;
			
			var len:int = 35;
			for(var i:int = 0; i < len; i++)
			{
				var cloud:Image = new Image(_assets.getTexture("cloud"));
				var scale:Number = (Math.random() * 1) + 0.25;
				var speed:Number = Math.pow(scale, 12);
				
				cloud.name = "cloud" + String(i);
				cloud.x = ImageUtils.randomX();
				cloud.y = ImageUtils.randomY();
				cloud.scaleX = cloud.scaleY = scale;
				
				cloud.alpha = scale;
				_model.cloudDictionary[cloud] = {speedX:speed};
				
				_cloudContainer.addChild(cloud);
			}
			
			addChild(_cloudContainer);
		}
		
		private function resetBirds():void
		{
			var birdLen:int = _birdContainer.numChildren;
			
			for(var i:int = 0; i < birdLen; i++)
			{
				var _bird:MovieClip = _birdContainer.getChildAt(i) as MovieClip;
				
				_bird.x =  -_bird.width - (Math.random() * 1000) - 200;
			}
			
			_model.resetBirds = true;
		}
		
		//****************** Public Methods *****************//
		
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
		
		
		//****************** Event Handlers *****************//
		
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
			
			if(_model.spawnBirds == false && _model.resetBirds == false)
			{
				resetBirds();
			}
		}
		
		private function onEnterFrame(e:EnterFrameEvent):void
		{
			var numClouds:int = _cloudContainer.numChildren;
			
			for(var i:int = 0; i < numClouds; i++)
			{
				var cloud:Image = _cloudContainer.getChildAt(i) as Image;
				var sHeight:int = (_global.stageHeight/_view.scaleY - _global.stageHeight) / 2;
				var sWidth:int = (_global.stageWidth/_view.scaleX - _global.stageWidth) / 2;
				
				cloud.x += e.passedTime * (_model.balloonVO.xSpeed + _model.cloudDictionary[cloud].speedX);
				cloud.y -= e.passedTime * _model.balloonVO.ySpeed;
				
				if(cloud.y < -cloud.height - sHeight) //exceeds top
				{
					cloud.y = _global.stageHeight/_view.scaleY;
				}
				
				if(cloud.y > _global.stageHeight/_view.scaleY) //exceeds bottom
				{
					cloud.y = -cloud.height - sHeight;
				}
				
				if(cloud.x > _global.stageWidth/_view.scaleX)//exceeds width
				{
					cloud.x = (-cloud.width + 5) - sWidth;
				}
			}
			
			if(_model.spawnBirds == true)
			{
				
				var numBirds:int = _birdContainer.numChildren;
				for(var j:int = 0; j < numBirds; j++)
				{
					var bird:MovieClip = _birdContainer.getChildAt(j) as MovieClip;
					bird.x += e.passedTime * (800 * bird.scaleX);
					bird.y -= e.passedTime * _model.balloonVO.ySpeed;
					
					if(bird.x > _global.stageWidth/_view.scaleX) //exceeds width
					{
						//bird.x = -bird.width + 5 - sWidth;
					}
					
					if(bird.y > _global.stageHeight/_view.scaleY) //exceeds bottom
					{
						bird.y = -bird.height - sHeight;
					}
					
					if(bird.y < -bird.height - sHeight) //exceeds top
					{
						bird.y = _global.stageHeight/_view.scaleY;
					}
				}
			}	
		}
	}
}