package fr.kapit.lab.demo.ui.renderers.standard
{
	import flash.display.Graphics;
	
	import fr.kapit.diagrammer.renderers.DefaultEditorRenderer;
	import fr.kapit.visualizer.Visualizer;
	
	public class RectangleEditorRenderer extends AbstractEditorRenderer
	{
		public function RectangleEditorRenderer()
		{
			super();
			_itemWidth = 50;
			_itemHeight = 50;
			backgroundColors=[0xFDFDFD, 0xE9E9E9];
		}
		
		override protected function drawShape(w:Number, h:Number, roundRadius:Number, g:Graphics=null):void
		{
			graphics.lineStyle(getThickness(),getColor(),_borderAlpha,false,'none');
			graphics.drawRect(0,0,w,h);
		}
	}
}