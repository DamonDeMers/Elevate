package com.games.elevate.view.Results
{
	import com.framework.assetManager.AssetManager;
	import com.framework.common.Global;
	import com.framework.core.Scene;
	import com.framework.overlays.SceneTransition;
	import com.framework.utils.ImageUtils;
	import com.games.elevate.model.Model;
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Results extends Scene
	{
		//framework components
		private var _transitionMgr:SceneTransition = SceneTransition.getInstance();
		private var _global:Global = Global.getInstance();
		
		//asset manager
		private var _assets:AssetManager;
		
		//model
		private var _model:Model;
		
		//assets
		private var _bg:Sprite;
		private var _pageContainer:Sprite;
		private var _pageSelector:PageSelector;
		
		//data
		private var _pagesVect:Vector.<Class>;
		private var _pageDict:Dictionary;
		private var _swipeTweenTime:Number;
		private var _selectorTweenTime:Number;
		private var _minSwipeDelta:Number;
		
		//touch
		private var _touchPointBegan:Point;
		private var _touchPointMoved:Point;
		private var _touchPointEnded:Point;
		
		public function Results()
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
		}
		
		private function initData():void
		{
			_pagesVect = new Vector.<Class>;
			_pagesVect.push(Page1, Page2, Page3, Page4);
			
			_pageDict = new Dictionary(true);
			
			_swipeTweenTime = 0.5;
			_selectorTweenTime = 1;
			
			_minSwipeDelta = 50;
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
			
			_pageContainer = new Sprite();
			_pageContainer.addEventListener(TouchEvent.TOUCH, onPageTouch);
			addChild(_pageContainer);
			
			var len:int = _pagesVect.length;
			var pageX:int = 0;
			for(var i:int = 0; i < len; i++)
			{
				var pageName:String = getQualifiedClassName(_pagesVect[i]);
				var page:Class = getDefinitionByName(pageName) as Class;
				var _page:* = new page(_model, _assets);
				
				_page.x = pageX;
				
				_pageDict[i] = _page;
				_pageContainer.addChild(_page);
				
				pageX += _global.stageWidth;
			}
			
			_pageSelector = new PageSelector(_model, _assets);
			_pageSelector.init(_pagesVect.length);
			_pageSelector.y = _global.stageHeight - 40;
			_pageSelector.x = ImageUtils.centerStageX(_pageSelector);
			_pageSelector.addEventListener(PageSelector.PAGE_SELECTED, onSelector);
			addChild(_pageSelector);	
		}
		
		
		//**************** Event Handlers *****************//
		
		private function onPageTouch(e:TouchEvent):void
		{
			var touchBegan:Touch = e.getTouch(this, TouchPhase.BEGAN);
			var touchMoved:Touch = e.getTouch(this, TouchPhase.MOVED);
			var touchEnded:Touch = e.getTouch(this, TouchPhase.ENDED);
			
			if(touchBegan)
			{
				_touchPointBegan = new Point(touchBegan.globalX, touchBegan.globalY);
			}
			
			if(touchMoved)
			{
				_touchPointMoved = new Point(touchMoved.globalX, touchMoved.globalY);
				_pageContainer.x -= touchMoved.previousGlobalX - touchMoved.globalX;
			}
			
			if(touchEnded)
			{
				_touchPointEnded = new Point(touchEnded.globalX, touchEnded.globalY);
				
				var swipeDelta:Number = _touchPointEnded.x -_touchPointBegan.x;
				var page:AbstractPage;
				var tweenX:int;
				
				if(swipeDelta < -_minSwipeDelta)
				{
					if(_pageSelector.currentPage < _pagesVect.length-1) 
					{
						page = _pageDict[_pageSelector.currentPage + 1];
						tweenX = -page.x;
					
						_pageSelector.updateSelectors(_pageSelector.currentPage + 1);
					}
					else 
					{
						page = _pageDict[_pageSelector.currentPage];
						tweenX = -page.x;
					}
				}
				else if(swipeDelta > _minSwipeDelta)
				{
					if(_pageSelector.currentPage > 0)
					{
						page = _pageDict[_pageSelector.currentPage - 1];
						tweenX = -page.x;
						
						_pageSelector.updateSelectors(_pageSelector.currentPage - 1);
					}
					else 
					{
						page = _pageDict[_pageSelector.currentPage];
						tweenX = -page.x;
					}
				}
				else 
				{
					page = _pageDict[_pageSelector.currentPage];
					tweenX = -page.x;
				}
				
				TweenLite.to(_pageContainer, _swipeTweenTime, {x:tweenX});
			}
		}
		
		private function onSelector(e:Event):void
		{
			var selectorIndex:int = e.data as int;
			var page:AbstractPage = _pageDict[selectorIndex];
			var tweenX:int = -page.x;
			
			TweenLite.to(_pageContainer, _selectorTweenTime, {x:tweenX, ease:Expo.easeOut});
		}
		
		override public function close():void
		{
			
		}
	}
}