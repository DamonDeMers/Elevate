package com.games.elevate.comm
{
	import com.framework.utils.MathUtils;
	import com.furusystems.dconsole2.DConsole;
	
	public class DConsoleCommands
	{
		public function DConsoleCommands()
		{
			DConsole.createCommand("randomNumberInRange", randomNumberInRange);
		}
		
		private function randomNumberInRange(target:Number, maxVal:Number, minVal:Number, range:Number):void
		{
			trace("This is the random number: " + MathUtils.randomNumberInRange(target, maxVal, minVal, range));
		}
	}
}