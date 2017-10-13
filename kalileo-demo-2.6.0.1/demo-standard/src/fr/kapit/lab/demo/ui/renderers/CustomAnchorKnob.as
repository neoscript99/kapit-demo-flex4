package fr.kapit.lab.demo.ui.renderers
{
	import fr.kapit.diagrammer.Diagrammer;
	import fr.kapit.diagrammer.artifacts.AnchorKnob;
	import fr.kapit.diagrammer.constants.ControllerConstants;

	public class CustomAnchorKnob extends AnchorKnob
	{
		public function CustomAnchorKnob()
		{
			super();
		}
		
		protected function initParams():void
		{
			_borderThickness = 0;
			_borderColor = 0x2284C0;
			_borderAlpha = 1;
			_alpha = 1;
			_thickness = 8;
			_color=0xffffff;
			_shape = 'circle';
			_length = 8;
		}
		public override function draw():void
		{
			
			initParams();
			graphics.clear();
			if(isNaN(_length) || isNaN(_thickness))
				return;
			switch(_shape)
			{
				case 'line':
					graphics.lineStyle(_borderThickness,_borderColor,_borderAlpha);
					switch(_placement)
					{
						case ControllerConstants.TOP_LEFT:
							graphics.moveTo(0,_length);
							graphics.lineTo(0,0);
							graphics.lineTo(_length,0);
							break;
						case ControllerConstants.TOP_CENTER:
							graphics.moveTo(-_length*0.5,0);
							graphics.lineTo(_length*0.5,0);
							break;
						case ControllerConstants.TOP_RIGHT:
							graphics.moveTo(-_length,0);
							graphics.lineTo(0,0);
							graphics.lineTo(0,_length);
							break;
						case ControllerConstants.CENTER_RIGHT:
							graphics.moveTo(0,-_length*0.5);
							graphics.lineTo(0,_length*0.5);
							break;
						case ControllerConstants.BOTTOM_RIGHT:
							graphics.moveTo(0,-_length);
							graphics.lineTo(0,0);
							graphics.lineTo(-_length,0);
							break;
						case ControllerConstants.BOTTOM_CENTER:
							graphics.moveTo(-_length*0.5,0);
							graphics.lineTo(_length*0.5,0);
							break;
						case ControllerConstants.BOTTOM_LEFT:
							graphics.moveTo(_length,0);
							graphics.lineTo(0,0);
							graphics.lineTo(0,-_length);
							break;
						case ControllerConstants.CENTER_LEFT:
							graphics.moveTo(0,_length*0.5);
							graphics.lineTo(0,-_length*0.5);
							break;
					}	
					graphics.lineStyle(_thickness,_color,0);
					graphics.beginFill(0,0);
					graphics.drawRect(0,0,2,2);
					graphics.endFill();
					break;
				case 'rectangle':
					graphics.lineStyle(_borderThickness,_borderColor,_borderAlpha);
					graphics.beginFill(_color,_alpha);
					graphics.drawRect(-_length*0.5,-_thickness*0.5,_length,_thickness);
					break;
				case 'circle':
					graphics.lineStyle(_borderThickness,_borderColor,_borderAlpha);
					graphics.beginFill(_color,_alpha);
					var radius:Number = _length*0.5;
					graphics.drawCircle(0,0,radius);
					break;	
			}
			
		}
	}
}