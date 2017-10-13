package fr.kapit.lab.demo.commands
{
	import flash.geom.Rectangle;
	
	import fr.kapit.lab.demo.data.MindMapLinkData;
	import fr.kapit.lab.demo.data.MindMapNodeData;
	import fr.kapit.lab.demo.ui.components.diagrammer.MindMapView;
	import fr.kapit.layouts.model.visual.IVisualGroup;
	import fr.kapit.visualizer.Visualizer;
	import fr.kapit.visualizer.base.IGroup;
	import fr.kapit.visualizer.base.IItem;
	import fr.kapit.visualizer.base.ILink;
	import fr.kapit.visualizer.base.ISprite;
	import fr.kapit.visualizer.base.ITable;
	import fr.kapit.visualizer.base.ITableCell;
	import fr.kapit.visualizer.commands.ICommand;
	
	public class AddSubTopicCommand implements ICommand
	{
		public function AddSubTopicCommand()
		{
		}
		
		private var mindMap:MindMapView;
		public function get visualizer():Visualizer
		{
			return mindMap;
		}
		public function set visualizer(value:Visualizer):void
		{
			mindMap = value as MindMapView;
		}
		
		private var _items:Array;
		public function set items(value:Array):void
		{
			_items = value;
		}
		public function get items():Array
		{
			return _items;
		}
		
		private var _oldValues:Array;
		public function set oldValues(value:Array):void
		{
			_oldValues = value;
		}
		public function get oldValues():Array
		{
			return _oldValues;
		}
		
		private var _newValues:Array;
		public function set newValues(value:Array):void
		{
			_newValues = value;
		}
		public function get newValues():Array
		{
			
			return _newValues;
		}
		
		public function reverse(isCascading:Boolean = false):void
		{
			var uid:String;
			var n:uint = _items.length;
			var i:uint
			var j:uint;
			for(i=0;i<n;++i)
			{
				uid = _items[i];
				mindMap.removeSubTopic(mindMap.nodesMap[uid]);
			}	
			
			mindMap.reLayout();
		}
	}
}