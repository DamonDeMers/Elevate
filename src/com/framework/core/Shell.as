package com.framework.core
{
	import com.feathers.themes.AzureMobileTheme;
	import com.framework.assetManager.AssetManager;
	import com.framework.overlays.SceneTransition;
	import com.games.elevate.model.Model;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Shell extends Sprite
	{
		//asset manager
		private var _assets:AssetManager;
		private var _transitionMgr:SceneTransition = SceneTransition.getInstance();
		
		//layers
		private var _bg:Sprite;
		private var _sceneLayer:Sprite;
		private var _transitionLayer:Sprite;
		
		//theme
		protected var _theme:AzureMobileTheme;
		
		//data
		private var _model:Model;
		
		//scene
		private var _scene:Scene;
		
		
		public function Shell()
		{
			super();
		}
		
		public function init(model:Model, assets:AssetManager, bgTexture:Texture):void
		{
			this._theme = new AzureMobileTheme(this.stage);
		
			_model = model;
			_assets = assets;
			
			_bg = new Sprite();
			_bg.addChild(new Image(bgTexture));
			_bg.flatten();
			addChild(_bg);
			
			_sceneLayer = new Sprite();
			addChild(_sceneLayer);
			
			_transitionLayer = new Sprite();
			addChild(_transitionLayer);
			
			_transitionMgr.init(_transitionLayer);
			
			_model.addEventListener(Model.UPDATE, onModelUpdate);
		}
		
		private function onModelUpdate(e:Event):void
		{
			var mode:String = e.data.mode;
			
			switch(mode)
			{
				case Model.INIT_GAME:
					_model.scheduleCount++;
					break;
				
				case Model.NEXT_SCENE: 
					var sceneName:String = getQualifiedClassName(_model.schedule[_model.scheduleCount]);
					var Scene:Class = getDefinitionByName(sceneName) as Class;
					
					_scene = new Scene();
					_sceneLayer.addChild(_scene);
					_scene.init(_model, _assets);
					break;
				
				case Model.END_SCENE:
					_sceneLayer.removeChild(_scene);
					_model.scheduleCount++;
					break;
				
				case Model.END_GAME:
					
					break;
			}
		}
	}
}