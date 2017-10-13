package fr.kapit.lab.demo.actions
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.elements.BreakElement;
	
	import fr.kapit.data.structure.KDataItem;
	import fr.kapit.lab.demo.commands.AddSubTopicCommand;
	import fr.kapit.lab.demo.data.MindMapLinkData;
	import fr.kapit.lab.demo.data.MindMapNodeData;
	import fr.kapit.lab.demo.event.MindMapEvent;
	import fr.kapit.lab.demo.renderer.mindmap.MindMapNodeRenderer;
	import fr.kapit.lab.demo.ui.components.diagrammer.MindMapView;
	import fr.kapit.layouts.algorithms.mindmap.MindMapLayout;
	import fr.kapit.layouts.constants.RootSelectionType;
	import fr.kapit.layouts.model.Node;
	import fr.kapit.visualizer.Visualizer;
	import fr.kapit.visualizer.actions.KeyboardAction;
	import fr.kapit.visualizer.base.IItem;
	import fr.kapit.visualizer.base.ILink;
	import fr.kapit.visualizer.base.ISprite;
	import fr.kapit.visualizer.events.VisualizerEvent;

	public class MindMapShortCutAction extends KeyboardAction
	{
		public static const ID:String = "keyboardAction";
		
		// Internal
		protected static const LEFT:String = "left";
		protected static const RIGHT:String = "right";
		protected static const UP:String = "top";
		protected static const DOWN:String = "down";
		
		protected var selectedNode:ISprite;
		protected var selectedRenderer:MindMapNodeRenderer;
		protected var selectedStatus:String;
		/* ***********
		* Getters/Setters
		*************/
		
		protected var mindMap:MindMapView;
		public override function set visualizer(value:Visualizer):void
		{
			super.visualizer = value;
			mindMap = value as MindMapView;
			_visualizer.addEventListener(VisualizerEvent.ELEMENTS_SELECTION_CHANGED,onSelectionChanged)
		}
		
		public override function get id():String
		{
			return ID;
		}
		/* ***********
		* Constructor
		*************/
		public function MindMapShortCutAction()
		{
			super();
			
		}
		
		
		/* ***********
		* Constructor
		*************/
		override protected function handleKeyDown(event:KeyboardEvent):void
		{
			//event.stopImmediatePropagation();
			super.handleKeyDown(event);
			preProcessingSelection();
			switch(event.keyCode)
			{
				// when clicking on the tab key , adding new subtopic 
				case 9 :
					handleEnterKey(true,event);
					break;
				// on enter key , create a brother node
				case 13 :
					handleEnterKey(false,event);
					//event.stopImmediatePropagation();
					break;
				// backspace & delete key, delete items ,
				case 8:
				case 46:
					removeNodes();
					break;
				// escape bar key, edit texte
				case 27 :
					handleEscapeKey()
					break;
				// escpace bar key, escape the edition
				case 32:
					handleSpaceBarKey();
					break;
				// left arrow key, slecte left node
				case 37:
					handleDirectionArrow(LEFT)
					break;
				// up arrow key, select top node
				case 38:
					handleDirectionArrow(UP)
					break;
				// right arrow key, select right node
				case 39:
					handleDirectionArrow(RIGHT)
					break;
				// down arrow key, select down node
				case 40:
					handleDirectionArrow(DOWN)
					break;
				default:
					enableEditionMode(event);
					break
				
				
			}
			
		}
		/* ***********
		* Handler Methods
		*************/
		protected function onSelectionChanged(event:VisualizerEvent= null):void
		{
			preProcessingSelection();
			
		}
		/* ***********
		* Helper Methods
		*************/
		protected function enableEditionMode(event:KeyboardEvent):void
		{
			if (!selectedNode)
				return;
			selectedStatus = selectedRenderer.skin.currentState;
			if (selectedStatus == "editing")
				return
			else 
				selectedRenderer.handleActivateEditionMode(event)
		}
		// handle space bar clicked
		protected function handleSpaceBarKey():void
		{
			if (selectedRenderer)
				selectedRenderer.handleSpaceBar();
			
		}
		//handle escape key clicked
		protected function handleEscapeKey():void
		{
			if (selectedRenderer)
				selectedRenderer.handleEscKey();
			
		}	
		//handle enter key clicked
		private function handleEnterKey(isChild:Boolean,event:KeyboardEvent= null):void
		{
			if (!selectedNode)
				return;
			selectedStatus = selectedRenderer.skin.currentState;
			if (selectedStatus == "editing")
				selectedRenderer.handleEnterKey(event);
			else    
				addSubTopic(isChild);
		}
		
		
		// remove items when delete or backspace is clicked 
		protected function removeNodes():void
		{
				
			if (!selectedNode)
				return;
			selectedStatus = selectedRenderer.skin.currentState;
			if (selectedStatus == "editing")
				return
			
			if (MindMapNodeData(selectedNode.data).isRoot)
				return;
			else 
			{
				mindMap.removeSubTopic(selectedNode,true);
				mindMap.reLayout();
			}
		}
		// add new subTopic when a node is selected and enter is clicked
		protected function addSubTopic(isChild:Boolean):void
		{
			if (selectedNode)
				mindMap.addSubTopic(selectedNode, isChild); 
			
		}
		// checking the selected items 
		protected function preProcessingSelection ():void
		{
			var node:ISprite;
			var selection:Array = _visualizer.selection;
			var nodes:Array = [];
			selectedNode = null;
			selectedRenderer = null;
			selectedStatus = ""
			for each(var item:Object in selection)
			{
				if(item is ISprite)
					nodes.push(item);
			}
			if(nodes.length!=1)
				return;
			node = nodes[0];
			selectedNode = node;
			selectedRenderer = selectedNode.itemRenderer as MindMapNodeRenderer;
			selectedStatus = selectedRenderer.skin.currentState;
		}
		
		// handle direction keys clicked 
		private function handleDirectionArrow(direction:String):void
		{
			//Pre-Processing selection
			var root:ISprite;
			var node:ISprite;
			for each(node in _visualizer.nodesMap)
			{
				if(node.data.isRoot)
				{
					root = node;
					break;
				}
			}
			if(!root)
				return;
			var selection:Array = _visualizer.selection;
			var nodes:Array = [];
			for each(var item:Object in selection)
			{
				if(item is ISprite)
					nodes.push(item);
			}
			if(nodes.length!=1)
				return;
			node = nodes[0];
			selectedStatus = selectedRenderer.skin.currentState;
			if (selectedStatus == "editing")
				return
			var connections:Dictionary;
			var newNode:ISprite;
			switch ( direction)
			{
				case LEFT:
					newNode = (node.x+node.scaledWidth<=root.x || node.data.isRoot) ? getNearestChild(node, root, LEFT) : node.hierarchyParent;
					break;
				case UP:
					newNode = getNearestSibling(node,root,UP);
					break;
				case RIGHT:
					newNode = (node.x>=root.x+root.scaledWidth || node.data.isRoot) ? getNearestChild(node, root, RIGHT) : node.hierarchyParent;
					break;
				case DOWN:
					newNode = getNearestSibling(node,root,DOWN);
					break;
			}
			
			
			if(newNode)
			{
				newNode.isSelected = true;
				node.isSelected = false;
			}
		}		
		private function getNearestChild(node:ISprite, referenceNode:ISprite, direction:String):ISprite
		{
			var children:Array = node.hierarchyChildren;
			var i:uint;
			var l:uint = children.length;
			var otherNode:ISprite;
			var nearestNode:ISprite;
			var d:Number;
			var minD:Number = Number.MAX_VALUE;
			if(node.data.isRoot && l>0)
			{
				for(i=0;i<l;i++)
				{
					otherNode = children[i];
					d = (otherNode.x + otherNode.width*0.5 - node.x - node.width*0.5)*(otherNode.x + otherNode.width*0.5 - node.x - node.width*0.5)
						+(otherNode.y + otherNode.height*0.5 - node.y - node.height*0.5)*(otherNode.y + otherNode.height*0.5 - node.y - node.height*0.5)
					if ( ((direction==LEFT && otherNode.x+otherNode.scaledWidth<referenceNode.x) || (direction==RIGHT && otherNode.x>=referenceNode.x+referenceNode.scaledWidth))  
						&& d<minD)
					{
						nearestNode = otherNode;
						minD = d;
					}
				}
			}
			else if(l==0)
				nearestNode = getNearestSibling(node,referenceNode,direction);
			else
			{
				for(i=0;i<l;i++)
				{
					otherNode = children[i];
					d = (otherNode.x - node.x)*(otherNode.x - node.x)+(otherNode.y - node.y)*(otherNode.y - node.y)
					if (d<minD)
					{
						nearestNode = otherNode;
						minD = d;
					}
				}
			}
			
			return nearestNode;
		}
		
		private function getNearestSibling(node:ISprite, referenceNode:ISprite, direction:String):ISprite
		{
			if(node.data.isRoot)
				return node;
			var hierarchyParent:ISprite = node.hierarchyParent;
			var nearestNode:ISprite;
			var children:Array = hierarchyParent.hierarchyChildren;
			var l:uint = children.length;
			var directionFactor:int = direction==UP ? -1 : 1;
			var index:int;
			if(hierarchyParent.data.isRoot)
			{
				var leftNodes:Array = [];
				var rightNodes:Array = [];
				var i:uint = 0;
				var otherNode:ISprite;
				var isLeft:Boolean;
				for(i=0;i<l;i++)
				{
					otherNode = children[i];
					if(otherNode == node)
						isLeft = (hierarchyParent.x > otherNode.x);
					if(hierarchyParent.x > otherNode.x)
						leftNodes.push(otherNode);
					else
						rightNodes.push(otherNode);
				}
				leftNodes.sortOn("y",Array.NUMERIC);
				rightNodes.sortOn("y",Array.NUMERIC);
				index = (isLeft ? leftNodes.indexOf(node) : rightNodes.indexOf(node) )+directionFactor;
				nearestNode = isLeft ? leftNodes[index] : rightNodes[index];
				
			}
			else
			{
				index = children.indexOf(node)+directionFactor;
				if(index>l-1 || index<0)
					nearestNode = getNearestSibling(node.hierarchyParent,referenceNode,direction);
				else
					nearestNode = children[index];
			}
			return nearestNode;
		}
	}
}