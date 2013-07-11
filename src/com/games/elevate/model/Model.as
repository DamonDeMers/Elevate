package com.games.elevate.model
{

	import com.games.elevate.view.Loader;
	import com.games.elevate.view.Splash;
	import com.games.elevate.view.Tutorial;
	import com.games.elevate.view.Results.Results;
	import com.games.elevate.view.game.Game;
	
	import flash.utils.Dictionary;
	
	import starling.events.EventDispatcher;
	
	public class Model extends EventDispatcher
	{
		//event type
		public static const UPDATE:String = "update";
		
		//trial modes
		public static const TRIAL_COMPLETE:String = "trialComplete";
		
		//scene modes
		public static const INIT_GAME:String = "initGame";
		public static const END_GAME:String = "endGame";
		public static const NEXT_SCENE:String = "nextScene";
		public static const END_SCENE:String = "endScene";
		
		//achievement modes
		public static const ACHIEVEMENT_BEGIN:String = "achievementBegin";
		public static const ACHIEVEMENT_END:String = "achievementEnd";
		public static const ACHIEVEMENT_TUTORIAL_BEGIN:String = "achievementTutorialBegin";
		public static const ACHIEVEMENT_TUTORIAL_END:String = "achievementTutorialEnd";
		
		//power up modes
		public static const POWERUP_ACTIVATED:String = "powerUpActivated";
		
		//pause
		public static const PAUSE:String = "pause";

		
		//game schedule
		private var _schedule:Vector.<Class> = new Vector.<Class>;
		private var _scheduleCount:int = -1;
		
		//game data
		private var _pause:Boolean = false;
		
		//balloon VO
		private var _balloonVO:BalloonVO = new BalloonVO;
		
		//stim data
		private var _ntStimsArray:Array = [];
		
		//timer data
		private var _timerDelayArray:Array = [];
		
		//touch data
		private var _touchBeganY:Number;
		private var _touchEndedY:Number;
	
		//cloud data
		private var _cloudDictionary:Dictionary = new Dictionary();
		
		//view data
		private var _viewScaleLargeBoost:Number;
		private var _viewScaleSmallBoost:Number;
		
		//birds bool
		private var _spawnBirds:Boolean;
		private var _resetBirds:Boolean;
		
		//trial data
		private var _targetFrequencyMultiplier:int;
		private var _maxTrials:int;
		private var _trialCount:int;
		private var _consecutiveCorrect:int;
		private var _prevTime:int;
		private var _currentTime:int;
		private var _results:Vector.<ResponseVO> = new Vector.<ResponseVO>;
		
		private var _targetHue:Number;
		private var _targetStimCount:int;
		private var _targetImage:String;
		private var _targetType:String;
		
		//power ups
		private var _maxPowerUps:int;
		private var _powerUpDict:Dictionary = new Dictionary();
		
		//achievement
		private var _achievementCriteria:Array = [];
		private var _achievementTutorialComplete:Boolean;
		private var _starPositionEnd:Array;
		private var _starPositionStart:Array;
		private var _currentAchievement:String;
		
		
		public function Model() {}
		

		public function init():void
		{
			_schedule.push(Loader, Splash, Tutorial, Game);
			
			dispatchEventWith(UPDATE, true, {mode:INIT_GAME});
		}
	
		//*************** Public Methods ****************//
		
		public function nextScene():void
		{
			dispatchEventWith(UPDATE, true, {mode:NEXT_SCENE});
		}
		
		public function endScene():void
		{
			dispatchEventWith(UPDATE, true, {mode:END_SCENE});
		}
		
		public function achievementBegin():void
		{
			dispatchEventWith(UPDATE, true, {mode:ACHIEVEMENT_BEGIN});
		}
		
		public function achievementEnd():void
		{
			dispatchEventWith(UPDATE, true, {mode:ACHIEVEMENT_END});
		}
		
		public function achievementTutorialBegin():void
		{
			dispatchEventWith(UPDATE, true, {mode:ACHIEVEMENT_TUTORIAL_BEGIN});
		}
		
		public function achievementTutorialEnd():void
		{
			dispatchEventWith(UPDATE, true, {mode:ACHIEVEMENT_END});
		}
		
		public function powerUpActivated():void
		{
			dispatchEventWith(UPDATE, true, {mode:POWERUP_ACTIVATED});
		}
		
		//************* Getters and Setters *******************//
		
		public function get schedule():Vector.<Class> { return _schedule; }
		
		public function get scheduleCount():int { return _scheduleCount; }
		public function set scheduleCount(count:int):void 
		{ 
			_scheduleCount = count; 
			dispatchEventWith(UPDATE, true, {mode:NEXT_SCENE});
		}
		
		public function get pause():Boolean { return _pause; }
		public function set pause(value:Boolean):void 
		{ 
			_pause = value;
			dispatchEventWith(UPDATE, true, {mode:PAUSE});
		}
		
		public function get balloonVO():BalloonVO { return _balloonVO; }
		public function set balloonVO(value:BalloonVO):void { _balloonVO = value; }
		
		public function get timerDelayArray():Array { return _timerDelayArray; }
		public function set timerDelayArray(value:Array):void { _timerDelayArray = value; }
		
		public function get ntStimsArray():Array { return _ntStimsArray; }
		public function set ntStimsArray(value:Array):void { _ntStimsArray = value; }

		public function get viewScaleLargeBoost():Number { return _viewScaleLargeBoost; }
		public function set viewScaleLargeBoost(value:Number):void { _viewScaleLargeBoost = value; }
		
		public function get viewScaleSmallBoost():Number { return _viewScaleSmallBoost; }
		public function set viewScaleSmallBoost(value:Number):void { _viewScaleSmallBoost = value; }
		
		public function get touchBeganY():Number { return _touchBeganY; }
		public function set touchBeganY(value:Number):void { _touchBeganY = value; }
		
		public function get touchEndedY():Number { return _touchEndedY; }
		public function set touchEndedY(value:Number):void { _touchEndedY = value; }
		
		public function get cloudDictionary():Dictionary { return _cloudDictionary; }
		public function set cloudDictionary(value:Dictionary):void { _cloudDictionary = value; }
		
		public function get consecutiveCorrect():int { return _consecutiveCorrect; }
		public function set consecutiveCorrect(value:int):void { _consecutiveCorrect = value; }
		
		public function get trialCount():int { return _trialCount; }
		public function set trialCount(value:int):void
		{
			_trialCount = value;
			dispatchEventWith(UPDATE, true, {mode:TRIAL_COMPLETE});
		}
		
		public function get targetFrequencyMultiplier():int { return _targetFrequencyMultiplier; }
		public function set targetFrequencyMultiplier(value:int):void { _targetFrequencyMultiplier = value; }
		
		public function get targetType():String { return _targetType; }
		public function set targetType(value:String):void { _targetType = value; }
		
		public function get targetImage():String { return _targetImage; }
		public function set targetImage(value:String):void { _targetImage = value; }
		
		public function get targetStimCount():int { return _targetStimCount; }
		public function set targetStimCount(value:int):void { _targetStimCount = value; }
		
		public function get targetHue():Number { return _targetHue; }
		public function set targetHue(value:Number):void { _targetHue = value; }
		
		public function get maxTrials():int { return _maxTrials; }
		public function set maxTrials(value:int):void { _maxTrials = value;}
		
		public function get prevTime():int { return _prevTime; }
		public function set prevTime(value:int):void { _prevTime = value; }
		
		public function get currentTime():int { return _currentTime; }
		public function set currentTime(value:int):void { _currentTime = value; }
		
		public function get results():Vector.<ResponseVO> { return _results; }
		public function set results(value:Vector.<ResponseVO>):void	{ _results = value;}
		
		public function get spawnBirds():Boolean { return _spawnBirds; }
		public function set spawnBirds(value:Boolean):void { _spawnBirds = value; }
		
		public function get resetBirds():Boolean { return _resetBirds; }
		public function set resetBirds(value:Boolean):void { _resetBirds = value; }
		
		public function get maxPowerUps():int { return _maxPowerUps; }
		public function set maxPowerUps(value:int):void { _maxPowerUps = value; }
		
		public function get achievementCriteria():Array { return _achievementCriteria; }
		public function set achievementCriteria(value:Array):void { _achievementCriteria = value; }
		
		public function get achievementTutorialComplete():Boolean { return _achievementTutorialComplete; }
		public function set achievementTutorialComplete(value:Boolean):void { _achievementTutorialComplete = value; }
		
		public function get starPositionStart():Array { return _starPositionStart; }
		public function set starPositionStart(value:Array):void { _starPositionStart = value; }
		
		public function get starPositionEnd():Array { return _starPositionEnd; }
		public function set starPositionEnd(value:Array):void { _starPositionEnd = value; }
		
		public function get currentAchievement():String { return _currentAchievement; }
		public function set currentAchievement(value:String):void { _currentAchievement = value; }
		
		public function get powerUpDict():Dictionary { return _powerUpDict; }
		public function set powerUpDict(value:Dictionary):void { _powerUpDict = value; }
		
	}
}