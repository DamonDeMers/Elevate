package com.games.elevate.view.game
{
	import com.framework.assetManager.AssetManager;
	import com.framework.common.Global;
	import com.games.elevate.model.Model;
	import com.greensock.TweenLite;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;

	
	public class PowerUp extends Sprite //Should each display object implement the interface IInteractable?  I'd like to create some cleanup function for each display object that can be handled on the close() call.
	{
		//event types
		public static const ACTIVATED:String = "activated";
		
		//asset manager
		private var _assets:AssetManager;
		
		//model
		private var _model:Model;
		
		//assets
		private var _tabContainer:Sprite = new Sprite();
		
		//framework components
		private var _global:Global = Global.getInstance();
		
		
		public function PowerUp(model:Model, assets:AssetManager)
		{
			_model = model;
			_assets = assets;
			
			initData();
			initListeners();
			init();
		}
		
		
		//******************* Private Methods *******************//
		
		private function initData():void
		{
			_model.maxPowerUps = 3;
		}
		
		private function initListeners():void
		{
			_model.addEventListener(Model.UPDATE, onModelUpdate);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function init():void
		{
			_tabContainer.addEventListener(Event.TRIGGERED, onTriggered);
			
			addChild(_tabContainer);
		}
		
		private function removeTab(tab:Button):void
		{
			_tabContainer.removeChild(tab);
			
			for(var i:int = 0; i < _tabContainer.numChildren; i ++)
			{
				var activeTab:Button = _tabContainer.getChildAt(i) as Button;
				
				TweenLite.to(activeTab, 1, {y:tab.y + 60});
			}
		}
		
		//******************* Public Methods *******************//
	
		public function showPowerUp(type:String):void
		{
			var tab:Button;
			var tabIcon:Image;
			var tabText:TextField;
			
			switch(type)
			{
				case Achievement.TYPE_TWENTY_CONSECUTIVE:
					tab = new Button(_assets.getTexture("rewardTabBoost"));
					tabIcon = new Image(_assets.getTexture("tabIconBoost"));
					tabText = new TextField(60, 20, "1000", "LaoMN", 10, 0xCECECE);
					break;
				case Achievement.TYPE_FORTY_CONSECUTIVE:
					tab = new Button(_assets.getTexture("rewardTabBoost"));
					tabIcon = new Image(_assets.getTexture("tabIconBoost"));
					tabText = new TextField(60, 20, "2000", "LaoMN", 10, 0xCECECE);
					break;
				case Achievement.TYPE_SIXTY_CONSECUTIVE:
					tab = new Button(_assets.getTexture("rewardTabBoost"));
					tabIcon = new Image(_assets.getTexture("tabIconBoost"));
					tabText = new TextField(60, 20, "3000", "LaoMN", 10, 0xCECECE);
					break;
				default:
					trace("[PowerUp]: The Power Up Type Was Not Found");
					break;
				
			}
			
			
			if(_model.powerUpDict[type] == undefined)
			{
				//icon
				tabIcon.x = 19;
				tabIcon.y = 8;
				tab.addChild(tabIcon);
				
				//text
				tabText.x = 6;
				tabText.y = 31;
				tab.addChild(tabText);
				
				//tab
				tab.x = 100;
				tab.y = -(_tabContainer.numChildren * 60);
				
				_tabContainer.addChild(tab);
				
				//dict
				_model.powerUpDict[type] = {activated:true};
				_model.powerUpDict[tab] = {boost:int(tabText.text)};
				
				//tween
				TweenLite.to(tab, 0.5, {x:0});
			}
			
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
		
		private function onModelUpdate(e:Event, data:String):void
		{
			var achievementType:String = e.data as String;
			var mode:String = e.data.mode;
			
			switch(mode)
			{
				case Model.TRIAL_COMPLETE:
					break;
				
				case Model.ACHIEVEMENT_BEGIN:
					
					break;
				
				case Model.ACHIEVEMENT_END:
					showPowerUp(achievementType);
					break;
				
				case Model.ACHIEVEMENT_TUTORIAL_BEGIN:
					showPowerUp(achievementType);
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
		
		
		private function onTriggered(e:Event):void
		{
			var tab:Button = e.target as Button;
			
			_model.balloonVO.ySpeed = -_model.powerUpDict[tab].boost;
			TweenLite.to(tab, 1, {x:100, onComplete:removeTab, onCompleteParams:[tab]});
			
			if(_model.achievementTutorialComplete == false)
			{
				_model.achievementTutorialComplete = true;
				_model.achievementTutorialEnd();
			}
			else
			{
				_model.powerUpActivated();
			}
		}
		
		
		
		//***************** Clean Up ********************//
		
		public function close():void
		{
			
		}
		
	}
}