package fr.kapit.lab.demo.managers
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import fr.kapit.diagrammer.Diagrammer;
	import fr.kapit.diagrammer.base.IDiagramLink;
	import fr.kapit.lab.demo.data.NetworkLinkModel;
	import fr.kapit.lab.demo.renderer.InfrastructureLinkDecoratorRenderer;
	import fr.kapit.layouts.model.Node;
	import fr.kapit.visualizer.Visualizer;
	
	public class DataManager
	{
		/* *
		* Attributes
		*******/
		[Bindable]
		public var diagrammer:Diagrammer;
		protected var timer:Timer;
		protected var realTimeStarted:Boolean=true;
		
		/* *
		* Public methods
		*******/
		
		public function setInitialLinkColor():void
		{
			var dataModelMap:Dictionary = diagrammer.dataModelMap;
			var link:IDiagramLink;
			var  oldValue:int;
			for each (link in dataModelMap)
			{
				 link.linkStyle.lineColor=(link.decorator.itemRenderer as InfrastructureLinkDecoratorRenderer).colorValue;
			}
		}
		public function resetLineStyle():void
		{
			var dataModelMap:Dictionary = diagrammer.dataModelMap;
			var link:IDiagramLink;
			for each (link in dataModelMap)
			{
				NetworkLinkModel(link.dataModel).bandwidthUsagePercentage=0;
				link.linkStyle.lineColor=0x999999;
			}
			
		}
		public function startRealTimeUpdate():void
		{
			  if (!timer)
			  {
				   timer = new Timer(1000,0);
			  }
			  timer.start();
			  timer.addEventListener(TimerEvent.TIMER, handleTimerDelay);
		}
		
		/* *
		* Timer Handlers
		*******/
		
		protected function handleTimerDelay(event:TimerEvent):void
		{
			if (!timer)
			{
			   return;
			}
			var link:IDiagramLink;
			var dataModelMap:Dictionary = diagrammer.dataModelMap;
			var oldValue:int;
			var newValue:int;
			var dataModel:NetworkLinkModel;
			
			var node:Node;
			
			for each (link in dataModelMap)
			{
				
				dataModel = NetworkLinkModel(link.dataModel);
				oldValue = dataModel.bandwidthUsagePercentage;
				newValue = oldValue + (15 - Math.random()*30);
				if (newValue>100)
				{
				   	newValue = 100;
				}
				else if (newValue<0)
				{
					newValue = 0;
				}
				dataModel.bandwidthUsagePercentage = newValue;
				if (link.decorator && link.decorator.itemRenderer)
				{
					link.linkStyle.lineColor=(link.decorator.itemRenderer as InfrastructureLinkDecoratorRenderer).colorValue;
				}
			}
		}
		
		protected function stopRealTimeUpdate():void
		{
			if (!timer)
			{
			   return;
			}
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, handleTimerDelay);
			
		}
	}
}