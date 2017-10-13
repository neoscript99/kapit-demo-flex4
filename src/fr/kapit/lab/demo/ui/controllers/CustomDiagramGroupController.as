package fr.kapit.lab.demo.ui.controllers
{
	import fr.kapit.diagrammer.Diagrammer;
	import fr.kapit.visualizer.base.IItem;
	import fr.kapit.visualizer.visualizer_internal;

	use namespace visualizer_internal;

	public class CustomDiagramGroupController extends CustomDiagramSpriteController
	{
		public function CustomDiagramGroupController()
		{
			super();
		}
		
		public override function set item(value:IItem):void
		{
			_item = value;
			if(_item)
			{
				_visualizer = _item.visualizer;
				automationName = 'DiagramGroupController_'+_item.itemID;
			}
		}

		
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		protected override function updateParams():void
		{
			var diag:Diagrammer = Diagrammer(_item.visualizer);
			paddingRight = diag._groupControllerPaddingRight;
			paddingLeft = diag._groupControllerPaddingLeft;
			paddingTop = diag._groupControllerPaddingTop;
			paddingBottom = diag._groupControllerPaddingBottom;
			knobLength = diag._groupControllerKnobLength;
			knobThickness = diag._groupControllerKnobThickness;
			knobAlpha = diag._groupControllerKnobAlpha;
			knobColor  = diag._groupControllerKnobColor;
			knobShape = diag._groupControllerKnobShape;
			knobContourColor = diag._groupControllerKnobBorderColor;
			knobContourAlpha = diag._groupControllerKnobBorderAlpha;
			knobContourThickness = diag._groupControllerKnobBorderThickness;
			lineColor = diag._groupControllerBorderColor;
			lineAlpha = diag._groupControllerBorderAlpha;
			lineThickness = diag._groupControllerBorderThickness;
			linePattern = diag._groupControllerBorderPatterns;
		}
	}
}