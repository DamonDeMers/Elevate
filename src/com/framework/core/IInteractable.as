package com.framework.core
{
	import com.framework.assetManager.AssetManager;
	import com.games.elevate.model.Model;

	public interface IInteractable
	{
		function init(model:Model, assets:AssetManager):void;
		function close():void;
	}
}