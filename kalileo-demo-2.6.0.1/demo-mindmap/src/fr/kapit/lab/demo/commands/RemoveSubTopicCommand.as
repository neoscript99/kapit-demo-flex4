package fr.kapit.lab.demo.commands
{
	import flash.geom.Rectangle;
	
	import fr.kapit.lab.demo.data.MindMapLinkData;
	import fr.kapit.lab.demo.data.MindMapNodeData;
	import fr.kapit.lab.demo.event.MindMapEvent;
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
	
	public class RemoveSubTopicCommand implements ICommand
	{
		public function RemoveSubTopicCommand()
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
		public var subTopicToRemove:MindMapNodeData;
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
			var subTopicDesc:Array;
			var links:Array;
			var n:uint = _items.length;
			var i:uint;
			var linkData:MindMapLinkData;
			var nodeData:MindMapNodeData;
			var sourceTopic:ISprite;
			for(i=0;i<n;++i)
			{
				subTopicDesc = _items[i];
				nodeData = subTopicDesc[0];
				links = subTopicDesc[1];
				sourceTopic = mindMap.nodesMap[MindMapNodeData(subTopicDesc[2]).uid]; //Safe code
																// Must be existing. For the first index 0, we are sure that the parent node is existing in Visualizer.
																// The hierarchy is then rebuilt and the parents have been already added.
				for each(linkData in links)
					mindMap.addSubTopic(sourceTopic,true,nodeData,linkData,false);
			}	
			
			var addCommand:AddSubTopicCommand = new AddSubTopicCommand();
			addCommand.items = [subTopicToRemove.uid];
			addCommand.visualizer = mindMap;
			mindMap.dispatchEvent(new MindMapEvent(MindMapEvent.SUBTOPIC_ADDED, [sourceTopic],null,[addCommand]));	
			
			mindMap.reLayout();
		}
	}
}