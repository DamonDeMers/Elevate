package com.games.elevate.view
{
	import com.framework.assetManager.AssetManager;
	import com.framework.core.IInteractable;
	import com.framework.core.Scene;
	import com.framework.utils.ImageUtils;
	import com.games.elevate.model.Model;
	
	import feathers.controls.ProgressBar;
	
	import starling.core.Starling;

	
	public class Loader extends Scene implements IInteractable //This might be a part of the framework rather than a scene component
	{
		//asset manager
		private var _assets:AssetManager;
		
		//model
		private var _model:Model;
		
		//assets
		private var _progressBar:ProgressBar;
		
		
		public function Loader()
		{
			super();
		}
		
		override public function init(model:Model, assets:AssetManager):void
		{
			_model = model;
			_assets = assets;
			
			_progressBar = new ProgressBar();
			_progressBar.x = ImageUtils.centerStageX(_progressBar) - 67;
			_progressBar.y = ImageUtils.centerStageY(_progressBar);
			addChild(_progressBar);
			
			
			assets.loadQueue(function(ratio:Number):void
			{
				_progressBar.value = ratio;
				
				if (ratio == 1)
					Starling.juggler.delayCall(function():void
					{
						removeChild(_progressBar);
						
						close();
					}, 0.15);
			});	
		}
		
		override public function close():void
		{
			_model.endScene();
		}
		
	}
}