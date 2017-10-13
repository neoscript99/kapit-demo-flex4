package fr.kapit.lab.demo.ui.renderers
{
	import flash.display.Graphics;
	import fr.kapit.diagrammer.renderers.DefaultEditorRenderer;
	
	public class LosangeEditorRenderer extends DefaultEditorRenderer
	{
		public function LosangeEditorRenderer()
		{
			super();
			_itemWidth = 50;
			_itemHeight = 50;
		}
		
		override protected function drawShape(w:Number, h:Number, roundRadius:Number, g:Graphics=null):void
		{
			var cmd:Vector.<int> = new Vector.<int>();
			var path:Vector.<Number> = new Vector.<Number>();
			path.push(w/2, 0,
					  w, h/2,
					  w/2, h,
					  0, h/2,
					  w/2, 0);
			
			cmd.push(1,2,2,2,2);
			graphics.drawPath(cmd,path);
		}
	}
}