package fr.kapit.lab.demo.renderer.mindmap
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import fr.kapit.diagrammer.controls.DiagramSpriteController;
	import fr.kapit.diagrammer.controls.IController;
	import fr.kapit.visualizer.base.IItem;
	import fr.kapit.visualizer.base.ISprite;
	
	import spark.components.Button;
	import fr.kapit.lab.demo.renderer.contextmenu.MindMapContextMenu;
	
	public class MindMapNodeController extends DiagramSpriteController
	{
		public function MindMapNodeController()
		{
			super();
		}
		

		protected override function handleAddedToStage(event:Event):void
		{
			super.handleAddedToStage(event);
			createMenu();
		}
		protected override function handleRemovedToStage(event:Event):void
		{
			super.handleRemovedToStage(event)
			if(menu && menu.parent)
			{
				_item.visualizer.controlsLayer.removeChild(menu);
				menu=null;
			}
		}
		
		private var menu	: MindMapContextMenu;
		protected function createMenu():void
		{
			menu = new MindMapContextMenu();
		}
		
		protected function updateMenuPosition():void
		{
			if(!menu)
				return;
			menu.x = x + width*0.7;
			menu.y = y - menu.height*0.5;
			_item.visualizer.controlsLayer.addChild(menu);
		}
		public override function draw():void
		{
			super.draw();
			updateMenuPosition();
		}
		
	}
}