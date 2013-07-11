package com.games.elevate.view.Results
{
	import com.framework.assetManager.AssetManager;
	import com.framework.common.Global;
	import com.framework.overlays.SceneTransition;
	import com.framework.utils.ImageUtils;
	import com.games.elevate.model.Model;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class AbstractPage extends Sprite
	{
		//framework components
		private var _transitionMgr:SceneTransition = SceneTransition.getInstance();
		private var _global:Global = Global.getInstance();
		
		//asset manager
		private var _assets:AssetManager;
		
		//model
		private var _model:Model;
		
		//assets
		protected var _bgPanel:Sprite;
		
		public function AbstractPage(model:Model, assets:AssetManager)
		{
			_assets = assets;
			_model = model;
			
			init();
		}
		
		protected function init():void
		{
			_bgPanel = new Sprite();
			_bgPanel.addChild(new Image(_assets.getTexture("bgPanel")));
			_bgPanel.x = ImageUtils.centerStageX(_bgPanel);
			_bgPanel.y = 10;
			_bgPanel.flatten();
			addChild(_bgPanel);		
		}
	}
}