package fr.kapit.lab.demo.event
{
	import flash.events.Event;
	
	import fr.kapit.diagrammer.events.DiagrammerEvent;
	
	public class MindMapEvent extends DiagrammerEvent
	{
		public static const SUBTOPIC_ADDED:String = "subtopicAdded";
		public static const SUBTOPIC_REMOVED:String = "subtopicRemoved";
		public static const LINK_SWAPPED:String = "linkSwaped";
		
		public function MindMapEvent(type:String, items:Array,data:Object=null, commands:Array = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, items,data,commands,bubbles, cancelable);
		}
		public override function clone():Event
		{
			return new MindMapEvent(type,items,data,commands,bubbles,cancelable);
		}
	}
}