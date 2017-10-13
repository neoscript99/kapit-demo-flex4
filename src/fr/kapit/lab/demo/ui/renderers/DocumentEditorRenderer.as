package fr.kapit.lab.demo.ui.renderers
{
	import flash.display.Graphics;
	
	import fr.kapit.diagrammer.renderers.DefaultEditorRenderer;
	
	public class DocumentEditorRenderer extends DefaultEditorRenderer
	{
		public function DocumentEditorRenderer()
		{
			super();
			_itemWidth = 50;
			_itemHeight = 50;
		}
		
		override protected function drawShape(w:Number, h:Number, roundRadius:Number, g:Graphics=null):void
		{
			var cornerSizeW:int = 20 * (_itemWidth/100);
			var cornerSizeH:int = 20 * (_itemHeight/100);
			
			graphics.moveTo(0,0);
			graphics.lineTo(0,h);
			graphics.lineTo(w,h);
			graphics.lineTo(w,cornerSizeH);
			graphics.lineTo(w-cornerSizeW,0);
			graphics.lineTo(0,0);
			
			graphics.moveTo(w,cornerSizeH);
			graphics.lineTo(w-cornerSizeW,cornerSizeH);
			graphics.lineTo(w-cornerSizeW,0);
		}
	}
}