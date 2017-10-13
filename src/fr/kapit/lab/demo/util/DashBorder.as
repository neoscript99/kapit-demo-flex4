package fr.kapit.lab.demo.util
{
	import mx.core.UIComponent;
	
	[Style(name="borderColor",type="int",inherit="no")]
	[Style(name="borderThickness",type="int",inherit="no")]
	[Style(name="dashLength",type="Number",inherit="no")]
	[Style(name="gapLength",type="Number",inherit="no")]
	
	public class DashBorder extends UIComponent
	{
		private var dashlen:Number = 5;
		private var gaplen:Number = 5;
		
		public function DashBorder()
		{
			super();
		}
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp)
			invalidateDisplayList();
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var borderThickness:int = getStyle("borderThickness");
			var borderColor:int = getStyle("borderColor");
			dashlen = getStyle("dashLength");
			gaplen = getStyle("gapLength");
			graphics.clear();
			graphics.lineStyle(borderThickness, borderColor, 1)
			drawBorder(this.x, this.y, unscaledWidth, unscaledHeight,this.dashlen, this.gaplen);
		}
		protected function drawBorder(x1:Number, y1:Number, width:Number,height:Number,dashlen:Number, gaplen:Number) : void 
		{
			drawLine(x1, y1, x1 + width, y1, dashlen, gaplen);
			drawLine(x1 + width, y1, x1 + width, y1 + height, dashlen,gaplen);
			drawLine(x1 + width, y1 + height, x1, y1 + height, dashlen,gaplen);
			drawLine(x1, y1 + height, x1, y1, dashlen, gaplen);
		}
		public function drawLine(x1:Number, y1:Number, x2:Number,y2:Number,dashlen:Number, gaplen:Number): void {    
			if((x1 != x2) || (y1 != y2))
			{
				var incrlen:Number = dashlen + gaplen;
				
				var len:Number = Math.sqrt((x1 - x2) * (x1 - x2) + (y1 -
					y2) * (y1 - y2));
				var angle:Number = Math.atan((y2 - y1) / (x2 - x1));
				var steps:uint = len / (dashlen + gaplen);
				
				var dashstepx:Number = dashlen * Math.cos(angle);
				if(x2 < x1) 
					dashstepx *= -1;
				
				var dashstepy:Number = dashlen * Math.sin(angle);
				
				var gapstepx:Number = gaplen * Math.cos(angle);
				if(x2 < x1) 
					gapstepx *= -1;
				
				var gapstepy:Number = gaplen * Math.sin(angle);
				var stepcount:uint = 0;
				
				while ((stepcount++) < steps) 
				{       
					var dashstartx:Number;
					var dashstarty:Number;
					var dashendx:Number;
					var dashendy:Number;
					
					if(x1 == x2 && y1 != y2)
					{
						dashstartx = dashendx = x1;
						if(y2 > y1)
						{
							dashstarty = y1 + ((stepcount-1) * (dashlen + gaplen));             
							dashendy = dashstarty + dashlen;
						}
						else
						{
							dashstarty = y1 - ((stepcount-1) * (dashlen + gaplen));             
							dashendy = dashstarty - dashlen;
						}
					}
					else if(y1 == y2 && x1 != x2)
					{
						dashstarty = dashendy = y1;
						if(x2 > x1)
						{
							dashstartx = x1 + ((stepcount-1) * (dashlen + gaplen));
							dashendx = dashstartx + dashlen;
						}
						else
						{
							dashstartx = x1 - ((stepcount-1) * (dashlen + gaplen));
							dashendx = dashstartx - dashlen;
						}
					}
					graphics.moveTo(dashstartx, dashstarty);
					graphics.lineTo(dashendx, dashendy);
				}
			}
		}
		
	}
}
