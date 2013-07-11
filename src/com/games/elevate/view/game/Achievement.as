package com.games.elevate.view.game
{
	import com.framework.assetManager.AssetManager;
	import com.framework.common.Global;
	import com.games.elevate.model.Model;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.BezierPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.deg2rad;

	TweenPlugin.activate([AutoAlphaPlugin, BezierPlugin])
	
	public class Achievement extends Sprite
	{
		//achievement types
		public static const TYPE_TWENTY_CONSECUTIVE:String = "typeTwentyConsecutive";
		public static const TYPE_FORTY_CONSECUTIVE:String = "typeFortyConsecutive";
		public static const TYPE_SIXTY_CONSECUTIVE:String = "typeSixtyConsecutive";
		public static const TYPE_PERFECT_GAME:String = "typePerfectGame"; // TODO:  Add a max_num_stims or something equivilent to the model to reference here
		
		//achievement criteria
		public static const TWENTY_CONSECUTIVE:int = 2;
		public static const FORTY_CONSECUTIVE:int = 4;
		public static const SIXTY_CONSECUTIVE:int = 6;
		public static const PERFECT_GAME:String = "PerfectGame"; // TODO:  Add a max_num_stims or something equivilent to the model to reference here
		
		//event types
		public static const BEGIN:String = "achievementBegin";
		public static const END:String = "achievementEnd";
		public static const TUTORIAL_BEGIN:String = "achievementTutorialBegin";
		public static const TUTORIAL_END:String = "achievementTutorialEnd";
		
		//asset manager
		private var _assets:AssetManager;
		
		//model
		private var _model:Model;
		
		//assets
		private var _mainStar:Sprite;
		private var _rewardBanner:Sprite;  //TODO:  Make this banner dynamic so that it becomes more ordaned as the achievements increase (i.e. banner turns purple at 40 and adds some stripes, becomes red at 60 and adds tassles, etc)
		private var _smallStarContainer:Sprite;
		private var _starBurstContainer:Sprite;
		private var _hand:Sprite;
		
		//text
		private var _starText:TextField;
		private var _bannerText:TextField;
		
		//timeline
		private var _achievmentTutorialTimeline:TimelineMax;
		
		//framework components
		private var _global:Global = Global.getInstance();
		
		
		public function Achievement(model:Model, assets:AssetManager)
		{
			_model = model;
			_assets = assets;
			
			initData();
			initListeners();
			init();
		}
		
		private function initData():void
		{
			_model.achievementTutorialComplete = false;
			_model.starPositionEnd = [new Point(-140, 8), new Point(-163, -66), new Point(-115, -126), new Point(-38, -160), new Point(7, -120), new Point(23, -62), new Point(27, 8)];
			_model.starPositionStart = [new Point(-60, -20), new Point(-68, -38), new Point(-54, -55), new Point(-40, -52), new Point(-52, -40), new Point(-56, -26), new Point(-64, -24)];
		}
		
		private function initListeners():void
		{
			_model.addEventListener(Model.UPDATE, onModelUpdate);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function init():void
		{
			_smallStarContainer = new Sprite();
			
			for(var i:int = 0; i < 7; i++)
			{
				var starStr:String = "star" + String(i + 1);
				var star:Image = new Image(_assets.getTexture(starStr));
				
				star.visible = false;
				star.x = _model.starPositionStart[i].x;
				star.y = _model.starPositionStart[i].y;
				_smallStarContainer.addChild(star);
			}
			
			addChild(_smallStarContainer);
			
			_mainStar = new Sprite();
			_mainStar.addChild(new Image(_assets.getTexture("mainStar")));
			_mainStar.pivotX = _mainStar.width/2;
			_mainStar.pivotY = _mainStar.height/2;
			_mainStar.scaleX = _mainStar.scaleY = 0.5;
			_mainStar.visible = false;
			_mainStar.touchable = false;
			addChild(_mainStar);
			
			_starText = new TextField(60, 60, "20", "LaoMN", 40, 0xCECECE);
			_starText.x = 74
			_starText.y = 90
			_mainStar.addChild(_starText);
			
			_rewardBanner = new Sprite();
			_rewardBanner.addChild(new Image(_assets.getTexture("rewardBanner")));
			_rewardBanner.pivotX = _rewardBanner.width/2;
			_rewardBanner.pivotY = _rewardBanner.height/2 - 135;
			_rewardBanner.scaleX = _rewardBanner.scaleY = 0.5;
			_rewardBanner.visible = false;
			_rewardBanner.touchable = false;
			addChild(_rewardBanner);
			
			_starBurstContainer = new Sprite();
			_starBurstContainer.touchable = false;
			addChild(_starBurstContainer);
			
			_hand = new Sprite();
			_hand.addChild(new Image(_assets.getTexture("hand")));
			_hand.rotation = deg2rad(85);
			_hand.alpha = 0;
			_hand.visible = false;
			_hand.touchable = false;
			addChild(_hand);
		}
		
		
		
		//***************** Private Methods *********************//
		/*
		private function showAchievement():void
		{
			var tweenTime:Number = 1.5;
			
			TweenLite.to(_mainStar, tweenTime, {autoAlpha:1, scaleX:1, scaleY:1, rotation:deg2rad(360), ease:Elastic.easeOut});  //rotation:deg2rad(360)
			TweenLite.to(_rewardBanner, tweenTime, {delay:0.25, autoAlpha:1, scaleX:1, scaleY:1, ease:Elastic.easeOut, onComplete:onShowComplete});
			
		}
		
		private function onShowComplete():void
		{
			var tweenTime:Number = 0.75;
			
			TweenLite.to(_mainStar, tweenTime, {autoAlpha:0, scaleX:0.5, scaleY:0.5, ease:Elastic.easeIn});
			TweenLite.to(_rewardBanner, tweenTime, {delay:0.15, autoAlpha:0, scaleX:0.5, scaleY:0.5, ease:Elastic.easeIn, onComplete:onExit});
		}
		
		
		private function onExit():void
		{
			_mainStar.scaleX = _mainStar.scaleY = 0.5;
			_rewardBanner.scaleX = _rewardBanner.scaleY = 0.5;
			
			if(_model.achievementTutorialComplete == false)
			{
				showAchievementTutorial();
				dispatchEvent(new AchievementEvent(AchievementEvent.TUTORIAL_BEGIN, _model.currentAchievement, true));
			} 
			else
			{
				dispatchEvent(new AchievementEvent(AchievementEvent.ACHIEVEMENT_END, _model.currentAchievement, true));	
			}
			
		}
		
		private function smallStarReveal():void
		{
			var delay:Number = 0;
			
			for(var i:int = 0; i < _smallStarContainer.numChildren; i++)
			{
				var star:Image = _smallStarContainer.getChildAt(i) as Image;
				
				star.visible = true;
				TweenLite.to(star, 1.5, {delay:delay, x:_model.starPositionEnd[i].x, y:_model.starPositionEnd[i].y, ease:Elastic.easeInOut});
				delay += 0.1;
			}
		}
		*/
		
		private function showStarBurst():void
		{
			var len:int = 120;
			for(var i:int = 0; i < len; i++)
			{
				var star:Image = new Image(_assets.getTexture("mainStar"));
				var ranX:Number = (Math.random() * _global.stageWidth * 2) - _global.stageWidth/2;
				var ranY:Number = (Math.random() * _global.stageHeight * 2) - _global.stageHeight/2;
				star.pivotX = star.width/2;
				star.pivotY = star.height/2;
				star.x = _global.stageWidth/2;
				star.y = _global.stageHeight/2;
				star.scaleX = star.scaleY = 0.05;
				_starBurstContainer.addChild(star);
				
				
				TweenLite.to(star, 1, {alpha:0, x:ranX, y:ranY, scaleX:0.25, scaleY:0.25, rotation:deg2rad(360), onComplete:removeStar, onCompleteParams:[star]}); 
			}
		}
		
		private function removeStar(star:Image):void
		{
			_starBurstContainer.removeChild(star);
			
			if(_starBurstContainer.numChildren == 0)
			{
				if(_model.achievementTutorialComplete == false)
				{
					showAchievementTutorial();
					dispatchEventWith(TUTORIAL_BEGIN, true, _model.currentAchievement);	
				}
				else
				{
					dispatchEventWith(END, true, _model.currentAchievement);
				}
				
			}
		}
		
		private function showAchievementTutorial():void
		{	
			_hand.x = _global.stageWidth/2 + 50;
			_hand.y = _global.stageHeight - 100;
			
			_achievmentTutorialTimeline = new TimelineMax({delay:0.5, onComplete:showAchievementTutorial});
			
			_achievmentTutorialTimeline.insertMultiple([new TweenLite(_hand, 0.25, {autoAlpha:1}),
				new TweenLite(_hand, 1, {bezier:[{x:_global.stageWidth - 75, y:_global.stageHeight - 120}, {x:_global.stageWidth - 22, y:_global.stageHeight - 80}]}),
				new TweenLite(_hand, 0.1, {scaleX:0.95, scaleY:0.95}),
				new TweenLite(_hand, 0.1, {scaleX:1, scaleY:1}),
				new TweenLite(_hand, 0.25, {autoAlpha:0})],
				0,
				TweenAlign.SEQUENCE,
				0.2);	
		}
	
		private function checkForAcheivement():void
		{
			var index:int = _model.achievementCriteria.indexOf(_model.consecutiveCorrect);
			var matchVal:int = _model.achievementCriteria[index];
			
			switch(matchVal)
			{
				case TWENTY_CONSECUTIVE:
					showStarBurst();
					_model.achievementCriteria.splice(index, 1);
					_model.currentAchievement = TYPE_TWENTY_CONSECUTIVE;
					dispatchEventWith(BEGIN, true, TYPE_TWENTY_CONSECUTIVE);
					break;
				case FORTY_CONSECUTIVE:
					showStarBurst();
					_model.achievementCriteria.splice(index, 1);
					_model.currentAchievement = TYPE_FORTY_CONSECUTIVE;
					dispatchEventWith(BEGIN, true, TYPE_FORTY_CONSECUTIVE);
					break;
				case SIXTY_CONSECUTIVE:
					showStarBurst();
					_model.achievementCriteria.splice(index, 1);
					_model.currentAchievement = TYPE_SIXTY_CONSECUTIVE;
					dispatchEventWith(BEGIN, true, TYPE_SIXTY_CONSECUTIVE);
					break;
				default:
					//not a match
					break;
			}	
			
		}
		
		private function endAchievementTutorial():void
		{
			if(_achievmentTutorialTimeline)
			{
				_achievmentTutorialTimeline.kill();
				_achievmentTutorialTimeline = null;
				TweenLite.to(_hand, 0.5, {autoAlpha:0});	
			}
			
		}
		
		//***************** Public Methods *********************//
	
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
		
		//***************** Event Handlers *********************//
		
		private function onEnterFrame(e:Event):void
		{
			
		}
		
		private function onModelUpdate(e:Event):void
		{
			var mode:String = e.data.mode;
			
			switch(mode)
			{
				case Model.TRIAL_COMPLETE:
					checkForAcheivement();
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
			
			if(_model.achievementTutorialComplete == true)
			{
				endAchievementTutorial();
			}
		}
		
		
		//***************** Clean Up *********************//
		
		private function close():void
		{
			
		}
		
	}
}