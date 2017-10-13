package fr.kapit.lab.demo.commands
{
	import fr.kapit.lab.demo.data.MindMapLinkData;
	import fr.kapit.lab.demo.data.MindMapNodeData;
	import fr.kapit.lab.demo.ui.components.diagrammer.MindMapView;
	import fr.kapit.visualizer.Visualizer;
	import fr.kapit.visualizer.base.ILink;
	import fr.kapit.visualizer.base.ISprite;
	import fr.kapit.visualizer.commands.ICommand;

	public class SwapLinkCommand implements ICommand
	{
		public function SwapLinkCommand()
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
			var subTopicDesc:Array;
			var uid:String;
			var n:uint = _items.length;
			var i:uint
			var j:uint;
			var oldParent:ISprite;
			var newParent:ISprite;
			var target:ISprite;
			var link:ILink;
			var linkRemoved:Boolean
			for(i=0;i<n;++i)
			{
				subTopicDesc = _items;
				oldParent = visualizer.nodesMap[MindMapNodeData(subTopicDesc[0]).uid]
				newParent = visualizer.nodesMap[MindMapNodeData(subTopicDesc[1]).uid]
				target = visualizer.nodesMap[MindMapNodeData(subTopicDesc[2]).uid]
			
				for each ( link in target.inLinks)
				{
					if (link.source == newParent)
					{
						visualizer.removeLinkElement(link.itemID,true);
						linkRemoved = true;
						break;
					}
						
				}
				if ( linkRemoved)
				{
					var mindMapLinkData:MindMapLinkData = new MindMapLinkData();
					mindMapLinkData.source = oldParent.itemID;
					mindMapLinkData.target = target.itemID;
					visualizer.addLinkElement(mindMapLinkData,oldParent,target,null,-1,-1,null,null,0,false,false,true);
					visualizer.reLayout();
					linkRemoved = false
				}
					
					
			}
		}
	}
}