package com.games.elevate.model
{
	import flash.utils.Dictionary;

	public class BalloonVO
	{	
		//speed
		private var _xSpeed:int;
		private var _ySpeed:int;
		
		//elevation data
		private var _startingElevation:int;
		private var _currentElevation:int;
		private var _targetElevation:int;
		
		//point of origin
		private var _origX:int;
		private var _origY:int;
		
		//boost
		private var _smallBoost:int;
		private var _largeBoost:int;
		private var _smallFall:int;
		private var _largeFall:int;
		
		//tween time
		private var _boostTweenTimeLarge:Number;
		private var _boostTweenTimeSmall:Number;
		
		//balloon default speeds
		private var _restingSpeedX:int;
		private var _restingSpeedY:int;
		
		//friction
		private var _friction:int;
		
		
		public function BalloonVO()
		{
		}
		
		
		//**************** Getters and Setters *******************//
		

		public function get xSpeed():int { return _xSpeed; }
		public function set xSpeed(value:int):void { _xSpeed = value; }

		public function get ySpeed():int { return _ySpeed; }
		public function set ySpeed(value:int):void { _ySpeed = value; }
		
		public function get startingElevation():int { return _startingElevation; }
		public function set startingElevation(value:int):void { _startingElevation = value; }
		
		public function get currentElevation():int { return _currentElevation; }
		public function set currentElevation(value:int):void { _currentElevation = value; }
		
		public function get targetElevation():int { return _targetElevation; }
		public function set targetElevation(value:int):void { _targetElevation = value; }
		
		public function get origX():int { return _origX; }
		public function set origX(value:int):void { _origX = value; }
		
		public function get origY():int { return _origY; }
		public function set origY(value:int):void { _origY = value; }
		
		public function get smallBoost():int { return _smallBoost; }
		public function set smallBoost(value:int):void { _smallBoost = value; }
		
		public function get largeBoost():int { return _largeBoost; }
		public function set largeBoost(value:int):void { _largeBoost = value; }
		
		public function get smallFall():int { return _smallFall; }
		public function set smallFall(value:int):void { _smallFall = value; }
		
		public function get largeFall():int { return _largeFall; }
		public function set largeFall(value:int):void { _largeFall = value; }
		
		public function get boostTweenTimeLarge():int { return _boostTweenTimeLarge; }
		public function set boostTweenTimeLarge(value:int):void { _boostTweenTimeLarge = value; }
		
		public function get boostTweenTimeSmall():int { return _boostTweenTimeSmall; }
		public function set boostTweenTimeSmall(value:int):void { _boostTweenTimeSmall = value; }
		
		public function get restingSpeedX():int { return _restingSpeedX; }
		public function set restingSpeedX(value:int):void { _restingSpeedX = value; }
		
		public function get restingSpeedY():int { return _restingSpeedY; }
		public function set restingSpeedY(value:int):void { _restingSpeedY = value; }
		
		public function get friction():int { return _friction; }
		public function set friction(value:int):void { _friction = value; }
		
	}
}