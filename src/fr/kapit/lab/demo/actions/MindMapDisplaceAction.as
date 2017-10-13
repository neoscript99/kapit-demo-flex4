package fr.kapit.lab.demo.actions
{
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import fr.kapit.data.structure.KDataItem;
	import fr.kapit.lab.demo.data.MindMapLinkData;
	import fr.kapit.lab.demo.ui.components.diagrammer.MindMapView;
	import fr.kapit.layouts.constants.RootSelectionType;
	import fr.kapit.visualizer.Visualizer;
	import fr.kapit.visualizer.actions.DisplaceAction;
	import fr.kapit.visualizer.base.ILink;
	import fr.kapit.visualizer.base.ISprite;
	import fr.kapit.visualizer.utils.GeometryUtils;
	import fr.kapit.visualizer.utils.LinkUtils;

	public class MindMapDisplaceAction extends DisplaceAction
	{
		public static const ID:String = "displaceAction";
		
		
		/* ***********
		* Getters/Setters
		*************/
		
		
		public override function get id():String
		{
			return ID;
		}
		
		protected var mindMap:MindMapView;
		public override function set visualizer(value:Visualizer):void
		{
			super.visualizer = value;
			mindMap = value as MindMapView;
		}
		
		//INTERNAL
		
		protected var sourceNode:ISprite
		protected var graphRoots:Array ;
		protected var targetNodes:Array;
		
		/* ***********
		* Constructor
		*************/
		
		public function MindMapDisplaceAction()
		{
			super();
		}
		
		/* ***********
		* Overriden Methods
		*************/
		
		override protected function handleMouseMove(event:MouseEvent):void
		{
			super.handleMouseMove(event);
			var g:Graphics = _visualizer.actionsLayer.graphics;
			targetNodes = findSprites(_elementsToDisplace);
			if (targetNode && targetNode.isFixed)
				return;
			sourceNode = getNearestNode(targetNodes);
			if(sourceNode)
			{
				sourceNode.isHighlighted = true;
				var targetNode:ISprite;
				for each(targetNode in targetNodes)
				{
					g.clear();
					g.lineStyle(2,0xE51010);
					var sP:Point = new Point(sourceNode.x+sourceNode.scaledWidth*0.5,sourceNode.y+sourceNode.scaledHeight*0.5);
					var tP:Point = new Point(targetNode.x+targetNode.scaledWidth*0.5,targetNode.y+targetNode.scaledHeight*0.5);
					var sPFinal:Point = GeometryUtils.intersectSegmentToRectangle(sP.x,sP.y,tP.x,tP.y,new Rectangle(sourceNode.x, sourceNode.y, sourceNode.scaledWidth, sourceNode.scaledHeight));
					var tPFinal:Point = GeometryUtils.intersectSegmentToRectangle(sP.x,sP.y,tP.x,tP.y,new Rectangle(targetNode.x, targetNode.y, targetNode.scaledWidth, targetNode.scaledHeight));
					if(sPFinal && tPFinal)
					{
						g.moveTo(sPFinal.x,sPFinal.y);
						g.lineTo(tPFinal.x,tPFinal.y);
					}
				}
			}
		}
		
		override protected function finishDrag(isChangeScopeMode:Boolean=false):void
		{
			super.finishDrag(isChangeScopeMode);
			_visualizer.actionsLayer.graphics.clear();
			if(targetNodes && sourceNode)
			{
				//Disconnecting node
				var targetNode:ISprite;
				for each(targetNode in targetNodes)
					mindMap.swapLink(sourceNode,targetNode);
				_visualizer.reLayout();
				targetNode = sourceNode = null;
			}
		}
		
		/* ***********
		* Helper Methods
		*************/
		
		protected function getNearestNode(target:Array):ISprite
		{
			var nodes:Dictionary = _visualizer.nodesMap;
			var node:ISprite;
			var pointRect:Rectangle = findElementsBounds(target);
			if (!pointRect)
				return null
			var minimalistRect:Rectangle = new Rectangle(0,0,Number.MAX_VALUE,Number.MAX_VALUE);
			var rectangle:Rectangle;
			//var pointRect:Rectangle = new Rectangle(p.getVisualBounds().x,p.y,2,2);
			var minimalistNode:ISprite;
			var i:uint = 0;
			for each(node in nodes)
			{ 
				if(target.indexOf(node)!=-1)
					continue;
				node.isHighlighted = false;
				rectangle = pointRect.union(new Rectangle(node.x,node.y,node.width, node.height));
				if((rectangle.height*rectangle.height+
					rectangle.width*rectangle.width)<
					(minimalistRect.height*minimalistRect.height+
						minimalistRect.width*minimalistRect.width))
				{
					minimalistRect = rectangle.clone();
					minimalistNode = node;
				}
			}
			
			return minimalistNode;
			
		}
	}
}