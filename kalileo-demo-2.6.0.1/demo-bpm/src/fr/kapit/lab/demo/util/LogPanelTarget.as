package fr.kapit.lab.demo.util
{
	import mx.core.mx_internal;
	import mx.logging.targets.LineFormattedTarget;
	
	import spark.components.TextArea;
	import spark.utils.TextFlowUtil;

	use namespace mx_internal;
	
	public class LogPanelTarget extends LineFormattedTarget
	{
		private var _console:TextArea;
		
		public function LogPanelTarget(console:TextArea)
		{
			super();
			_console = console;
		}
		
		override mx_internal function internalLog(message:String) : void
		{			
			if(_console.text.length > 0) 
				_console.appendText("\n\n" + message);
			else
				_console.appendText(message);
		}
	}
}