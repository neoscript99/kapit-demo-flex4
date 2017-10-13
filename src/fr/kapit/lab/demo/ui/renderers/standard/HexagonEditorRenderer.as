package fr.kapit.lab.demo.ui.renderers.standard
{
	import flash.display.Graphics;
	
	import fr.kapit.visualizer.Visualizer;
	
	public class HexagonEditorRenderer extends AbstractEditorRenderer
	{
		public function HexagonEditorRenderer()
		{
			super();
			_itemWidth = 50;
			_itemHeight = 50;
			backgroundColors=[0xFDFDFD, 0xE9E9E9];
		}
		
		override protected function drawShape(w:Number, h:Number, roundRadius:Number, g:Graphics=null):void
		{
			graphics.lineStyle(getThickness(),getColor(),_borderAlpha,false,'none');
			var cmd:Vector.<int> = new Vector.<int>();
			var path:Vector.<Number> = new Vector.<Number>();
			path.push(0, h/4,
					  w/2, 0,
					  w, h/4,
					  w, 3*h/4,
					  w/2, h,
					  0, 3*h/4,
					  0, h/4);
			
			cmd.push(1,2,2,2,2,2,2);
			graphics.drawPath(cmd,path);
		}
	}
}