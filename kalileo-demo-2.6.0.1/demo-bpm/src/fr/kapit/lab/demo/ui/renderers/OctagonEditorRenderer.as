package fr.kapit.lab.demo.ui.renderers
{
	import flash.display.Graphics;
	import fr.kapit.diagrammer.renderers.DefaultEditorRenderer;
	
	public class OctagonEditorRenderer extends DefaultEditorRenderer
	{
		public function OctagonEditorRenderer()
		{
			super();
			_itemWidth = 50;
			_itemHeight = 50;
		}
		
		override protected function drawShape(w:Number, h:Number, roundRadius:Number, g:Graphics=null):void
		{
			var cmd:Vector.<int> = new Vector.<int>();
			var path:Vector.<Number> = new Vector.<Number>();
			path.push(0, 2*h/3,
				0, h/3,
				w/3, 0,
				2*w/3, 0,
				w, h/3,
				w, 2*h/3,
				2*w/3, h,
				w/3, h,
				0, 2*h/3);
			
			cmd.push(1,2,2,2,2,2,2,2,2);
			graphics.drawPath(cmd,path);
		}
	}
}