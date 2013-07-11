package com.framework.assetManager
{
	import starling.events.Event;
	
	public class AssetManagerEvent extends Event
	{
		public static const ASSETS_LOADING:String = "assetsLoading";
		public static const ASSETS_COMPLETE:String = "assetsComplete"
			
		private var _progress:Number;
		private var _splashAssets:Array;
		
		public function AssetManagerEvent(type:String, progress:Number = 0, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles, data);
			_progress = progress;
		}
		
		public function get progress():Number { return _progress; }
	}
}