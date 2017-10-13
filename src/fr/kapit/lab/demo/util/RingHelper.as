////////////////////////////////////////////////////////////////////////////////
//
//  Kap IT 
//  Copyright 2010/2011 Kap IT 
//  All Rights Reserved. 
//
////////////////////////////////////////////////////////////////////////////////
package fr.kapit.lab.demo.util
{
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.geom.Matrix;

import fr.kapit.visualizer.base.IGroup;
import fr.kapit.visualizer.renderers.IGroupRenderer;

public class RingHelper
{
	public var lineThickness:uint = 0;

	//Spacing
	public var blankSpacing:Number = 6;
	public var spacing:Number = 10;

	//Background
	public var backgroundColor:uint=0xFFFFFF;
	public var backgroundAlpha:Number=1;

	//Border
	public var borderColor:uint=0xFFFFFF;
	public var borderAlpha:Number=1;

	//Wedge
	public var wedgeColors:Array = [0x29ABE2,0xD41444];
	public var wedgeBorderAlpha:Number=1;
	public var wedgeBackgroundAlpha:Number=1;

	public function RingHelper()
	{

	}

	public function drawRing(sprite:Sprite, values:Array, isSurrounding:Boolean=false):void
	{
		var graphics:Graphics = sprite.graphics;
		var d:Number = Math.sqrt(sprite.width*sprite.width+sprite.height*sprite.height);
		var dx:Number = (isSurrounding ? d : sprite.width)*sprite.scaleX;
		var dy:Number = (isSurrounding ? d : sprite.height)*sprite.scaleX;
		var cX:Number = (sprite.width-lineThickness)*0.5;
		var cY:Number = (sprite.height-lineThickness)*0.5;
		//Total Computation
		var i:uint=0;
		var total:Number = 0;
		var l:uint = values.length;
		for (i; i<l; ++i)
		{
			total += values[i];
		}
		var innerRadius:Number =  (dy+lineThickness-2*blankSpacing)*0.5;
		var outerRadius:Number = dx*0.5;
		//Drawing Directives
		graphics.clear();
		//Background
		if (backgroundAlpha>0)
		{
			graphics.lineStyle(lineThickness,borderColor,borderAlpha);
			graphics.beginFill(backgroundColor,backgroundAlpha);
			graphics.drawCircle(cX, cY, outerRadius);
		}
		//Ring
		if (2*blankSpacing<dx && 2*blankSpacing<dy)
		{
			var startAngle:Number = -90;
			for (i=0; i<l; ++i)
			{
				graphics.lineStyle(lineThickness, wedgeColors[i], wedgeBorderAlpha,false,LineScaleMode.NONE);
				graphics.beginFill( wedgeColors[i], wedgeBackgroundAlpha);
				drawSolidArc(graphics, cX, cY, innerRadius, outerRadius, startAngle, (values[i]/total)*360, 360);
				startAngle += (values[i]/total)*360;
			}
		}
		graphics.endFill();
	}

	public function drawSolidArc(g:Graphics, centerX:Number, centerY:Number, innerRadius:Number, outerRadius:Number, startAngle:Number, arcAngle:Number, steps:Number):void
	{
		var piRatio:Number = 2 * Math.PI/360;
		var angleStep:Number = arcAngle/steps;
		var angle:Number, i:Number, endAngle:Number;
		var xx:Number = centerX + Math.cos(startAngle * piRatio) * innerRadius;
		var yy:Number = centerY + Math.sin(startAngle * piRatio) * innerRadius;
		var startPoint:Object = {x:xx, y:yy};
		g.moveTo(xx, yy);
		for (i=1; i<=steps; i++)
		{
			angle = (startAngle + i * angleStep) * piRatio;
			xx = centerX + Math.cos(angle) * innerRadius;
			yy = centerY + Math.sin(angle) * innerRadius;
			g.lineTo(xx, yy);
		}
		endAngle = startAngle + arcAngle;
		for (i=0; i<=steps; i++)
		{
			angle = (endAngle - i * angleStep) * piRatio;
			xx = centerX + Math.cos(angle) * outerRadius;
			yy = centerY + Math.sin(angle) * outerRadius;
			g.lineTo(xx, yy);
		}
		g.lineTo(startPoint.x, startPoint.y);
	}
}
}
