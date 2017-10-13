package fr.kapit.lab.demo.ui.renderers.standard
{
	import fr.kapit.diagrammer.renderers.DefaultEditorRenderer;
	import fr.kapit.visualizer.Visualizer;
	import fr.kapit.visualizer.renderers.IAnchorable;
	import fr.kapit.visualizer.utils.data.AnchorsDescriptor;
	
	import mx.styles.StyleManager;
	import mx.utils.ColorUtil;

	public class AbstractEditorRenderer extends DefaultEditorRenderer implements IAnchorable
	{
		
		public override function set data(value:Object):void
		{
			super.data = value;
			//Handling coloring
			var colorString:String =(!value || !value.hasOwnProperty("color")) ? null : value["color"];
			if(!colorString || colorString.length==0)
				return;
			var color:uint = colorString.charAt(0)=="#" ? 
				uint("0x" + colorString.substr(1)) : uint(color);
			if(!isNaN(color))
				backgroundColors=[0xFDFDFD,color];
		}
		
		/* *********
		* IAnchorable interface
		**************/
		
		protected var _anchorsDescriptor:AnchorsDescriptor
		public function get anchors():AnchorsDescriptor
		{
			return _anchorsDescriptor; // Can be extracted from data also if 
										// a ports property is set
		}
		public function set anchors(value:AnchorsDescriptor):void
		{
			_anchorsDescriptor = value;
		}
		
		public function get useStrictAnchoring():Boolean
		{
			return false;
		}
		public function set useStrictAnchoring(value:Boolean):void
		{
			//No need for settings
		}
		
		/* *********
		* Constructor
		**************/
		
		public function AbstractEditorRenderer()
		{
			super();
			_anchorsDescriptor = new AnchorsDescriptor();
			_anchorsDescriptor.type = AnchorsDescriptor.ANCHORS_TYPE_LIST;
			_anchorsDescriptor.anchorPoints = Vector.<Number>([0,0.5,0.5,0,1,0.5,0.5,1]);
		}
		
		/* *********
		* Helper Methods
		**************/
		
		protected function getColor():uint
		{
			var lC:uint;
			if(_isHighlighted && _highlightMode == Visualizer.RECTANGULAR_BASED_HIGHLIGHT)
				lC = _highlightLineColor;
			else if (_isSelected && _selectionMode == Visualizer.RECTANGULAR_BASED_HIGHLIGHT)
				lC = _selectionLineColor;
			else
				lC = _borderColor;
			return lC;
		}
		protected function getThickness():uint
		{
			return 1;
		}
		
	}
}