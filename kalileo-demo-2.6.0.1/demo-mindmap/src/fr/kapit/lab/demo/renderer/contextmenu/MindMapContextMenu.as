package fr.kapit.lab.demo.renderer.contextmenu
{
	
	import flash.events.MouseEvent;
	
	import fr.kapit.lab.demo.ui.skins.MindMapContextMenuSkin;
	
	import spark.components.Image;
	import spark.components.List;
	import spark.components.supportClasses.ListBase;
	import spark.components.supportClasses.SkinnableComponent;
	
	
	
	[SkinState("expanded")]
	[SkinState("collapsed")]
	
	public class MindMapContextMenu extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var expandCollapseButton: Image;
		
		[SkinPart(required="false")]
		public var actionsList: ListBase;
		
		protected var _isExpanded:Boolean = false;
		public function MindMapContextMenu()
		{
			super();
			setStyle("skinClass",MindMapContextMenuSkin);
		}
		
		/* ********
		* Overriden methods
		*************/
		
		override protected function getCurrentSkinState():String
		{
			return super.getCurrentSkinState();
		} 
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
			if (instance == expandCollapseButton)
				expandCollapseButton.addEventListener(MouseEvent.CLICK,onExpandCollapseClicked);
		}
		
		
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
		
		/* ********
		* Helper methods
		*************/
		private function syncStates():void
		{
			if(!skin)
				return;
			if(_isExpanded)
				skin.currentState = "expanded";
			else 
				skin.currentState = "collapsed";
		}
		
		/* ********
		* Handler methods
		*************/
		protected function onExpandCollapseClicked(event:MouseEvent):void
		{
			_isExpanded = !_isExpanded
			syncStates()
			
		}
		
		
	}
}