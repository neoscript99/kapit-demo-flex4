package fr.kapit.lab.demo.ui.renderers
{
	import flash.display.Graphics;
	import fr.kapit.diagrammer.renderers.DefaultEditorRenderer;
	
	public class TrapezeEditorRenderer extends DefaultEditorRenderer
	{
		public function TrapezeEditorRenderer()
		{
			super();
			_itemWidth = 50;
			_itemHeight = 50;
		}
		
		override protected function drawShape(w:Number, h:Number, roundRadius:Number, g:Graphics=null):void
		{
			var cmd:Vector.<int> = new Vector.<int>();
			var path:Vector.<Number> = new Vector.<Number>();
			path.push(w/6, 0,
				w*5/6, 0,
				w, h,
				0, h,
				w/6, 0);
			
			cmd.push(1,2,2,2,2);
			graphics.drawPath(cmd,path);
		}
	}
}