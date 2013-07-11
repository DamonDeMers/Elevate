package com.framework.core
{
	import com.framework.assetManager.AssetManager;
	import com.framework.core.IInteractable;
	import com.games.elevate.model.Model;
	
	import starling.display.Sprite;
	
	
	public class Scene extends Sprite implements IInteractable
	{
		public function Scene()
		{
			super();
		}
		
		public function init(model:Model, assets:AssetManager):void
		{
			//method to be implemented by the sub class.  
		}
		
		public function close():void
		{
			//method to be implemented by the sub class.  
		}
	}
}