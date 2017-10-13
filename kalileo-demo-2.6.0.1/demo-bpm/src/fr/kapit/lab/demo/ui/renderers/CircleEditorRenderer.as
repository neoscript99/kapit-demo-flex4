package fr.kapit.lab.demo.ui.renderers
{
	import flash.display.Graphics;
	
	import fr.kapit.diagrammer.renderers.DefaultEditorRenderer;
	
	public class CircleEditorRenderer extends DefaultEditorRenderer
	{
		public function CircleEditorRenderer()
		{
			super();
			_itemWidth = 50;
			_itemHeight = 50;
		}
		
		override protected function drawShape(w:Number, h:Number, roundRadius:Number, g:Graphics=null):void
		{
			graphics.drawEllipse(0,0,w,h);
		}
		
		
	}
}