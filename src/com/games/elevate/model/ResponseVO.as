package com.games.elevate.model
{
	import flash.geom.Point;

	public class ResponseVO
	{
		//trial data
		private var _trialNum:int;
		private var _timerDelay:int;
		private var _stimName:String;
		
		//response data
		private var _reactionTime:int;
		private var _target:Boolean;
		private var _correct:Boolean;
		
		//kinetics
		private var _startSwipe:Point;
		private var _endSwipe:Point;
		
		public function ResponseVO()
		{
		}

		//trial data

		public function get trialNum():int{ return _trialNum; }
		public function set trialNum(value:int):void{ _trialNum = value; }
		
		public function get timerDelay():int { return _timerDelay; }
		public function set timerDelay(value:int):void { _timerDelay = value; }
		
		public function get stimName():String{ return _stimName; }
		public function set stimName(value:String):void{ _stimName = value; }

		//response data
		public function get reactionTime():int{ return _reactionTime; }
		public function set reactionTime(value:int):void{ _reactionTime = value; }
		
		public function get target():Boolean{ return _target; }
		public function set target(value:Boolean):void{ _target = value; }
		
		public function get correct():Boolean{ return _correct; }
		public function set correct(value:Boolean):void{ _correct = value; }
		
		
		//kinetics
		public function get startSwipe():Point{ return _startSwipe; }
		public function set startSwipe(value:Point):void{ _startSwipe = value; }
		
		public function get endSwipe():Point{ return _endSwipe; }
		public function set endSwipe(value:Point):void{ _endSwipe = value; }
	}
}