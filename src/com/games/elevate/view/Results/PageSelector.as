package com.games.elevate.view.Results
{
	import com.framework.assetManager.AssetManager;
	import com.games.elevate.model.Model;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class PageSelector extends Sprite
	{
		public static const PAGE_SELECTED:String = "pageSelected";
		
		//asset manager
		private var _assets:AssetManager;
		
		//model
		private var _model:Model;
		
		//assets
		private var _selectorsContainer:Sprite;
		
		//data
		private var _currentPage:int;
		private var _pageDict:Dictionary;
		
		public function PageSelector(model:Model, assets:AssetManager)
		{
			_assets =  assets;
			_model = model;
			
			initData();
		}
		
		private function initData():void
		{
			_currentPage = 0;
			_pageDict = new Dictionary(true);
		}
		
		public function init(numPages:int = 5):void
		{
			_selectorsContainer = new Sprite();
			_selectorsContainer.name = "selectorContainer!!!";
			_selectorsContainer.addEventListener(TouchEvent.TOUCH, onTouch);
			addChild(_selectorsContainer);
			
			var selectorX:int = 0;
			
			for(var i:int = 0; i < numPages; i++)
			{
				var selector:Sprite = new Sprite();
				var activeSelection:Image = new Image(_assets.getTexture("activeSelector"));
				var inactiveSelection:Image = new Image(_assets.getTexture("inactiveSelector"));
				var selectorCircle:Image = new Image(_assets.getTexture("activeSelectorCircle"));
				
				selector.name = "selector" + i;
				_pageDict[selector] = i;
				activeSelection.name = "activeSelection";
				inactiveSelection.name = "inactiveSelection";
				selectorCircle.name = "selectorCircle";
				
				selector.addChild(activeSelection);
				selector.addChild(inactiveSelection);
				selector.addChild(selectorCircle);
				
				selector.x = selectorX;
				selectorX += 50;
				
				_selectorsContainer.addChild(selector);
			}
			
			updateSelectors();
		}
		
		
		//***************** Public Methods ********************//
		
		public function updateSelectors(currentPage:int = 0):void
		{
			var len:int = _selectorsContainer.numChildren;
			
			for(var i:int = 0; i < len; i++)
			{
				var selector:Sprite = _selectorsContainer.getChildAt(i) as Sprite;
				
				if(i == currentPage)
				{
					selector.getChildByName("activeSelection").visible = true;
					selector.getChildByName("inactiveSelection").visible = false;
					selector.getChildByName("selectorCircle").visible = true;
				}
				else
				{
					selector.getChildByName("activeSelection").visible = false;
					selector.getChildByName("inactiveSelection").visible = true;
					selector.getChildByName("selectorCircle").visible = false;
				}
				
			}
			
			_currentPage = currentPage;
		}
		
		
		//****************** Event Handlers *********************//
		
		private function onTouch(e:TouchEvent):void 
		{
			var touchEnded:Touch = e.getTouch(this, TouchPhase.ENDED);	
			var selector:Sprite = Image(e.target).parent as Sprite;
			var selectorIndex:int = _pageDict[selector];
			
			if(touchEnded)
			{
				updateSelectors(selectorIndex);
				dispatchEventWith(PAGE_SELECTED, true, selectorIndex);
			}
		}
		
		//************ Getter and Setters ***************//
		public function get currentPage():int { return _currentPage; }

	}
}