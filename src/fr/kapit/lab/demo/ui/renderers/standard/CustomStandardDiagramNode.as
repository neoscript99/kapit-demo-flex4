package fr.kapit.lab.demo.ui.renderers.standard
{
	import flash.display.Graphics;
	
	import fr.kapit.diagrammer.renderers.DefaultEditorRenderer;
	import fr.kapit.visualizer.renderers.IAnchorable;
	import fr.kapit.visualizer.utils.data.AnchorsDescriptor;

	public class CustomStandardDiagramNode extends AbstractEditorRenderer implements IAnchorable
	{
		public function CustomStandardDiagramNode():void
		{
			backgroundColors=[0xFDFDFD, 0xE9E9E9];
			borderThickness=10;
		}
		
		override protected function drawShape(w:Number, h:Number, roundRadius:Number, g:Graphics=null):void
		{
			graphics.lineStyle(getThickness(),getColor(),_borderAlpha,false,'none');
			if(!g)
				graphics.drawRoundRectComplex(0, 0, w, h, roundRadius, roundRadius, roundRadius, roundRadius);
			else
				g.drawRoundRectComplex(0, 0, w, h, roundRadius, roundRadius, roundRadius, roundRadius);
			
		}
		
	}
}