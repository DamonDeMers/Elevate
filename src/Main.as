package
{
	import com.framework.assetManager.AssetManager;
	import com.framework.common.Constants;
	import com.framework.common.Global;
	import com.framework.core.Shell;
	import com.framework.utils.StartUpUtils;
	import com.furusystems.dconsole2.DConsole;
	import com.games.elevate.comm.DConsoleCommands;
	import com.games.elevate.model.Model;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;


	[SWF(width="480", height="320", frameRate="60", backgroundColor="#000000")]
	public class Main extends Sprite
	{
		[Embed(source="assets/elevate/images/1x/bgStart.png")]
		private static var Background1x:Class;
		
		[Embed(source="assets/elevate/images/2x/bgStart.png")]
		private static var Background2x:Class;
		
		[Embed(source="assets/elevate/images/4x/bgStart.png")]
		private static var Background4x:Class;
		
		//starlig
		private var _mStarling:Starling;
		
		//gameShell
		private var _shell:Shell;
		private var _model:Model = new Model();
		
		//global
		private var _global:Global = Global.getInstance();
		private var _debug:Boolean;
		
		
		public function Main()
		{
			var aspectRatio:String = _global.orientation = Constants.PORTRAIT;
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			
			StartUpUtils.setStartupParams(stage, aspectRatio);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Starling.multitouchEnabled = true;  
			Starling.handleLostContext = !iOS; 
			
			var appDir:File = File.applicationDirectory;
			var assets:AssetManager = new AssetManager(_global.scaleFactor);
			
			assets.verbose = Capabilities.isDebugger;
			assets.enqueue(
				appDir.resolvePath("assets/elevate/fonts"),
				appDir.resolvePath("assets/elevate/sounds"),
				appDir.resolvePath("assets/elevate/images/" + _global.assetFolder)
			);
			
			var background:Bitmap = _global.scaleFactor == 1 ? new Background1x() : (stage.fullScreenWidth > 768? new Background4x: new Background2x());
			
			background.x = _global.viewPort.x;
			background.y = _global.viewPort.y;
			background.width  = _global.viewPort.width;
			background.height = _global.viewPort.height;
			background.smoothing = true;
			addChild(background);
			
			// launch Starling
			_mStarling = new Starling(Shell, stage, _global.viewPort);
			_mStarling.stage.stageWidth  = _global.stageWidth;  
			_mStarling.stage.stageHeight = _global.stageHeight;
			_mStarling.simulateMultitouch  = false;
			_mStarling.enableErrorChecking = false;
			_mStarling.showStats = true;
			
			_mStarling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
			{
				removeChild(background);
				
				var bgTexture:Texture = Texture.fromBitmap(background, false, false, _global.scaleFactor);
				
				_shell = _mStarling.root as Shell;
				_shell.init(_model, assets, bgTexture);
				_model.init();
				
				_mStarling.start();
			});
			
			NativeApplication.nativeApplication.addEventListener(
			flash.events.Event.ACTIVATE, function (e:*):void { _mStarling.start(); });
			
			NativeApplication.nativeApplication.addEventListener(
			flash.events.Event.DEACTIVATE, function (e:*):void { _mStarling.stop(); });
					
			var dConsoleCommands:DConsoleCommands = new DConsoleCommands();
			addChild(DConsole.view);
		}
		
	}
}
	