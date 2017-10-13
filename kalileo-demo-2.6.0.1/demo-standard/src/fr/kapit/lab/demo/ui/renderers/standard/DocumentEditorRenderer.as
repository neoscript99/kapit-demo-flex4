package fr.kapit.lab.demo.ui.renderers.standard
{
	import flash.display.Graphics;
	
	
	public class DocumentEditorRenderer extends AbstractEditorRenderer
	{
		public function DocumentEditorRenderer()
		{
			super();
			_itemWidth = 50;
			_itemHeight = 50;
			backgroundColors=[0xFDFDFD, 0xE9E9E9];
		}
		
		override protected function drawShape(w:Number, h:Number, roundRadius:Number, g:Graphics=null):void
		{
			var cornerSizeW:int = 20 * (_itemWidth/100);
			var cornerSizeH:int = 20 * (_itemHeight/100);
			graphics.lineStyle(getThickness(),getColor(),_borderAlpha,false,'none');
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