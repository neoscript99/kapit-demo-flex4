package fr.kapit.lab.demo.ui.controllers
{
	import flash.events.Event;
	
	import fr.kapit.diagrammer.constants.ControllerConstants;
	import fr.kapit.diagrammer.controls.DiagramSpriteController;
	import fr.kapit.visualizer.base.ISprite;
	import fr.kapit.visualizer.utils.PathComputationUtils;
	
	public class CustomDiagramSpriteController extends DiagramSpriteController
	{
		public function CustomDiagramSpriteController()
		{
			super();
			supportMiddleKnobs=false;
			
		}
		override protected function handleAddedToStage(event:Event):void
		{
			super.handleAddedToStage(event);
			parent.setChildIndex(this,0);
		}
		override public function draw():void
		{
			if(!_childrenCreated)
				return;
			updateParams();
			
			var w:Number = ISprite(_item).width+paddingLeft+paddingRight;
			var h:Number = ISprite(_item).height+paddingBottom+paddingTop;
			//width = w;
			//height = h;
			graphics.clear();
			graphics.lineStyle(lineThickness,lineColor,lineAlpha);
			var path:Vector.<Number> = new Vector.<Number>;
			path[0] = 0;
			path[1] = 0;
			path[2] = w;
			path[3] = 0;
			path[4] = w;
			path[5] = h;
			path[6] = 0;
			path[7] = h;
			path[8] =0;
			path[9] = 0;
			
	
			var commands:Vector.<int> = new Vector.<int>;
				commands[0] = 1;
				commands[1] = 2;
				commands[2] = 2;
				commands[3] = 2;
				commands[4] = 2;
				graphics.drawPath(commands,path);
		
			if(knobShape=='circle')
				knobThickness = knobLength;
			
			_TLKnob.x = 0;
			_TLKnob.y = 0;
			updateKnob(_TLKnob);
			
			if(supportMiddleKnobs)
			{
				if(!_TCKnob)
					_TCKnob = addKnob(ControllerConstants.TOP_CENTER);
				_TCKnob.x = w*0.5;
				_TCKnob.y = -knobThickness*0.5;
				updateKnob(_TCKnob);	
			}
			
			_TRKnob.x = w;
			_TRKnob.y =0;
			updateKnob(_TRKnob);
			
			if(supportMiddleKnobs)
			{
				if(!_CRKnob)
					_CRKnob = addKnob(ControllerConstants.CENTER_RIGHT);
				_CRKnob.x = w+knobLength*0.5;
				_CRKnob.y = h*0.5;
				updateKnob(_CRKnob);
			}
			
			_BRKnob.x = w;
			_BRKnob.y = h;
			updateKnob(_BRKnob);
			
			if(supportMiddleKnobs)
			{
				if(!_BCKnob)
					_BCKnob = addKnob(ControllerConstants.BOTTOM_CENTER)
				_BCKnob.x = w*0.5;
				_BCKnob.y = h+knobThickness*0.5;
				updateKnob(_BCKnob);
			}
			
			_BLKnob.x = 0;
			_BLKnob.y = h;
			updateKnob(_BLKnob);
			
			if(supportMiddleKnobs)
			{
				if(!_CLKnob)
					_CLKnob = addKnob(ControllerConstants.CENTER_LEFT)
				_CLKnob.x = -knobLength*0.5;
				_CLKnob.y = h*0.5;
				updateKnob(_CLKnob);
			}
		}
	}
}